{ config, pkgs, inputs, ... }:

{
  imports =
    [
     ../../modules/home-manager/alacritty.nix
     ../../modules/home-manager/vscode.nix
     ../../modules/home-manager/fonts.nix
     ../../modules/home-manager/hyprland
     ../../modules/home-manager/pass.nix
     ../../modules/home-manager/wofi.nix
    ];

  nixpkgs.config.allowUnfree = true;

  home.username = "ferran";
  home.homeDirectory = "/home/ferran";

  home.stateVersion = "24.05";

  home.packages = [
  	pkgs.dolphin
	  pkgs.hello
    pkgs.grimblast
    pkgs.jq
    pkgs.brightnessctl
    pkgs.playerctl
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  programs.home-manager.enable = true;
}
