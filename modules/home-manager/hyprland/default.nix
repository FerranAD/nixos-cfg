{ pkgs, lib, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [ { path = "${../../../images/wallpaper.jpg}"; } ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # plugins = [
    #   inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
    # ];
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      windowrulev2 = [
        "float, class:(udiskie), title:(udiskie)"
        "opacity 0.8, class:(alacritty-dropterm)"
        "float, class:(org.ksnip.ksnip)"
        "size >30% >50%, class:(org.ksnip.ksnip)"
        "float, class:(clipse)"
        "size 40% 40%, class:(clipse)"
      ];
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
      "$mod" = "SUPER";
      input = {
        kb_layout = "us, es";
        kb_options = "caps:swapescape";
      };
      bind = import ./keybindings.nix { inherit pkgs lib; };
      monitor = [ ",preferred,auto,auto" ];
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
