{
  pkgs,
  ...
}:
{

  programs.hyprpanel = {
    enable = true;
    hyprland.enable = true;
    overwrite.enable = true;

    theme = "catppuccin_macchiato";
    # theme = "catppuccin_macchiato_split";
    # theme = "catppuccin_macchiato_vivid";

    layout = {
      "bar.layouts" = {
        "0" = {
          left = [
            "dashboard"
            "workspaces"
            "kbinput"
            "windowtitle"
          ];
          middle = [ "media" ];
          right = [
            "volume"
            "network"
            "bluetooth"
            "battery"
            "systray"
            "clock"
            "notifications"
          ];
        };
        "1" = {
          left = [
            "dashboard"
            "workspaces"
            "kbinput"
            "windowtitle"
          ];
          middle = [ "media" ];
          right = [
            "volume"
            "network"
            "bluetooth"
            "battery"
            "systray"
            "clock"
            "notifications"
          ];
        };
        "2" = {
          left = [
            "dashboard"
            "workspaces"
            "kbinput"
            "windowtitle"
          ];
          middle = [ "media" ];
          right = [
            "volume"
            "network"
            "bluetooth"
            "battery"
            "systray"
            "clock"
            "notifications"
          ];
        };
      };
    };

    settings = {
      bar.launcher.autoDetectIcon = true;
      bar.workspaces.workspaces = 9;
      bar.workspaces.monitorSpecific = false;

      # Needed to avoid pyprland scratchpads showing up in the workspaces
      bar.workspaces.ignored = "-98";

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

      theme.bar.transparent = true;

      theme.font = {
        name = "JetBrainsMono Nerd Font";
        size = "16px";
      };
    };
  };
}
