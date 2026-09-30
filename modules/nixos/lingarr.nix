{
  virtualisation.oci-containers.containers.lingarr = {
    image = "ghcr.io/lingarr-translate/lingarr:1.3.0";
    autoStart = true;
    environment = {
      ASPNETCORE_URLS = "http://127.0.0.1:9876";
      DB_CONNECTION = "sqlite";
      DB_HANGFIRE_SQLITE_PATH = "/app/config/Hangfire.db";
    };
    volumes = [
      "/data/lingarr:/app/config"
      "/data/nixarr/media:/data/nixarr/media"
    ];
    extraOptions = [ "--network=host" ];
  };

  systemd.tmpfiles.rules = [ "d /data/lingarr 0750 root root - -" ];
}
