{
  inputs,
  ...
}:
let
  identityPaths = [ "/home/ferran/.ssh/agenix" ];
  hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIid1Lb2Zrsm/gacF7OOtbak7f6EBSsm7NvQ7g2nda2T ferran@albus";
  masterIdentities = [ ../../modules/nixos/yubikey/yubikey-5c-age.pub ];
  storageMode = "local";
  localStorageDir = ../../secrets/rekeyed/albus;
  user = "ferran";
in
{
  # Nixos Configuration
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
      localStorageDir = localStorageDir;
    };
  };

  # Home Manager Configuration
  home-manager.users.${user} = {
    imports = [
      inputs.agenix.homeManagerModules.default
      inputs.agenix-rekey.homeManagerModules.default
    ];
    age = {
      identityPaths = identityPaths;
      secrets.weather-api.rekeyFile = ../../secrets/weather-api.age;
      rekey = {
        hostPubkey = hostPubkey;
        masterIdentities = masterIdentities;
        storageMode = storageMode;
        localStorageDir = localStorageDir;
      };
    };
  };
}
