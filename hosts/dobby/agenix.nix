{
  inputs,
  ...
}:
let
  identityPaths = [ "/etc/nixos/agenix-dobby" ];
  hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEMA4/G2fOID9n0rXRKF7nQxOYOlbU95cTUD17iHTF+y ferran@dobby";
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
    secrets."porkbun-traefik.env".rekeyFile = ../../secrets/porkbun-traefik.env.age;
    rekey = {
      hostPubkey = hostPubkey;
      masterIdentities = masterIdentities;
      storageMode = storageMode;
      localStorageDir = ../../secrets/rekeyed/dobby;
    };
  };
}
