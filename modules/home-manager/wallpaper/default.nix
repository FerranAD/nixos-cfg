{ pkgs, ... }:
{
    services.hyprpaper.enable = true;
    services.hyprpaper.settings = {
        ipc = "on";
        splash = false;

      preload = [
        "${./cloud-coffee.jpg}"
      ];

      wallpaper = [
        ",${./cloud-coffee.jpg}"
      ];
    };
}