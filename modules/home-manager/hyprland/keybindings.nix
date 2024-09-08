{ pkgs, ... }:
let
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  grimblast = "${pkgs.grimblast}/bin/grimblast";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  jq = "${pkgs.jq}/bin/jq";
  keyboardChange = pkgs.pkgs.writeShellScriptBin "keyboardChange" ''
      ${hyprctl} \
    --batch "$(
      ${hyprctl} devices -j |
        ${jq} -r '.keyboards[] | .name' |
        while IFS= read -r keyboard; do
          printf '%s %s %s;' 'switchxkblayout' "$keyboard" 'next'
        done
    )"
     ${hyprctl} notify -1 10000 "rgb(ff1ea3)" "Changed keyboard!"
  '';
  passMenu = pkgs.pkgs.writeShellScriptBin "passMenu" ''
    export PASSWORD_STORE_DIR=/home/ferran/.password-store
    ${pkgs.wofi-pass}/bin/wofi-pass -c
  '';
  movementKeys = [
    "$mod, W, killactive"
    "$mod, h, movefocus, l"
    "$mod, l, movefocus, r"
    "$mod, k, movefocus, u"
    "$mod, j, movefocus, d"
    "$mod SHIFT, 0, movetoworkspace, special:magic"
    "$mod, space, togglespecialworkspace, magic"
  ];
  programKeys = [
    "$mod, N, exec, ${pkgs.firefox}/bin/firefox"
    "$mod, M, exec, ${pkgs.wofi}/bin/wofi --show run"
    "$mod, y, exec, ${passMenu}/bin/passMenu"
    "$mod, Return, exec, ${pkgs.alacritty}/bin/alacritty"
    "$mod, i, exec, ${keyboardChange}/bin/keyboardChange"
    ", XF86MonBrightnessDown, exec, ${brightnessctl} set 5%-"
    ", XF86MonBrightnessUp, exec, ${brightnessctl} set +5%"
    ", Print, exec, ${grimblast} copy area"
  ];
  volumeKeys = [
    ", XF86AudioRaiseVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
    ", XF86AudioLowerVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
    ", XF86AudioMute, exec, ${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
    ", XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
    ", XF86AudioPlay, exec, ${playerctl} play-pause"
    ", XF86AudioNext, exec, ${playerctl} next"
    ", XF86AudioPrev, exec, ${playerctl} previous"
  ];
  workspacesKeyBindings = builtins.concatLists (builtins.genList
    (
      x:
      let
        ws =
          let
            c = (x + 1) / 10;
          in
          builtins.toString (x + 1 - (c * 10));
      in
      [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    )
    9);
in
movementKeys ++ programKeys ++ volumeKeys ++ workspacesKeyBindings