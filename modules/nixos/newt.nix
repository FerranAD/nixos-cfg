{ config, ... }:
{
  services.newt = {
    enable = true;
    environmentFile = config.age.secrets."newt.env".path;
    settings.endpoint = "https://pangolin.oracle.aranferran.com";
    blueprint.public-resources = {
      jellyfin = {
        name = "Jellyfin";
        protocol = "http";
        full-domain = "jellyfin.oracle.aranferran.com";
        auth.sso-enabled = false;
        targets = [
          {
            hostname = "127.0.0.1";
            port = 8096;
            method = "http";
          }
        ];
      };
      jellyseerr = {
        name = "Jellyseerr";
        protocol = "http";
        full-domain = "jellyseerr.oracle.aranferran.com";
        auth.sso-enabled = false;
        targets = [
          {
            hostname = "127.0.0.1";
            port = config.services.jellyseerr.port;
            method = "http";
          }
        ];
      };
    };
  };
}
