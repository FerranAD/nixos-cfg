{ pkgs, inputs, ... }:

{
  imports = [
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/hyprpaper.nix
    ../../modules/home-manager/hyprpanel.nix
    ../../modules/home-manager/pyprland.nix
    ../../modules/home-manager/udiskie.nix
    ../../modules/home-manager/vscode.nix
    ../../modules/home-manager/fuzzel.nix
    ../../modules/home-manager/fonts.nix
    ../../modules/home-manager/hyprland
    ../../modules/home-manager/gtk.nix
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/pass
    ../../modules/home-manager/gpg
    inputs.agenix.homeManagerModules.default
  ];

  home.username = "ferran";
  home.homeDirectory = "/home/ferran";

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    vesktop
    wl-clipboard-rs
    swappy
    hyprpicker
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
