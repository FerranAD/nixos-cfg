{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./agenix.nix

    ../../modules/nixos/network/rubeus-network.nix
    ../../modules/nixos/users/server-users.nix
    ../../modules/nixos/boot/rubeus-boot.nix
    ../../modules/nixos/tailscale/client.nix
    ../../modules/nixos/nix-settings.nix
    ../../modules/nixos/openssh.nix
    ../../modules/nixos/locale.nix
  ];

  environment.systemPackages = with pkgs; [
    htop
    neovim
  ];

  system.stateVersion = "24.05";
}
