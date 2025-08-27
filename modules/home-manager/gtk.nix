{ pkgs, lib, ... }:
{
  home.sessionVariables.GTK_THEME = "rose-pine";

  gtk = {
    enable = true;
    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    # iconTheme = {
    #   name = lib.mkForce "rose-pine";
    #   package = pkgs.rose-pine-icon-theme;
    # };
  };
}
