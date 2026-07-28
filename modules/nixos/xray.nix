{
  config,
  pkgs,
  ...
}:

let
  domain = "xray.oracle.aranferran.com";
  port = 10000;
  certDir = config.security.acme.certs.${domain}.directory;
  xrayConfigFile = "/run/xray-config/config.json";
in
{
  users.groups.xray-cert = { };

  security.acme = {
    acceptTerms = true;
    defaults.email = "ferran@aranferran.com";

    certs.${domain} = {
      group = "xray-cert";
      dnsProvider = "porkbun";
      environmentFile = config.age.secrets."porkbun-traefik.env".path;
      reloadServices = [ "xray.service" ];
    };
  };

  # Generate the Xray JSON at runtime so the client UUID never enters the Nix store.
  # Retrieve it after deployment with:
  #
  #   ssh root@rowling cat /var/lib/xray/client-uuid
  systemd.services.xray-config = {
    description = "Generate Xray VLESS server configuration";
    before = [ "xray.service" ];

    path = [
      pkgs.jq
      pkgs.util-linux
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      StateDirectory = "xray";
      StateDirectoryMode = "0700";

      RuntimeDirectory = "xray-config";
      RuntimeDirectoryMode = "0700";

      UMask = "0077";
    };

    script = ''
      set -euo pipefail

      uuid_file="/var/lib/xray/client-uuid"

      if [ ! -s "$uuid_file" ]; then
        uuidgen --random > "$uuid_file"
        chmod 0600 "$uuid_file"
      fi

      uuid="$(cat "$uuid_file")"

      jq -n \
        --arg uuid "$uuid" \
        --arg certificate "${certDir}/fullchain.pem" \
        --arg privateKey "${certDir}/key.pem" \
        --argjson port ${toString port} \
        '{
          "log": {
            "loglevel": "warning"
          },

          "inbounds": [
            {
              "tag": "vless-in",
              "listen": "127.0.0.1",
              "port": $port,
              "protocol": "vless",

              "settings": {
                "clients": [
                  {
                    "id": $uuid,
                    "flow": "xtls-rprx-vision",
                    "level": 0,
                    "email": "primary-client"
                  }
                ],
                "decryption": "none"
              },

              "streamSettings": {
                "network": "tcp",
                "security": "tls",

                "tlsSettings": {
                  "rejectUnknownSni": true,
                  "minVersion": "1.2",

                  "alpn": [
                    "h2"
                  ],

                  "certificates": [
                    {
                      "certificateFile": $certificate,
                      "keyFile": $privateKey
                    }
                  ]
                }
              }
            }
          ],

          "outbounds": [
            {
              "tag": "direct",
              "protocol": "freedom",
              "settings": {}
            },
            {
              "tag": "block",
              "protocol": "blackhole",
              "settings": {}
            }
          ],

          "routing": {
            "domainStrategy": "IPIfNonMatch",

            "rules": [
              {
                "type": "field",
                "ip": [
                  "0.0.0.0/8",
                  "10.0.0.0/8",
                  "100.64.0.0/10",
                  "127.0.0.0/8",
                  "169.254.0.0/16",
                  "172.16.0.0/12",
                  "192.168.0.0/16",
                  "224.0.0.0/4",
                  "::1/128",
                  "fc00::/7",
                  "fe80::/10"
                ],
                "outboundTag": "block"
              },
              {
                "type": "field",
                "protocol": [
                  "bittorrent"
                ],
                "outboundTag": "block"
              }
            ]
          }
        }' > "${xrayConfigFile}"

      chmod 0600 "${xrayConfigFile}"
    '';
  };

  services.xray = {
    enable = true;
    settingsFile = xrayConfigFile;
  };

  systemd.services.xray = {
    requires = [ "xray-config.service" ];

    wants = [
      "network-online.target"
      "acme-${domain}.service"
    ];

    after = [
      "network-online.target"
      "xray-config.service"
      "acme-${domain}.service"
    ];

    serviceConfig.SupplementaryGroups = [ "xray-cert" ];
  };
}
