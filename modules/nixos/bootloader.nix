{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
	"nvidia-drm.fbdev=1" "nvidia-drm.modeset=1" "ec_sys.write_support=1"
  ];
}