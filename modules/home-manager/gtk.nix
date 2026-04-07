{ pkgs, lib, config, ... }:
{
  home.sessionVariables.GTK_THEME = "rose-pine";

  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
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
