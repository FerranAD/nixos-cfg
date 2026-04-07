{ lib, inputs, config, ... }:
{
  imports = [
    inputs.nixarr.nixosModules.default
  ];
  services.transmission.settings = {
    rpc-host-whitelist = lib.strings.concatStringsSep "," [ "transmission.aranferran.com" ];
  };
  services.flaresolverr.enable = true;

  networking.firewall.allowedTCPPorts = [
    30335
  ];

  networking.firewall.allowedUDPPorts = [
    30335
  ];

  users.users.jellyfin.extraGroups = [ "render" ];

  nixarr = {
    enable = true;
    mediaDir = "/data/nixarr/media";
    stateDir = "/data/nixarr/media/.state/nixarr";

    vpn = {
      enable = true;
      wgConf = config.age.secrets."airvpn-dobby-wg.conf".path;
    };

    jellyfin.enable = true;

    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 30335;
    };

    bazarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    sonarr.enable = true;
    jellyseerr.enable = true;
  };
}
