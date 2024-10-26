{ pkgs, ... }: {
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita-Dark";
      package = pkgs.adwaita-icon-theme;
    };
  };
}
