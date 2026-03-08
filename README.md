## Hostnames

🪄 MSI laptop -> albus

🦉 Home server (RPI4) -> hedwig

🤡 Macbook laptop -> draco

🗿 Slow server with lots of storage -> rubeus


## TODO

- [ ] Garbage collect to remove first nixos build and btrfs snapshot with agenix keys on the nix store
- [ ] Refactor so modules are togglable options
- [ ] Move thunderbird config from dotfiles to home-manager
- [ ] Fix python

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

## Rsync backup

```sh
sudo rsync -aAXHv --progress --ignore-missing-args \
  --include='/var/lib/bluetooth/***' \
  --include='/etc/NetworkManager/system-connections/***' \
  --include='/etc/nixos/***' \
  --include='/home/ferran/nixos-cfg/***' \
  --include='/home/ferran/.ssh/***' \
  --include='/home/ferran/.local/share/keyrings/***' \
  --include='/home/ferran/.config/cat_installer/***' \
  --include='/home/ferran/.config/VSCodium/***' \
  --include='/home/ferran/.config/vesktop/***' \
  --include='/home/ferran/.vscode-oss/***' \
  --include='/home/ferran/.mozilla/***' \
  --include='/home/ferran/.thunderbird/***' \
  --include='/home/ferran/Zotero/***' \
  --include='/home/ferran/.zotero/***' \
  --include='/home/ferran/.zsh/***' \
  --include='/home/ferran/.local/share/zoxide/***' \
  --include='/home/ferran/.password-store/***' \
  --include='/home/ferran/.local/state/wireplumber/default-routes/***' \
  --exclude='*' \
  /mnt/ /
```
