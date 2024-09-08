{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ yubikey-manager yubikey-personalization age-plugin-yubikey yubioath-flutter ];
  services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
  services.dbus.packages = [ pkgs.gcr ];
  services.pcscd.enable = true;
  programs.yubikey-touch-detector.enable = false;
}