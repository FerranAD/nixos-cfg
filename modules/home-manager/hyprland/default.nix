{ pkgs, lib, ... }:
{
  # Hint electron apps to use wayland
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.hyprland = {
    plugins = with pkgs.hyprlandPlugins; [
      hyprexpo
    ];
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgba(88888888)";
        "col.inactive_border" = "rgba(00000088)";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          brightness = 1.0;
          contrast = 1.0;
          noise = 0.01;

          vibrancy = 0.2;
          vibrancy_darkness = 0.5;

          passes = 4;
          size = 7;

          popups = true;
          popups_ignorealpha = 0.2;
        };

        shadow = {
          enabled = true;
          color = "rgba(00000055)";
          ignore_window = true;
          offset = "0 15";
          range = 100;
          render_power = 2;
          scale = 0.97;
        };
      };

      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 4;
          bg_col = "rgb(000000)";

          enable_gesture = true;
          gesture_distance = 300;
          gesture_positive = false;
        };
      };

      animations = {
        enabled = true;
        animation = [
          "border, 1, 2, default"
          "fade, 1, 4, default"
          "windows, 1, 3, default, popin 80%"
          "workspaces, 1, 2, default, slide"
        ];
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = true;

        # enable variable refresh rate (effective depending on hardware)
        vrr = 1;
      };

      input = {
        kb_layout = "us, es";
        kb_options = "caps:swapescape";
      };

      cursor.no_hardware_cursors = true;

      monitor = [ ",preferred,auto,auto" ];

      windowrulev2 = [
        "float, class:(udiskie), title:(udiskie)"
        "float, class:(codium), title:(Open File)"
        "opacity 0.8, class:(alacritty-dropterm)"
        "float, class:(org.ksnip.ksnip)"
        "size >30% >50%, class:(org.ksnip.ksnip)"
        "float, class:(clipse)"
        "size 40% 40%, class:(clipse)"
        "plugin:hyprbars:nobar, floating:0"
      ];

      "$mod" = "SUPER";

      bind = import ./keybindings.nix { inherit pkgs lib; };

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindl = [
        '', switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1, disable"''
        '', switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1,1920x1080@144.00,0x0,0"''
      ];

      bindr = [
        "SUPER, SUPER_L, exec, ${pkgs.hyprpanel}/bin/hyprpanel t dashboardmenu"
      ];

      exec-once = [
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "${pkgs.pyprland}/bin/pypr"
        "${pkgs.wlsunset}/bin/wlsunset -l 41.614159 -L 0.625800"
        "${pkgs.clipse}/bin/clipse -listen"
      ];
    };
  };
}
