{ pkgs, ... }:
let
#   appLauncher = pkgs.writeShellScriptBin "app-launcher" ''
#     pkill fuzzel
#     fuzzel
#   '';
  dmenu = pkgs.writeShellScriptBin "dmenu" ''
    pkill fuzzel
    fuzzel -d $@
   '';
  emoji = pkgs.writeShellScriptBin "emoji" ''
    pkill fuzzel
    rofimoji --selector fuzzel --action $1
  '';
#   clipboard = pkgs.writeShellScriptBin "clipboard-picker" ''
#     pkill fuzzel
#     cliphist list | dmenu | cliphist decode | wl-copy
#   '';
in
{
  home.packages = [ emoji ];
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        exit-on-keyboard-focus-loss = "no";
      };
    };
  };
}