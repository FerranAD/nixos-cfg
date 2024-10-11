{ pkgs, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        exit-on-keyboard-focus-loss = "no";
      };
    };
  };
}