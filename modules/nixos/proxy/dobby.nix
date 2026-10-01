{ config, ... }:
let
  # Add or remove a block here; host defaults to <name>.aranferran.com.
  # host overrides only the name; the domain is always appended.
  # url creates a backend; service alone reuses a backend (or api@internal).
  entries = {
    traefik = {
      service = "api@internal";
      middlewares = [ "traefik-auth" ];
    };
    glances = {
      url = "http://localhost:${toString config.services.glances.port}";
    };
    home = {
      url = "http://localhost:${toString config.services.homepage-dashboard.listenPort}";
    };
    home-assistant = {
      host = "homeassistant";
      url = "http://127.0.0.1:${toString config.services.home-assistant.config.http.server_port}";
      middlewares = [ "secure-headers" ];
    };
    dns = {
      service = "adguardhome";
      url = "http://localhost:${toString config.services.adguardhome.port}";
      middlewares = [ "secure-headers" ];
    };
    jellyfin = {
      url = "http://localhost:8096";
    };
    jellyfin-local = {
      host = "jellyfin.local";
      service = "jellyfin";
    };
    bazarr = {
      url = "http://localhost:${toString config.services.bazarr.listenPort}";
    };
    lingarr = {
      url = "http://localhost:9876";
    };
    prowlarr = {
      url = "http://localhost:${toString config.services.prowlarr.settings.server.port}";
    };
    radarr = {
      url = "http://localhost:${toString config.services.radarr.settings.server.port}";
    };
    sonarr = {
      url = "http://localhost:${toString config.services.sonarr.settings.server.port}";
    };
    jellyseerr = {
      url = "http://localhost:${toString config.services.jellyseerr.port}";
    };
    transmission = {
      url = "http://localhost:${toString config.services.transmission.settings.rpc-port}";
    };
    flaresolverr = {
      url = "http://localhost:${toString config.services.flaresolverr.port}";
    };
    immich = {
      url = "http://localhost:${toString config.services.immich.port}";
    };
    ollama = {
      url = "http://localhost:${toString config.services.ollama.port}";
    };
    trilium = {
      url = "http://localhost:${toString config.services.trilium-server.port}";
    };
    shiori = {
      url = "http://localhost:${toString config.services.shiori.port}";
    };
    stirling-pdf = {
      host = "pdf";
      url = "http://localhost:${toString config.services.stirling-pdf.environment.SERVER_PORT}";
    };
    freemarg = {
      url = "http://localhost:8881";
    };
    paperless = {
      url = "http://localhost:${toString config.services.paperless.port}";
    };
    paperless-ai = {
      url = "http://localhost:8080";
    };
    libretranslate = {
      url = "http://localhost:${toString config.services.libretranslate.port}";
    };
  };
in
{
  imports = [ ./common.nix ];

  networking.firewall.allowedTCPPorts = [ 8080 ];

  services.traefik.dynamicConfigOptions.http = import ./http.nix {
    domain = "aranferran.com";
    inherit entries;
  };
}
