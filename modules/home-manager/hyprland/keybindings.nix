{ pkgs, lib, ... }:
let
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  grimblast = "${pkgs.grimblast}/bin/grimblast";
  swappy = "${pkgs.swappy}/bin/swappy";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  fuzzel = "${pkgs.fuzzel}/bin/fuzzel";
  jq = "${pkgs.jq}/bin/jq";
  getKeyboardLayout = pkgs.pkgs.writeShellScriptBin "getKeyboardLayout" ''
    ${hyprctl} devices -j |
    ${jq} -r '.keyboards[] | .active_keymap' | head -n1
  '';
  keyboardChange = pkgs.pkgs.writeShellScriptBin "keyboardChange" ''
      ${hyprctl} \
    --batch "$(
      ${hyprctl} devices -j |
        ${jq} -r '.keyboards[] | .name' |
        while IFS= read -r keyboard; do
          printf '%s %s %s;' 'switchxkblayout' "$keyboard" 'next'
        done
    )"
    ${pkgs.libnotify}/bin/notify-send --icon=${./icons/keyboard-layout.svg} "Layout changed to" "$(${lib.getExe getKeyboardLayout})" --expire-time=1500
  '';
  movementKeys = [
    "$mod, W, killactive"
    "$mod, h, movefocus, l"
    "$mod, l, movefocus, r"
    "$mod, k, movefocus, u"
    "$mod, j, movefocus, d"
    "$mod, f, togglefloating"
    "$mod SHIFT, tab, fullscreen"
    "$mod, tab, fullscreen, 1"
  ];
  programKeys = [
    "$mod, N, exec, ${pkgs.firefox}/bin/firefox"
    "$mod, M, exec, ${fuzzel} --show run"
    "$mod, e, exec, ${pkgs.rofimoji}/bin/rofimoji --selector fuzzel --action copy"
    "$mod, y, exec, passMenu"
    "$mod SHIFT, l, exec, hyprlock"
    "$mod, Return, exec, ${pkgs.alacritty}/bin/alacritty"
    "$mod, i, exec, ${keyboardChange}/bin/keyboardChange"
    "$mod, space, exec, ${pkgs.pyprland}/bin/pypr toggle term"
    "$mod, u ,exec, ${pkgs.hyprpanel}/bin/hyprpanel t powermenu"
    ", XF86MonBrightnessDown, exec, ${brightnessctl} set 5%-"
    ", XF86MonBrightnessUp, exec, ${brightnessctl} set +5%"
    ", Print, exec, ${grimblast} save area - | ${swappy} -f -"
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
  workspacesKeyBindings = builtins.concatLists (
    builtins.genList (
      x:
      let
        ws = if x < 5 then builtins.toString (x + 1) else "F" + builtins.toString (x - 4);
      in
      [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    ) 9
  );
in
movementKeys ++ programKeys ++ volumeKeys ++ workspacesKeyBindings
