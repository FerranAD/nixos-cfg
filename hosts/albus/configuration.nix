{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos/audio.nix
      ../../modules/nixos/nvidia.nix
      ../../modules/nixos/locale.nix
      ../../modules/nixos/fonts.nix
      ../../modules/nixos/yubikey.nix
      ../../modules/nixos/hyprland.nix
      ../../modules/nixos/bootloader.nix
      inputs.home-manager.nixosModules.default
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
    uinput.enable = true;
    gpgSmartcards.enable = true;
  };

  networking = {
    hostName = "albus";
    networkmanager.enable = true;
  };

  services.printing.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "ferran" = import ./home.nix;
    };
  };

  users.users.ferran = {
    isNormalUser = true;
    description = "Ferran";
    extraGroups = [ "networkmanager" "wheel" "udev"];
    packages = [
      pkgs.kitty
      pkgs.dolphin
      pkgs.hyprpanel
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    gnumake
  ];

  programs.firefox.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "24.05";
}
