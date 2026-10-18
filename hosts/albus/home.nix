{
  config,
  pkgs,
  inputs,
  ...
}:

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
    ../../modules/home-manager/nixvim.nix
    ../../modules/home-manager/shell.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/fonts.nix
    ../../modules/home-manager/hyprland
    ../../modules/home-manager/gtk.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/qt.nix
    ../../modules/home-manager/pass
    ../../modules/home-manager/gpg
  ];

  home.username = "ferran";
  home.homeDirectory = "/home/ferran";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    vesktop
    wl-clipboard
    swappy
    hyprpicker
    monero-gui
    zotero
    loupe
    file-roller
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplicationPackages = with pkgs; [
      loupe
      file-roller
      vlc
      onlyoffice-desktopeditors
    ];
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
      "text/plain" = [ "code.desktop" ];
      "text/markdown" = [ "code.desktop" ];
      "text/csv" = [ "onlyoffice-desktopeditors.desktop" ];
      "text/tab-separated-values" = [ "onlyoffice-desktopeditors.desktop" ];
      "application/json" = [ "code.desktop" ];
      "application/pdf" = [ "firefox.desktop" ];
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      "x-scheme-handler/codex" = [ "chatgpt.desktop" ];
    };
    associations.added = config.xdg.mimeApps.defaultApplications;
  };

  # Replace the existing unmanaged associations; defaults now live in Nix.
  xdg.configFile."mimeapps.list".force = true;
  xdg.dataFile."applications/mimeapps.list".force = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
