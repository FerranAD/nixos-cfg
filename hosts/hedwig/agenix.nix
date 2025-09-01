{
  config,
  inputs,
  ...
}:
let
  identityPaths = [ "/home/ferran/.ssh/agenix-hedwig" ];
  hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOVPNPfHGAl0DMi9+/S8jYX7pceQXOuI2+evGrWKNzT1 ferran@hedwig";
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
    rekey = {
      hostPubkey = hostPubkey;
      masterIdentities = masterIdentities;
      storageMode = storageMode;
      localStorageDir = ../../secrets/rekeyed/hedwig;
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
        localStorageDir = ../../secrets/rekeyed/hedwig-ferran;
      };
    };
  };
}
