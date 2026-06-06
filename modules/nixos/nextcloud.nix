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
        inherit notes tasks;
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
