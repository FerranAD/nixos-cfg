{ lib, inputs, ... }:
{
  imports = [
    inputs.nixarr.nixosModules.default
  ];
  services.transmission.settings = {
    rpc-host-whitelist = lib.strings.concatStringsSep "," [ "transmission.aranferran.com" ];
  };
  services.flaresolverr.enable = true;
  users.users.jellyfin.extraGroups = [ "render" ];
  nixarr = {
    enable = true;
    mediaDir = "/data/nixarr/media";
    stateDir = "/data/nixarr/media/.state/nixarr";

    # vpn = {
    #   enable = true;
    #   # WARNING: This file must _not_ be in the config git directory
    #   # You can usually get this wireguard file from your VPN provider
    #   wgConf = "/data/.secret/wg.conf";
    # };

    jellyfin.enable = true;

    transmission = {
      enable = true;
      vpn.enable = false;
      peerPort = 50000; # Set this to the port forwarded by your VPN
    };

    bazarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    sonarr.enable = true;
    jellyseerr.enable = true;
  };
}
