{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./agenix.nix

    ../../modules/nixos/network/rubeus-network.nix
    ../../modules/nixos/backups/backups-server.nix
    ../../modules/nixos/backups/borg-status-ui.nix
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

  services.borgStatusUi.enable = true;

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
    config.services.borgStatusUi.port
  ];

  system.stateVersion = "24.05";
}
