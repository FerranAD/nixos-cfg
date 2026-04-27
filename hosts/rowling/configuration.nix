{
  pkgs,
  ...
}:
{
  imports = [
    ./agenix.nix
    ./hardware-configuration.nix
    
    ../../modules/nixos/network/rowling-network.nix
    ../../modules/nixos/users/server-users.nix
    ../../modules/nixos/boot/rowling-boot.nix
    ../../modules/nixos/proxy-rowling.nix
    ../../modules/nixos/nix-settings.nix
    ../../modules/nixos/minecraft.nix
    ../../modules/nixos/openssh.nix
    ../../modules/nixos/locale.nix
  ];

  environment.systemPackages = with pkgs; [
    htop
    neovim
  ];

  system.stateVersion = "24.05";
}
