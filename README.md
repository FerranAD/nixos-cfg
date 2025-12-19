## Hostnames

🪄 MSI laptop -> albus

🦉 Home server (RPI4) -> hedwig

🤡 Macbook laptop -> draco

🗿 Slow server with lots of storage -> rubeus


## TODO

- [ ] Garbage collect to remove first nixos build and btrfs snapshot with agenix keys on the nix store
- [ ] Check wtf is happening when no yubikey is provided
- [ ] Refactor so modules are togglable options
- [ ] Move thunderbird config from dotfiles to home-manager
- [ ] Fix clipboard on neovim so it shares it with the system
- [ ] Fix lid closing behaviour

## Clone

```sh
git clone --recurse-submodules git@github.com:FerranAD/nixos-cfg.git
cd nixos-cfg/secrets
git switch master
git remote set-url origin git@github.com:FerranAD/nixos-secrets.git
```

## Install

```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake /home/ferran/nixos#albus
```

And then

```sh
sudo nixos-install --root /mnt --flake .?submodules=1#albus-install --impure
```

## Add yubikeys to unlock LUKS

First list current slots:

```sh
sudo systemd-cryptenroll /dev/nvme0n1p3
```

```sh
sudo systemd-cryptenroll /dev/nvme0n1p3 --fido2-device=auto --fido2-with-user-presence=yes --fido2-with-user-verification=yes
```

## Rsync backup

