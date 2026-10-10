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
    ../../modules/nixos/proxy/rowling.nix
    ../../modules/nixos/nix-settings.nix
    ../../modules/nixos/privatebin.nix
    ../../modules/nixos/minecraft.nix
    ../../modules/nixos/nextcloud.nix
    ../../modules/nixos/ntfy.nix
    ../../modules/nixos/o2cloud-webdav.nix
    ../../modules/nixos/openssh.nix
    ../../modules/nixos/vikunja.nix
    ../../modules/nixos/locale.nix
  ];

  virtualisation.containers.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";

  environment.systemPackages = with pkgs; [
    htop
    neovim
  ];

  system.stateVersion = "24.05";
}
