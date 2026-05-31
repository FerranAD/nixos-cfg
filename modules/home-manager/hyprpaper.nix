{ ... }:
{
  services.hyprpaper.enable = true;
  services.hyprpaper.settings = {
    ipc = "on";
    splash = false;

    wallpaper = [
      {
        monitor = "";
        path = "${../../images/wallpaper.jpg}";
      }
    ];
  };
}
