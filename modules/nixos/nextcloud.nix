{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
    {
      addr = "127.0.0.1";
      port = 8880;
    }
  ];
  services = {
    nextcloud = {
      enable = true;
      hostName = "cloud.oracle.aranferran.com";
      package = pkgs.nextcloud33;

      database.createLocally = true;
      maxUploadSize = "1G";
      https = true;

      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit notes tasks collectives;
        # Spreed = Nextcloud Talk
        spreed = pkgs.fetchNextcloudApp {
          appName = "spreed";
          appVersion = "23.0.6";
          url = "https://github.com/nextcloud-releases/spreed/releases/download/v23.0.6/spreed-v23.0.6.tar.gz";
          hash = "sha256-D/S4OCkpWm9DqGZlTSfWGnVIsAWfcdlFX8mCQ6M6qjk=";
          license = "agpl3Plus";
        };
      };

      config = {
        overwriteProtocol = "https";
        defaultPhoneRegion = "ES";
        dbtype = "pgsql";
        adminuser = "admin";
        adminpassFile = config.age.secrets.nextcloud-admin-pass.path;
      };
    };
  };
}
