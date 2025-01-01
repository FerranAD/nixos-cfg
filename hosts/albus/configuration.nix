{
  inputs,
  pkgs,
  nurPkgs,
  self,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.default

    ./agenix.nix
    ./hardware-configuration.nix
    ../../modules/nixos/nix-settings.nix
    ../../modules/nixos/network.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/power.nix
    ../../modules/nixos/boot.nix
    ../../modules/nixos/yubikey

    #Desktop
    ../../modules/nixos/xdg-portal.nix
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/thunar.nix
    ../../modules/nixos/audio.nix
    ../../modules/cattpuccin.nix
    ../../modules/nixos/sddm.nix
  ];

  hardware = {
    bluetooth.enable = true;
    uinput.enable = true;
  };

  services.printing.enable = true;
  services.gvfs.enable = true;

  home-manager = {
    extraSpecialArgs = {
      inherit inputs nurPkgs;
    };
    useGlobalPkgs = true;
    users = {
      "ferran" = import ./home.nix;
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.ferran = {
      isNormalUser = true;
      description = "Ferran";
      extraGroups = [
        "networkmanager"
        "wheel"
        "udev"
      ];
      packages = [
        pkgs.kitty
        pkgs.dolphin
        pkgs.material-design-icons
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    gnumake
    agenix-rekey
  ];

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.zsh.setOptions = [
    "EXTENDED_HISTORY"
    "APPEND_HISTORY"
    "EMACS"
  ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "24.05";
}
