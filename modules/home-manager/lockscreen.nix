{ pkgs, ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "${pkgs.hyprlock}/bin/hyprlock --grace 15";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;

    settings = {
      # variables
      "$font" = "Monospace";

      general = {
        hide_cursor = false;
      };

      animations = {
        enabled = true;
        bezier = [
          "linear, 1, 1, 0, 0"
        ];
        animation = [
          "fadeIn, 1, 5, linear"
          "fadeOut, 1, 5, linear"
          "inputFieldDots, 1, 2, linear"
        ];
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "20%, 5%";
          outline_thickness = 3;

          inner_color = "rgba(30, 30, 46, 0.6)";
          outer_color = "rgb(cba6f7) rgb(89b4fa) 45deg";
          check_color = "rgb(a6e3a1) rgb(94e2d5) 120deg";
          fail_color = "rgb(f38ba8) rgb(fab387) 40deg";
          font_color = "rgb(cdd6f4)";

          fade_on_empty = false;
          rounding = 15;

          font_family = "$font";
          placeholder_text = "Input password...";
          fail_text = "$PAMFAIL";

          # dots_text_format = "*";
          # dots_size = 0.4;
          dots_spacing = 0.3;

          # hide_input = true;

          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        # TIME
        {
          monitor = "";
          text = "$TIME";
          font_size = 90;
          font_family = "$font";

          position = "-30, 0";
          halign = "right";
          valign = "top";
        }

        # DATE
        {
          monitor = "";
          text = ''cmd[update:60000] date +"%A, %d %B %Y"'';
          font_size = 25;
          font_family = "$font";

          position = "-30, -150";
          halign = "right";
          valign = "top";
        }

        # KEYBOARD LAYOUT (click to switch)
        {
          monitor = "";
          text = "$LAYOUT[US,ES]";
          font_size = 24;
          onclick = "hyprctl switchxkblayout all next";

          position = "250, -20";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
