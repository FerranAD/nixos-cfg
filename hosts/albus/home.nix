{ config, pkgs, inputs, ... }:

{
  imports =
    [
     ../../modules/home-manager/alacritty.nix
     ../../modules/home-manager/hyprpaper.nix
     ../../modules/home-manager/pyprland.nix
     ../../modules/home-manager/udiskie.nix
     ../../modules/home-manager/vscode.nix
     ../../modules/home-manager/fuzzel.nix
     ../../modules/home-manager/fonts.nix
     ../../modules/home-manager/hyprland
     ../../modules/home-manager/gtk.nix
     ../../modules/home-manager/pass
     ../../modules/home-manager/gpg
    ];

  home.username = "ferran";
  home.homeDirectory = "/home/ferran";

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
  	dolphin
	  hello
    grimblast
    jq
    brightnessctl
    playerctl
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  programs.home-manager.enable = true;
}
