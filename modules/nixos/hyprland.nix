{
  pkgs,
  inputs,
  ... 
}: {
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  # For hyprpanel battery widget to work
  services.gvfs.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}