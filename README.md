## Hostnames

🪄 Main laptop (MSI with NVIDIA 1660ti)-> albus (Usa hyprmon per les pantalles)

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

## O2 Cloud WebDAV on Rowling

Until upstream releases ARM64 images, the NixOS service builds the pinned PR
source natively on Rowling before starting. 

After deployment, open `https://o2cloud.oracle.aranferran.com/admin` and start the
assisted O2 login. The passwordless noVNC screen is bound to localhost; forward it
from your computer with:

```sh
ssh -N -L 6080:127.0.0.1:6080 ferran@rowling
```

WebDAV clients use `https://o2cloud.oracle.aranferran.com/dav` with user `o2dav`.
After the cloud login, test a directory listing (curl prompts for the WebDAV
password):

```sh
curl --fail --user o2dav -X PROPFIND -H 'Depth: 1' https://o2cloud.oracle.aranferran.com/dav/
```

## Beszel monitoring

Dobby runs both the hub and the native agent using the locked unstable Beszel
package. Open `https://beszel.aranferran.com` through Dobby's Traefik proxy. The
hub listens on localhost; port 8090 is not opened in the firewall. The agent
connects to the hub over localhost with its SSH listener disabled. There is no
public Beszel proxy route on Rowling.

The agent monitors systemd services, Docker containers, and SMART health for
Dobby's NVMe disk (`/dev/nvme0` and `/dev/nvme0n1`). SMART enables raw-disk
capabilities and relaxes the agent's sandbox. Docker monitoring grants access to
the Docker socket. Service journal viewing requires Beszel 0.21; the current
unstable package is 0.20.0, so journal access is not granted.

### Secrets and first setup

Both secrets are encrypted to your agenix-rekey master identity and rekeyed for
Dobby. `secrets/beszel-hub.env.age` contains:

```dotenv
USER_EMAIL="<your email>"
USER_PASSWORD="<strong initial password>"
```

Use systemd EnvironmentFile quoting: inside double quotes, write a literal
backslash as `\\` and a literal double quote as `\"`. The credentials are used
only when the initial database migration runs; changing the secret does not
change an existing account's password.

`secrets/beszel-agent.env.age` contains:

```dotenv
KEY="ssh-ed25519 <hub public key>"
TOKEN="<registration or universal token>"
```

With a universal token, copy the public key from Add System without submitting
that form. The agent registers automatically; no host/IP or agent port needs to
be configured in the dashboard. Run `agenix rekey -a` and add the encrypted and
rekeyed files in the secrets submodule before deploying Dobby.

In notification settings, add
`ntfy://:<access-token>@ntfy.oracle.aranferran.com/monitoring`, using a token
allowed to publish to that topic, and send a test notification. Configure offline,
disk-space, SMART, and sustained memory alerts in the dashboard.

### Moving the existing hub from Rowling

1. Download a backup from the existing hub's Settings → Backups before deploying
   the removal on Rowling. Keep Rowling's `/var/lib/beszel-hub` state for rollback.
2. Rekey the hub secret for Dobby and deploy Dobby. Route
   `beszel.aranferran.com` through the same DNS/tunnel setup as Dobby's other
   services, then restore the backup through Settings → Backups. This preserves
   existing accounts and monitoring history instead of starting a new database.
3. Restart `beszel-hub` and `beszel-agent` on Dobby and check that the existing
   registration works. If using a fresh database instead, regenerate the agent's
   key/token from that hub and rekey and deploy its secret.
4. Deploy Rowling to remove its hub, secret deployment, and public proxy route.
   The old `beszel.oracle.aranferran.com` DNS record can then be removed.

Check `journalctl -u beszel-hub -u beszel-agent -b` on Dobby. Verify SMART data,
systemd services, and container metrics in the dashboard. Configure Beszel's
built-in backups to a backed-up location; its default state directory is
`/var/lib/beszel-hub`, outside the existing Borg job's `/data` backup paths.
Monitoring on Dobby cannot send an offline alert while Dobby itself is down.

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

Recover from a stale repository lock only after confirming no backup or status
check is running:

```sh
sudo systemctl status borgbackup-job-dobby.service
sudo borg-job-dobby break-lock
```

If the Rubeus status check is the active process, stop it first on Rubeus:

```sh
sudo systemctl stop borg-status-ui-check.service
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
