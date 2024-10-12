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
      ../../modules/nixos/xdg-portal.nix
      ../../modules/nixos/hyprland.nix
      ../../modules/nixos/yubikey.nix
      ../../modules/nixos/nvidia.nix
      ../../modules/nixos/locale.nix
      ../../modules/nixos/power.nix
      ../../modules/nixos/audio.nix
      ../../modules/cattpuccin.nix
      ../../modules/nixos/sddm.nix
      ../../modules/nixos/boot
      inputs.home-manager.nixosModules.default
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware = {
    bluetooth.enable = true;
    uinput.enable = true;
  };

  networking = {
    hostName = "albus";
    networkmanager.enable = true;
  };

  services.printing.enable = true;
  services.gvfs.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
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
      pkgs.material-design-icons
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
