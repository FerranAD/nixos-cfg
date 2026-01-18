{
  inputs,
  ...
}:
let
  identityPaths = [ "/etc/nixos/agenix-hedwig" ];
  hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOVPNPfHGAl0DMi9+/S8jYX7pceQXOuI2+evGrWKNzT1 ferran@hedwig";
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
    rekey = {
      hostPubkey = hostPubkey;
      masterIdentities = masterIdentities;
      storageMode = storageMode;
      localStorageDir = ../../secrets/rekeyed/hedwig;
    };
  };
}
