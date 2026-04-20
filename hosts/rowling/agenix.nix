{
  inputs,
  ...
}:
let
  identityPaths = [ "/etc/nixos/agenix-rowling" ];
  hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJygwGCzAruIxYztDoBTIpkhfEsQxrJADHATKKARa2c9 ferran@rowling";
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
    secrets.user-password.rekeyFile = ../../secrets/user-password.age;
    secrets."porkbun-traefik.env".rekeyFile = ../../secrets/porkbun-traefik.env.age;
    rekey = {
      hostPubkey = hostPubkey;
      masterIdentities = masterIdentities;
      storageMode = storageMode;
      localStorageDir = ../../secrets/rekeyed/rowling;
    };
  };
}
