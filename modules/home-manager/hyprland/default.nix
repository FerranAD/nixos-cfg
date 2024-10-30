{ pkgs, lib, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [ { path = "${../../../images/wallpaper.jpg}"; } ];
    };
  };

  wayland.windowManager.hyprland =
    let
      restartHyprpanel = pkgs.pkgs.writeShellScriptBin "restartHyprpanel" ''
        "${pkgs.hyprpanel}/bin/hyprpanel" -q
        "${pkgs.hyprpanel}/bin/hyprpanel" &
      '';
      monitorHotplugCallback = pkgs.pkgs.writeShellScriptBin "monitorHotplugCallback" ''
        handle() {
          case $1 in
            monitoradded*) "${pkgs.hyprpanel}/bin/hyprpanel" -q && "${pkgs.hyprpanel}/bin/hyprpanel" & ;;
          esac
        }

        "${pkgs.socat}/bin/socat" -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
      '';
    in
    {
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
          '', switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1,1920x1080@144.00,0x0,0" && ${lib.getExe restartHyprpanel}''
        ];
        exec-once = [
          "${pkgs.hyprpanel}/bin/hyprpanel"
          "${pkgs.hyprpaper}/bin/hyprpaper"
          "${lib.getExe monitorHotplugCallback}"
          "${pkgs.pyprland}/bin/pypr"
          "${pkgs.wlsunset}/bin/wlsunset -l 41.614159 -L 0.625800"
        ];
      };
    };
}
