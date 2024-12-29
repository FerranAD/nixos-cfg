{
  ...
}:
{

 programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
    hyprland.enable = true;
    overwrite.enable = true;

    theme = "catppuccin_macchiato";
    # theme = "catppuccin_macchiato_split";
    # theme = "catppuccin_macchiato_vivid";

    layout = {
      "bar.layouts" = {
        "0" = {
          left = [ "dashboard" "workspaces" "kbinput" "windowtitle" ];
          middle = [ "media" ];
          right = [ "volume" "network" "bluetooth" "battery" "systray" "clock" "notifications" ];
        };
        "1" = {
          left = [ "dashboard" "workspaces" "kbinput" "windowtitle" ];
          middle = [ "media" ];
          right = [ "volume" "network" "bluetooth" "battery" "systray" "clock" "notifications" ];
        };
        "2" = {
          left = [ "dashboard" "workspaces" "kbinput" "windowtitle" ];
          middle = [ "media" ];
          right = [ "volume" "network" "bluetooth" "battery" "systray" "clock" "notifications" ];
        };
      };
    };

    settings = {
      bar.launcher.autoDetectIcon = true;
      # bar.launcher.icon = "";
      bar.workspaces.hideUnoccupied = false;
      bar.workspaces.workspaces = 9;

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
        weather.location = "Lleida";
        # weather.key = "${config.age.secrets.weather-api.path}";
      };

      menus.dashboard = {
        directories.enabled = false;
        shortcuts.enabled = false;
        stats.enable_gpu = true;
        powermenu.confirmation = false;
      };

      terminal = "alacritty";

      theme.bar.transparent = true;

      theme.font = {
        name = "JetBrainsMono Nerd Font";
        size = "16px";
      };
    };
  };
}
