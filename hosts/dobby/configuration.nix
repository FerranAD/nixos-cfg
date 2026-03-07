{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./agenix.nix
    ./disko.nix
    ./hardware-configuration.nix
    ../../modules/nixos/locale.nix
  ];

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.initrd.systemd.enable = true;

  networking = {
    firewall.enable = false;
    hostName = "dobby";
    networkmanager.enable = true;
  };

  users.users.ferran = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      htop
      git
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDO11F5Mw0JYYi/IgmgfV7bRZS7yDi5y/FSDpM3Ep6Qt openpgp:0xBC69F42C"
    ];
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDO11F5Mw0JYYi/IgmgfV7bRZS7yDi5y/FSDpM3Ep6Qt openpgp:0xBC69F42C"
    ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    authKeyFile = config.age.secrets.tailscale-authkey.path;
    extraSetFlags = [
      "--advertise-exit-node"
    ];
  };

  system.stateVersion = "24.05";
}
