## Hostnames

🪄 Main laptop (MSI with NVIDIA 1660ti)-> albus

🦉 Home server (RPI4) -> hedwig

🧦 Home server (Asus NUC) -> dobby

🤡 Macbook laptop -> draco

🗿 Slow storage server -> rubeus

💰 Oracle cloud server -> rowling


## Clone

```sh
git clone --recurse-submodules git@github.com:FerranAD/nixos-cfg.git
cd nixos-cfg/secrets
git switch master
git remote set-url origin git@github.com:FerranAD/nixos-secrets.git
```

## Install albus

```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake /home/ferran/nixos#albus
```

And then

```sh
sudo nixos-install --root /mnt --flake .?submodules=1#albus-install --impure
```
### Then add yubikeys to unlock LUKS

First list current slots:

```sh
sudo systemd-cryptenroll /dev/nvme0n1p3
```

```sh
sudo systemd-cryptenroll /dev/nvme0n1p3 --fido2-device=auto --fido2-with-user-presence=yes --fido2-with-user-verification=yes
```

## Install dobby

Here we need sudo to be able to read agenix keys from `/etc/nixos`, but if we run the command with sudo, root is not able to use the auth key on the yubikey to login to the machine (only `ferran` user can through `gpg` config in home-manager). So we need to allow ferran to read the agenix keys temporarily.

```sh
sudo chown -R ferran:users /etc/nixos/agenix-*
nixos-anywhere --flake .?submodules=1#dobby-install --build-on remote --target-host root@$(ip) --option pure-eval false --generate-hardware-config nixos-generate-config ./hosts/dobby/hardware-configuration.nix
sudo chown -R root:root /etc/nixos/agenix-*
```

### Then add TPM2.0 key to unlock LUKS

```sh
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 --wipe-slot=tpm2 /dev/nvme0n1p3
```

## Clean nix store after install

The first nix generation left host agenix keys on the store, we want to remove that generation. To do so:

List the available generations:

```bash
sudo nix-env \
  --profile /nix/var/nix/profiles/system \
  --list-generations
```

Delete a specific generation, for example generation 1:

```bash
sudo nix-env \
  --profile /nix/var/nix/profiles/system \
  --delete-generations 1
```

Optionally remove unreferenced store paths and reclaim disk space:

```bash
sudo nix-collect-garbage
```

## Borg backups

Client jobs are named after the host, for example `albus` and `dobby`. The NixOS
module also installs matching Borg wrappers, so client-side Borg commands can use
`sudo borg-job-albus ...` or `sudo borg-job-dobby ...` without manually passing
the repo, passphrase command, or SSH key.

### Client commands

Trigger a backup now:

```sh
sudo systemctl start borgbackup-job-albus.service
```

Watch the current or latest run:

```sh
journalctl -u borgbackup-job-albus.service -f -o cat
systemctl status borgbackup-job-albus.service
```

Check when the timer will run next:

```sh
systemctl list-timers 'borgbackup-job-*'
```

List archives from a client:

```sh
sudo borg-job-albus list
```

Show the contents of an archive:

```sh
sudo borg-job-albus list ::albus-albus-YYYY-MM-DDTHH:MM:SS
```

Check the remote repository from a client:

```sh
sudo borg-job-albus check --repository-only
```

Mount an archive for browsing:

```sh
mkdir -p /tmp/borg-restore
sudo borg-job-albus mount ::albus-albus-YYYY-MM-DDTHH:MM:SS /tmp/borg-restore
sudo borg-job-albus umount /tmp/borg-restore
```

Extract a path from an archive into the current directory:

```sh
sudo borg-job-albus extract ::albus-albus-YYYY-MM-DDTHH:MM:SS home/ferran/path/to/file
```