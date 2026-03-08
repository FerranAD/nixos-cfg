{
  inputs,
  pkgs,
  nurPkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.default

    ./hardware-configuration.nix
    ./agenix.nix
    ./disko.nix

    ../../modules/nixos/network/albus-network.nix
    ../../modules/nixos/users/albus-users.nix
    ../../modules/nixos/tailscale/client.nix
    ../../modules/nixos/boot/albus-boot.nix
    ../../modules/nixos/power-settings.nix
    ../../modules/nixos/nix-settings.nix
    ../../modules/nixos/openssh.nix
    ../../modules/impermanence.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/yubikey

    #Desktop
    ../../modules/nixos/desktop/file-manager.nix
    ../../modules/nixos/desktop/xdg-portal.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/audio.nix
    ../../modules/nixos/desktop/sddm.nix
    ../../modules/catppuccin.nix
  ];

  environment.systemPackages = with pkgs; [
    wget
    git
    gnumake
    agenix-rekey
    nwg-displays
    nixos-anywhere
    texliveFull
    signal-desktop-bin
    onlyoffice-desktopeditors
    mpv
    htop
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs nurPkgs;
    };
    useGlobalPkgs = true;
    users = {
      "ferran" = import ./home.nix;
    };
  };

  virtualisation.virtualbox.host.enable = true;

  hardware = {
    bluetooth.enable = true;
    uinput.enable = true;
  };

  services.printing.enable = true;
  services.gvfs.enable = true;

  programs.zsh.enable = true;
  programs.zsh.setOptions = [
    "EXTENDED_HISTORY"
    "APPEND_HISTORY"
    # "EMACS"
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "24.05";
}
