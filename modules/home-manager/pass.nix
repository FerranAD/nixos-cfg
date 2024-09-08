{ pkgs, ... }:
{
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = {
      PASSWORD_STORE_DIR = "/home/ferran/.password-store";
      PASSWORD_STORE_CLIP_TIME = "90";
    };
  };
  home.packages = [ pkgs.wofi-pass ];
}