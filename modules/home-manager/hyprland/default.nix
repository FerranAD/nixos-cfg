
{ pkgs, lib, inputs, ... }:
{
  wayland.windowManager.hyprland = 
    let
      restartHyprpanel = pkgs.pkgs.writeShellScriptBin "restartHyprpanel" ''
        "${pkgs.hyprpanel}/bin/hyprpanel" -q
        "${pkgs.hyprpanel}/bin/hyprpanel"
      '';
      monitorHotplugCallback = pkgs.pkgs.writeShellScriptBin "monitorHotplugCallback" ''
        handle() {
          case $1 in
            monitoradded*) ${lib.getExe restartHyprpanel} ;;
          esac
        }

        "${pkgs.socat}" -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done 
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
      "$mod" = "SUPER";
      input = {
        kb_layout = "us, es";
        kb_options = "caps:swapescape";
      };
      bind = import ./keybindings.nix { inherit pkgs; };
      monitor = [
        "HDMI-A-1,1920x1080@143.98Hz,auto,auto"
        ",preferred,auto,auto"
      ]; 
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bindl = [
        ", switch:on:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, disable\""
        ", switch:off:Lid Switch,exec,hyprctl keyword monitor \"eDP-1,1920x1080@144.00,0x0,0\" && ${lib.getExe restartHyprpanel}"
      ];
      exec-once = [
        "${pkgs.hyprpanel}/bin/hyprpanel"
        "${lib.getExe monitorHotplugCallback}"
      ];
    };
  };
}