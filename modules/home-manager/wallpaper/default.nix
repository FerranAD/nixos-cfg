{ pkgs, ... }:
{
    services.hyprpaper.enable = true;
    services.hyprpaper.settings = {
        ipc = "on";
        splash = false;

      preload = [
        "~/nixos/modules/home-manager/wallpaper/cloud-coffee.jpg"
      ];

      wallpaper = [
        ",~/nixos/modules/home-manager/wallpaper/cloud-coffee.jpg"
      ];
    };
}