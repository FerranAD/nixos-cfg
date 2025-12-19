{
  config,
  inputs,
  ...
}:
let
  # identityPaths = [ "/home/ferran/.ssh/agenix" ];
  identityPaths = [ "/etc/nixos/agenix-albus" ];
  hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIid1Lb2Zrsm/gacF7OOtbak7f6EBSsm7NvQ7g2nda2T ferran@albus";
  masterIdentities = [ ../../modules/nixos/yubikey/yubikey-5c-age.pub ];
  storageMode = "local";
  user = "ferran";
  # This is so home-manager agenix moduel doesn't use env var $XDG_RUNTIME_DIR for creating secret paths.
  secretsDirString =
    if (config.users.users.${user} ? uid)
    then "/run/user/${builtins.toString config.users.users.${user}.uid}/agenix"
    else null;
  secretsDir =
    if secretsDirString == null
    then (throw "User for HomeManager (secrets) must have an uid")
    else secretsDirString;
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
    secrets.user-password.rekeyFile = ../../secrets/user-password.age;
    rekey = {
      hostPubkey = hostPubkey;
      masterIdentities = masterIdentities;
      storageMode = storageMode;
      localStorageDir = ../../secrets/rekeyed/albus;
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
      inherit secretsDir;
      rekey = {
        hostPubkey = hostPubkey;
        masterIdentities = masterIdentities;
        storageMode = storageMode;
        localStorageDir = ../../secrets/rekeyed/albus-ferran;
      };
    };
  };
}
