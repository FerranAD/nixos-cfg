{ config, ... }:
{
  virtualisation.oci-containers.containers.onwatch = {
    image = "ghcr.io/onllm-dev/onwatch:2.14.6";
    autoStart = true;
    ports = [ "127.0.0.1:9211:9211" ];
    environment = {
      ONWATCH_PORT = "9211";
      ONWATCH_DB_PATH = "/data/onwatch.db";
    };
    environmentFiles = [ config.age.secrets."onwatch.env".path ];
    volumes = [ "/data/onwatch/data:/data" ];
  };

  systemd.tmpfiles.rules = [
    "d /data/onwatch 0750 root root - -"
    "d /data/onwatch/data 0700 65532 65532 - -"
  ];
}
