{ pkgs, inputs, ... }:
{
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".hyprland;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };
    rtkit.enable = true;
  };
}
