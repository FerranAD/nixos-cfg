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
    secrets.nextcloud-admin-pass.rekeyFile = ../../secrets/nextcloud-admin-pass.age;
    secrets."ntfy.env".rekeyFile = ../../secrets/ntfy.env.age;
    secrets."porkbun-traefik.env".rekeyFile = ../../secrets/porkbun-traefik.env.age;
    secrets.o2cloud-webdav-password = {
      rekeyFile = ../../secrets/o2cloud-webdav-password.age;
      owner = "o2cloud-webdav";
      group = "o2cloud-webdav";
    };
    secrets.o2cloud-admin-password = {
      rekeyFile = ../../secrets/o2cloud-admin-password.age;
      owner = "o2cloud-webdav";
      group = "o2cloud-webdav";
    };
    secrets.o2cloud-encryption-key = {
      rekeyFile = ../../secrets/o2cloud-encryption-key.age;
      owner = "o2cloud-webdav";
      group = "o2cloud-webdav";
    };
    secrets."traefik-dashboard-users" = {
      rekeyFile = ../../secrets/traefik-dashboard-users.age;
      owner = "traefik";
      group = "traefik";
    };
    rekey = {
      hostPubkey = hostPubkey;
      masterIdentities = masterIdentities;
      storageMode = storageMode;
      localStorageDir = ../../secrets/rekeyed/rowling;
    };
  };
}
