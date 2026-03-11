{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./agenix.nix

    ../../modules/nixos/network/dobby-network.nix
    ../../modules/nixos/tailscale/exit-node.nix
    ../../modules/nixos/users/server-users.nix
    ../../modules/nixos/boot/dobby-boot.nix
    ../../modules/nixos/nix-settings.nix
    ../../modules/nixos/intel-arc.nix
    ../../modules/nixos/dashboard.nix
    ../../modules/nixos/openssh.nix
    ../../modules/nixos/immich.nix
    ../../modules/nixos/nixarr.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/proxy.nix
  ];

  virtualisation.containers.enable = true;

  environment.systemPackages = with pkgs; [
    nvtopPackages.intel
    intel-gpu-tools
  ];

  system.stateVersion = "24.05";
}
