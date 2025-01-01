{
  inputs,
  ...
}:
let
  identityPaths = [ "/home/ferran/.ssh/agenix" ];
  hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMikkJgqeDyddmg+/zCoSrTnddc0iXp4Z7Ae5dwUj8kh ferran@draco";
  masterIdentities = [ ../../modules/nixos/yubikey/yubikey-5c-age.pub ];
  storageMode = "local";
  localStorageDir = ../../secrets/rekeyed/draco;
in
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];
  age = {
    identityPaths = identityPaths;
    secrets.tailscale-authkey.rekeyFile = ../../secrets/tailscale-authkey.age;
    secrets.nextcloud-admin-pass.rekeyFile = ../../secrets/nextcloud-admin-pass.age;
    rekey = {
      hostPubkey = hostPubkey;
      masterIdentities = masterIdentities;
      storageMode = storageMode;
      localStorageDir = localStorageDir;
    };
  };
}
