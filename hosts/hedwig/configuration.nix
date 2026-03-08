{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    {
      disabledModules = [ "profiles/base.nix" ];
    }
    ./agenix.nix

    ../../modules/nixos/network/hedwig-network.nix
    ../../modules/nixos/tailscale/exit-node.nix
    ../../modules/nixos/users/server-users.nix
    ../../modules/nixos/boot/hedwig-boot.nix
    ../../modules/nixos/nix-settings.nix
    ../../modules/nixos/openssh.nix
    ../../modules/nixos/locale.nix

  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  system.stateVersion = "24.05";
}
