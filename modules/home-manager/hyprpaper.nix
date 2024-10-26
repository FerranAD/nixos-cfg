{ pkgs, ... }: {
  services.hyprpaper.enable = true;
  services.hyprpaper.settings = {
    ipc = "on";
    splash = false;

    preload = [ "${../../images/wallpaper.jpg}" ];

    wallpaper = [ ",${../../images/wallpaper.jpg}" ];
  };
}
