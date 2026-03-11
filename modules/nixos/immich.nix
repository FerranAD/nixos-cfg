{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    immich-cli
    immich-go
  ];
  systemd.tmpfiles.rules = [
    "d /data/immich 0750 immich immich - -"
  ];
  services.immich = {
    enable = true;
    mediaLocation = "/data/immich";
  };
}
