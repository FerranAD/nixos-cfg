{ config, lib, ... }:
{
  # Based on https://aottr.dev/posts/2025/05/homelab-setting-up-traefik-reverse-proxy-with-ssl-on-nixos/#setting-up-traefik-on-nixos

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  systemd.services.traefik.serviceConfig.EnvironmentFile = [
    config.age.secrets."porkbun-traefik.env".path
  ];

  services.traefik = {
    enable = true;
    # Keep shared proxy state here when another module also configures Traefik.
    dataDir = lib.mkForce "/var/lib/traefik";

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
          transport.respondingTimeouts.readTimeout = lib.mkDefault "0s";
          http.tls.certResolver = "letsencrypt";
        };
      };

      log = {
        level = "DEBUG";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      certificatesResolvers.letsencrypt.acme = lib.mkForce {
        email = "ferran@aranferran.com";
        storage = "${config.services.traefik.dataDir}/acme.json";
        dnsChallenge.provider = "porkbun";
      };

      api.dashboard = true;
      api.insecure = false;
    };

    dynamicConfigOptions.http = {
      middlewares."secure-headers".headers = {
        sslRedirect = true;
        stsSeconds = 31536000;
        stsIncludeSubdomains = true;
        stsPreload = true;
        forceSTSHeader = true;
        contentTypeNosniff = true;
        browserXssFilter = true;
        referrerPolicy = "same-origin";
        customRequestHeaders.X-Forwarded-Proto = "https";
      };

      middlewares."traefik-auth".basicAuth.usersFile = config.age.secrets."traefik-dashboard-users".path;
    };
  };
}
