{ pkgs, inputs, ... }:

{
  imports = [
    ../../modules/home-manager/thunderbird.nix
    ../../modules/home-manager/screenshots.nix
    ../../modules/home-manager/lockscreen.nix
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/hyprpaper.nix
    ../../modules/home-manager/clipboard.nix
    ../../modules/home-manager/hyprpanel.nix
    ../../modules/home-manager/pyprland.nix
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/udiskie.nix
    ../../modules/home-manager/spotify.nix
    ../../modules/home-manager/vscode.nix
    ../../modules/home-manager/fuzzel.nix
    ../../modules/home-manager/shell.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/fonts.nix
    ../../modules/home-manager/hyprland
    ../../modules/home-manager/gtk.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/qt.nix
    ../../modules/home-manager/pass
    ../../modules/home-manager/gpg
    inputs.hyprpanel.homeManagerModules.hyprpanel
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home.username = "ferran";
  home.homeDirectory = "/home/ferran";

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    vesktop
    wl-clipboard
    swappy
    hyprpicker
    monero-gui
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
