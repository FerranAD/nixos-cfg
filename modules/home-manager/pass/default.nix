{ pkgs, ... }:
let
  passMenu = pkgs.writeShellScriptBin "passMenu" ''
    export PASSWORD_STORE_DIR=/home/ferran/.password-store
    wofi-pass -c -s
  '';
in
{
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = {
      PASSWORD_STORE_DIR = "/home/ferran/.password-store";
      PASSWORD_STORE_CLIP_TIME = "90";
    };
  };
  home.packages = [
    ((pkgs.wofi-pass.override { wofi = pkgs.fuzzel; }).overrideAttrs {
      patches = [ ./fuzzel.patch ];
    })
    passMenu
  ];
}
