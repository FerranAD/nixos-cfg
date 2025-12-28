{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  boot.initrd.systemd.services.impermanence-root-rollover = {
    after = [
      # We need to wait for LUKS and LVM
      "systemd-cryptsetup@crypted.service" # LUKS mapping name is "crypted" thus @crypted
      "dev-root_vg-root.device"
    ];
    requires = [ "systemd-cryptsetup@crypted.service" ];
    wants = [ "dev-root_vg-root.device" ];

    before = [ "sysroot.mount" ];
    wantedBy = [ "initrd.target" ];

    unitConfig = {
      DefaultDependencies = "no";
    };

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      mkdir -p /btrfs_tmp
      mount -o subvol=/ /dev/root_vg/root /btrfs_tmp

      if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
          delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
      }

      if [[ -d /btrfs_tmp/old_roots ]]; then
        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
        done
      fi

      btrfs subvolume create /btrfs_tmp/root

      umount /btrfs_tmp
    '';
  };

  # Fix agenix ssh key being not mounted when agenix was running
  fileSystems."/etc/nixos" = {
    depends = [ "/persist" ];
    neededForBoot = true;
  };

  # Issue: https://github.com/nix-community/impermanence/issues/229
  # Can't use bind with machine-id...
  systemd.tmpfiles.rules = [
    "L /etc/machine-id - - - - /persist/etc/machine-id"
  ];

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/log"
      "/var/lib/tailscale"
      "/var/lib/bluetooth"
      "/var/lib/power-profiles-daemon"
      "/var/lib/systemd/backlight/"
      "/etc/NetworkManager/system-connections"
    ];
  };

  programs.fuse.userAllowOther = true;
  home-manager.users.ferran = {
    imports = [
      inputs.impermanence.nixosModules.home-manager.impermanence
    ];
    home.persistence."/persist/home" = {
      directories = [
        "projects"
        "data"
        "nixos-cfg"
        ".gnupg"
        ".ssh"
        ".local/share/keyrings"
        ".bitmonero"
        ".local/share/docker"
        ".cache/uv"
        ".local/share/uv"
        ".config/cat_installer" # eduroam
        ".config/VSCodium"
        ".config/vesktop"
        ".config/Signal"
        ".vscode-oss"
        ".mozilla"
        ".thunderbird"
        ".local/share/direnv"
        "Zotero"
        ".zotero"
        ".zsh"
        ".local/share/zoxide"
        ".password-store"
        ".local/state/wireplumber"
      ];

      allowOther = true;
    };
  };
}
