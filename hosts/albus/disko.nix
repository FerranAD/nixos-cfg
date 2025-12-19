{
  inputs,
  ...
}:
let
  btrfsopt = [
    "compress=zstd"
    "noatime"
    "ssd"
    "space_cache=v2"
    "user_subvol_rm_allowed"
  ];
in
{
  imports = [ inputs.disko.nixosModules.disko ];
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.fido2Support = false; # We let systemd-cryptenroll handle fido2
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            label = "EFI-2";
            name = "ESP";
            size = "2G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
                "umask=0077"
              ];
            };
          };
          swap = {
            size = "32G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          luks = {
            name = "root";
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              extraFormatArgs = [
                # Used to pass additional arguments to the cryptsetup command.
                "--iter-time 1000" # Slows down unlocking but protects better against brute-force attacks.
              ];
              settings = {
                allowDiscards = true;
                # Used to set additional options in /etc/crypttab, see https://github.com/NixOS/nixpkgs/blob/d599e459065269b8e0de294ccc73b28ba30ab480/nixos/modules/system/boot/luksroot.nix#L1118
                crypttabExtraOpts = [
                  "fido2-device=auto"
                  "token-timeout=10s"
                ];
              };
              content = {
                type = "lvm_pv";
                vg = "root_vg";
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      root_vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/root" = {
                  mountOptions = [
                    "subvol=root"
                  ]
                  ++ btrfsopt;
                  mountpoint = "/";
                };
                "/persist" = {
                  mountOptions = [
                    "subvol=persist"
                  ]
                  ++ btrfsopt;
                  mountpoint = "/persist";
                };
                "/nix" = {
                  mountOptions = [
                    "subvol=nix"
                  ]
                  ++ btrfsopt;
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
    };
  };
}
