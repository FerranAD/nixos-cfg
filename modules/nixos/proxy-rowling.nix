{ config, ... }:
{
  # Based on https://aottr.dev/posts/2025/05/homelab-setting-up-traefik-reverse-proxy-with-ssl-on-nixos/#setting-up-traefik-on-nixos

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  systemd.services.traefik.serviceConfig.EnvironmentFile = [
    config.age.secrets."porkbun-traefik.env".path
  ];

  services.glances.enable = true;

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };

        websecure = {
          address = ":443";
          asDefault = true;
          transport.respondingTimeouts.readTimeout = "0s";
          http.tls.certResolver = "letsencrypt";
        };
      };

      log = {
        level = "DEBUG";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      certificatesResolvers.letsencrypt.acme = {
        email = "ferran@aranferran.com";
        storage = "${config.services.traefik.dataDir}/acme.json";
        dnschallenge.provider = "porkbun";
      };

      environmentFile = [ config.age.secrets."porkbun-traefik.env".path ];

      api.dashboard = true;
      api.insecure = false;
    };

    dynamicConfigOptions = {
      http.routers = {
        traefik = {
          entryPoints = [ "websecure" ];
          rule = "Host(`traefik.oracle.aranferran.com`)";
          service = "api@internal";
          tls.certResolver = "letsencrypt";
        };

        glances = {
          entryPoints = [ "websecure" ];
          rule = "Host(`glances.oracle.aranferran.com`)";
          service = "glances";
          tls.certResolver = "letsencrypt";
        };
      };
      http.services = {
        glances.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.glances.port}"; }
        ];
      };
    };
  };
}
