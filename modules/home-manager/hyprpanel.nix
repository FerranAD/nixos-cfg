{
  pkgs,
  ...
}:
let
  default_layout = {
    "left" = [
      "dashboard"
      "workspaces"
      "kbinput"
      "battery"
      "hypridle"
      "windowtitle"
    ];
    "middle" = [
      "media"
    ];
    "right" = [
      "volume"
      "bluetooth"
      "network"
      "clock"
      "notifications"
      "power"
    ];
  };
in
{

  programs.hyprpanel = {
    enable = true;
    hyprland.enable = true;
    overwrite.enable = true;

    theme = "catppuccin_frappe_split";

    layout = {
      "bar.layouts" = {
        "0" = default_layout;
        "1" = default_layout;
      };
    };

    settings = {
      bar.launcher.autoDetectIcon = true;

      # Needed to avoid pyprland scratchpads showing up in the workspaces
      bar.workspaces.ignored = "-98";

      bar.workspaces = {
        workspaces = 9;
        monitorSpecific = false;
        applicationIconOncePerWorkspace = true;
        show_icons = true;
        icons.occupied = "";
      };
      bar.customModules.hypridle.startCommand = "systemctl --user start hypridle.service";
      bar.customModules.hypridle.stopCommand = "systemctl --user stop hypridle.service";
      bar.customModules.hypridle.isActiveCommand = "systemctl --user status hypridle.service | grep -q 'Active: active (running)' && echo 'yes' || echo 'no'";

      menus.power = {
        confirmation = false;
        lowBatteryNotification = true;
      };

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
        weather.location = "Lleida";
        weather.key = "/run/user/1000/agenix/weather-api";
      };

      menus.dashboard = {
        directories.enabled = false;
        stats.enable_gpu = true;
        powermenu.confirmation = false;
        powermenu.avatar.image = "${../../images/avatar.png}";
        shortcuts = {
          left.shortcut1.command = "${pkgs.firefox}/bin/firefox";
          left.shortcut1.icon = "󰈹";
          left.shortcut1.tooltip = "Firefox";
          left.shortcut2.command = "spotify";
          left.shortcut2.icon = "";
          left.shortcut2.tooltip = "Spotify";
          left.shortcut3.command = "${pkgs.vesktop}/bin/vesktop";
          left.shortcut3.icon = "";
          left.shortcut3.tooltip = "Discord";
          left.shortcut4.command = "${pkgs.fuzzel}/bin/fuzzel --show run";
          left.shortcut4.icon = "";
          left.shortcut4.tooltip = "Search apps";
          right.shortcut1.command = "${pkgs.hyprpicker}/bin/hyprpicker -a";
          right.shortcut1.icon = "";
          right.shortcut1.tooltip = "Color picker";
          right.shortcut3.command = "${pkgs.vscode}/bin/code /home/ferran/nixos";
          right.shortcut3.icon = "";
          right.shortcut3.tooltip = "Edit NixOS config";
        };
      };

      terminal = "alacritty";

      theme = {
        bar = {
          transparent = false;
          opacity = 80;
          scaling = 80;
          buttons = {
            radius = "0.8em";
            style = "split";
            y_margins = "0.45em";
          };
        };
        font = {
          name = "JetBrainsMono Nerd Font Mono Thin";
          weight = 600;
          size = "16px";
        };
      };
    };
  };
}
