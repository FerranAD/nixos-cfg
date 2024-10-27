{ inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/locale.nix
    inputs.home-manager.nixosModules.default
  ];

  nix.settings.experimental-features = [
    "flakes"
  ];

  networking = {
    hostName = "hedwig";
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    useGlobalPkgs = true;
    users = {
      "ferran" = import ./home.nix;
    };
  };

  users.users.ferran = {
    isNormalUser = true;
    description = "Ferran";
    extraGroups = [
      "wheel"
    ];
    packages = [
      pkgs.htop
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    gnumake
  ];

  system.stateVersion = "24.05";
}
