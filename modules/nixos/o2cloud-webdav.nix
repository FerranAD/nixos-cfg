{ config, pkgs, ... }:
let
  image = "o2cloud-webdav:arm64-c6aac8b";
  source = pkgs.fetchFromGitHub {
    owner = "FerranAD";
    repo = "o2cloud_gateway_webdav";
    rev = "c6aac8b11b50c3ac5f800b0bd324accb40eb5827";
    hash = "sha256-KW9f3QyL9m7Gm4VWFKPmKeUd2lh4eY2qrEqLdhI7TpY=";
  };
in
{
  users.groups.o2cloud-webdav.gid = 10001;
  users.users.o2cloud-webdav = {
    isSystemUser = true;
    uid = 10001;
    group = "o2cloud-webdav";
  };

  virtualisation.oci-containers.containers.o2cloud-webdav = {
    inherit image;
    pull = "never";
    autoStart = true;
    ports = [
      "127.0.0.1:8088:8080"
      # noVNC has no authentication; access it through an SSH tunnel.
      "127.0.0.1:6080:6080"
    ];
    environment = {
      PUID = "10001";
      PGID = "10001";
      CLOUD_PROVIDER = "o2";
      APP_BASE_URL = "https://o2cloud.oracle.aranferran.com";
      APP_ENCRYPTION_KEY_FILE = "/run/secrets/app_encryption_key";
      O2_LOGIN_NOVNC_URL = "http://localhost:6080/vnc.html?autoconnect=true&resize=scale&reconnect=true";
    };
    volumes = [
      "/data/o2cloud-webdav/config:/config"
      "/data/o2cloud-webdav/cache:/cache"
      "/data/o2cloud-webdav/data:/data"
      "${config.age.secrets.o2cloud-webdav-password.path}:/run/secrets/webdav_password:ro"
      "${config.age.secrets.o2cloud-admin-password.path}:/run/secrets/admin_password:ro"
      "${config.age.secrets.o2cloud-encryption-key.path}:/run/secrets/app_encryption_key:ro"
    ];
  };

  # shortcut: build the PR locally until upstream publishes an ARM64 release.
  systemd.services.docker-o2cloud-webdav.preStart = ''
    docker build --platform=linux/arm64 --tag ${image} ${source}
  '';

  systemd.tmpfiles.rules = [
    "d /data/o2cloud-webdav 0750 root root - -"
    "d /data/o2cloud-webdav/config 0700 o2cloud-webdav o2cloud-webdav - -"
    "d /data/o2cloud-webdav/cache 0700 o2cloud-webdav o2cloud-webdav - -"
    "d /data/o2cloud-webdav/data 0700 o2cloud-webdav o2cloud-webdav - -"
  ];
}
