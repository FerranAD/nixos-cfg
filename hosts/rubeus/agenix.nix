{
  inputs,
  ...
}:
let
  identityPaths = [ "/etc/nixos/agenix-rubeus" ];
  hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjS/pdHjR1Ld1Oy8he9J5LFaD1aAvDEoNpeK303H7qx ferran@rubeus";
  masterIdentities = [ ../../modules/nixos/yubikey/yubikey-5c-age.pub ];
  storageMode = "local";
in
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];
  age = {
    identityPaths = identityPaths;
    secrets.tailscale-authkey.rekeyFile = ../../secrets/tailscale-authkey.age;
    secrets.user-password.rekeyFile = ../../secrets/user-password.age;
    rekey = {
      hostPubkey = hostPubkey;
      masterIdentities = masterIdentities;
      storageMode = storageMode;
      localStorageDir = ../../secrets/rekeyed/rubeus;
    };
  };
}
