{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/udiskie.nix
    ../../modules/home-manager/gpg
  ];

  home.username = "ferran";
  home.homeDirectory = "/home/ferran";

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    hello
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
