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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhmrNzsfb3fmufOfByUNngG4CeeyrsYrGX3mfx4N1FGTUOO/x3+0TqnAgHlm1J8SdfYxC8uM38VQa8TcwsYPGkjvLUuv8vnnZQj6BScpOs7TesUtL9j6qUU++1y60tRkpBF9MeGPQ4ADQRZG6XCvMh3l5MvLNLWhPMWw3+PUMoA2ogXw4kj8TrkXHBoUdrkjb8AW6AG17SIOLhqmnHtrcymkHyC4PWG4zUYZgHGWYOIz5yKGB7jYnjw/UAxPlcbSWZJlvuIaII6aUNJeEI87K+7QfmQzMfIuBzmx1AFSwt3yV5TRoWDN4u3Ns+Cxb+uei9xxEzCqHITE+VTIIgOBf6HPB28HnYgE4wetaEmgg0gfl3tUwNOBIQEDJxsmfvLs7Ws3NAqOziESMlJfv38TClTc/6WYQ0sNJXr721nsRfjwTREbRYEYlrOK2CxoS0OokcRPKuaTVOqznbp8MvBEy38/jRA+9CpChZshkJ6vVWaxO2/EK+SkPCgddtva9u9EIih/mlSGXam2vTd/hSJpJ9W35VDZvp/labRPWTmYTICiKE1Ii9LLBiZJINHHipnlaFYuEioWR5mh+qP41UNCsvaCv/XQuhXhJvm93P3tWHi3A72cOeH5gKuMnC5oQVX4Fi7+qMusT29Z4lB2LmyXGsFrbfXt3NeyfbJer+PKSPvw== cardno:24_684_025"
    ];
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhmrNzsfb3fmufOfByUNngG4CeeyrsYrGX3mfx4N1FGTUOO/x3+0TqnAgHlm1J8SdfYxC8uM38VQa8TcwsYPGkjvLUuv8vnnZQj6BScpOs7TesUtL9j6qUU++1y60tRkpBF9MeGPQ4ADQRZG6XCvMh3l5MvLNLWhPMWw3+PUMoA2ogXw4kj8TrkXHBoUdrkjb8AW6AG17SIOLhqmnHtrcymkHyC4PWG4zUYZgHGWYOIz5yKGB7jYnjw/UAxPlcbSWZJlvuIaII6aUNJeEI87K+7QfmQzMfIuBzmx1AFSwt3yV5TRoWDN4u3Ns+Cxb+uei9xxEzCqHITE+VTIIgOBf6HPB28HnYgE4wetaEmgg0gfl3tUwNOBIQEDJxsmfvLs7Ws3NAqOziESMlJfv38TClTc/6WYQ0sNJXr721nsRfjwTREbRYEYlrOK2CxoS0OokcRPKuaTVOqznbp8MvBEy38/jRA+9CpChZshkJ6vVWaxO2/EK+SkPCgddtva9u9EIih/mlSGXam2vTd/hSJpJ9W35VDZvp/labRPWTmYTICiKE1Ii9LLBiZJINHHipnlaFYuEioWR5mh+qP41UNCsvaCv/XQuhXhJvm93P3tWHi3A72cOeH5gKuMnC5oQVX4Fi7+qMusT29Z4lB2LmyXGsFrbfXt3NeyfbJer+PKSPvw== cardno:24_684_025"
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
