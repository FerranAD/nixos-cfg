
{ pkgs, inputs, ... }:
{
  wayland.windowManager.hyprland = {
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
      exec-once = [
        "${inputs.hyprpanel.packages.x86_64-linux.default}/bin/hyprpanel"
      ];
    };
  };
}