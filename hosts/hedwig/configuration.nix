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
    ../../modules/nixos/locale.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    {
      disabledModules = [ "profiles/base.nix" ];
    }
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    loader = {
      grub.enable = lib.mkDefault false;
      grub.configurationLimit = 5;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    firewall.enable = false;
    hostName = "hedwig";
    networkmanager.enable = true;
    wireless = {
      interfaces = [ "wlan0" ];
      enable = false;
    };
    nftables =
      let
        wanIf = "end0";
        tailscale_ip_client = "100.78.176.53";
        portLow = "18000";
        portHigh = "34000";
      in
      {
        enable = true;
        
        ruleset = ''
          table ip nat {
            chain prerouting {
              type nat hook prerouting priority 0;

              # Forward TCP + UDP port range from A's WAN -> B via Tailscale
              iifname "${wanIf}" tcp dport ${portLow}-${portHigh} dnat to ${tailscale_ip_client}
              iifname "${wanIf}" udp dport ${portLow}-${portHigh} dnat to ${tailscale_ip_client}
            }

            chain postrouting {
              type nat hook postrouting priority 100;

              # SNAT on the tailscale leg so A accepts the packets (appears from B's 100.x)
              oifname "tailscale0" ip daddr ${tailscale_ip_client} tcp dport ${portLow}-${portHigh} masquerade
              oifname "tailscale0" ip daddr ${tailscale_ip_client} udp dport ${portLow}-${portHigh} masquerade

              oifname "${wanIf}" masquerade
            }
          }
        '';
      };
  };

  nix.settings.experimental-features = [
    "flakes"
  ];

  users.users.ferran = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
      htop
      neovim
      git
      wget
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
