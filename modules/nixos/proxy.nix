{ config, ... }:
{
  # Based on https://aottr.dev/posts/2025/05/homelab-setting-up-traefik-reverse-proxy-with-ssl-on-nixos/#setting-up-traefik-on-nixos

  networking.firewall.allowedTCPPorts = [
    80
    443
    8080
  ];

  systemd.services.traefik.serviceConfig.EnvironmentFile = [
    config.age.secrets."porkbun-traefik.env".path
  ];

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
          rule = "Host(`traefik.aranferran.com`)";
          service = "api@internal";
          tls.certResolver = "letsencrypt";
        };

        glances = {
          entryPoints = [ "websecure" ];
          rule = "Host(`glances.aranferran.com`)";
          service = "glances";
          tls.certResolver = "letsencrypt";
        };

        home = {
          entryPoints = [ "websecure" ];
          rule = "Host(`home.aranferran.com`)";
          service = "home";
          tls.certResolver = "letsencrypt";
        };

        jellyfin = {
          entryPoints = [ "websecure" ];
          rule = "Host(`jellyfin.aranferran.com`)";
          service = "jellyfin";
          tls.certResolver = "letsencrypt";
        };

        jellyfin-local = {
          entryPoints = [ "websecure" ];
          rule = "Host(`jellyfin.local.aranferran.com`)";
          service = "jellyfin";
          tls.certResolver = "letsencrypt";
        };

        bazarr = {
          entryPoints = [ "websecure" ];
          rule = "Host(`bazarr.aranferran.com`)";
          service = "bazarr";
          tls.certResolver = "letsencrypt";
        };

        prowlarr = {
          entryPoints = [ "websecure" ];
          rule = "Host(`prowlarr.aranferran.com`)";
          service = "prowlarr";
          tls.certResolver = "letsencrypt";
        };

        radarr = {
          entryPoints = [ "websecure" ];
          rule = "Host(`radarr.aranferran.com`)";
          service = "radarr";
          tls.certResolver = "letsencrypt";
        };

        sonarr = {
          entryPoints = [ "websecure" ];
          rule = "Host(`sonarr.aranferran.com`)";
          service = "sonarr";
          tls.certResolver = "letsencrypt";
        };

        jellyseerr = {
          entryPoints = [ "websecure" ];
          rule = "Host(`jellyseerr.aranferran.com`)";
          service = "jellyseerr";
          tls.certResolver = "letsencrypt";
        };

        transmission = {
          entryPoints = [ "websecure" ];
          rule = "Host(`transmission.aranferran.com`)";
          service = "transmission";
          tls.certResolver = "letsencrypt";
        };

        flaresolverr = {
          entryPoints = [ "websecure" ];
          rule = "Host(`flaresolverr.aranferran.com`)";
          service = "flaresolverr";
          tls.certResolver = "letsencrypt";
        };

        immich = {
          entryPoints = [ "websecure" ];
          rule = "Host(`immich.aranferran.com`)";
          service = "immich";
          tls.certResolver = "letsencrypt";
        };

        ollama = {
          entryPoints = [ "websecure" ];
          rule = "Host(`ollama.aranferran.com`)";
          service = "ollama";
          tls.certResolver = "letsencrypt";
        };
      };
      http.services = {
        glances.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.glances.port}"; }
        ];
        home.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.homepage-dashboard.listenPort}"; }
        ];
        jellyfin.loadBalancer.servers = [
          { url = "http://localhost:8096"; }
        ];
        bazarr.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.bazarr.listenPort}"; }
        ];
        prowlarr.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.prowlarr.settings.server.port}"; }
        ];
        radarr.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.radarr.settings.server.port}"; }
        ];
        sonarr.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.sonarr.settings.server.port}"; }
        ];
        jellyseerr.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.jellyseerr.port}"; }
        ];
        transmission.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.transmission.settings.rpc-port}"; }
        ];
        flaresolverr.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.flaresolverr.port}"; }
        ];
        immich.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.immich.port}"; }
        ];
        ollama.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.ollama.port}"; }
        ];
      };
    };
  };
}
