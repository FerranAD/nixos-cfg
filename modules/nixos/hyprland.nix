{ pkgs, inputs, ... }:
{
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };
    rtkit.enable = true;
  };
}
