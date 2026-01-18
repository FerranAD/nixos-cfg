{
  inputs,
  ...
}:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  boot.initrd.systemd.services.impermanence-root-rollover = {
    wantedBy = [ "initrd-root-device.target" ];
    wants = [ "dev-root_vg-root.device" ];
    after = [ "dev-root_vg-root.device" ];
    before = [ "sysroot.mount" ];
    requires = [ "systemd-cryptsetup@crypted.service" ];

    serviceConfig.Type = "oneshot";

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

  # Fix agenix ssh key being not mounted at startup
  age.identityPaths = [
    "/persist/system/etc/nixos/agenix-albus"
  ];

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
    home.persistence."/persist/home" = {
      directories = [
        "projects"
        "data"
        "nixos-cfg"
        ".gnupg"
        ".ssh"
        ".local/share/keyrings"
        ".bitmonero"
        "Monero/wallets"
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
    };
  };
}
