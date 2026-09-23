{
  config,
  ...
}:
let
  paperlessData = "data/paperless";
  aissistData = "data/paperless-aissist";

  aissistPort = 8083;
in
{
  services.paperless = {
    enable = true;
    address = "0.0.0.0";

    dataDir = "${paperlessData}/data";
    mediaDir = "${paperlessData}/media";
    consumptionDir = "${paperlessData}/consume";
    consumptionDirIsPublic = false;
    database.createLocally = true;
    passwordFile = config.age.secrets.paperless-admin-pass.path;

    settings = {
      PAPERLESS_ADMIN_USER = "admin";
      PAPERLESS_URL = "https://paperless.aranferran.com";

      PAPERLESS_OCR_MODE = "auto";
      PAPERLESS_ARCHIVE_FILE_GENERATION = "auto";
      PAPERLESS_OCR_LANGUAGE = "spa+cat+eng";
      PAPERLESS_OCR_ROTATE_PAGES = true;
      PAPERLESS_OCR_DESKEW = true;
      PAPERLESS_OCR_CLEAN = "clean";
      PAPERLESS_OCR_OUTPUT_TYPE = "pdfa";

      PAPERLESS_CONSUMER_RECURSIVE = true;
      PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS = true;
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
    };

    exporter = {
      enable = true;
      directory = "${paperlessData}/export";
      onCalendar = "02:30:00";
    };
  };

  virtualisation.oci-containers.containers.paperless-aissist = {
    image = "docker.io/nyxtronlab/paperless-aissist:latest";
    autoStart = true;
    ports = [
      "127.0.0.1:${aissistPort}:8080"
    ];
    extraOptions = [
      "--add-host=host.containers.internal:host-gateway"
    ];
    environment = {
      PUID = toString config.ids.uids.paperless;
      PGID = toString config.ids.gids.paperless;
    };
    volumes = [ "${aissistData}:/app/data" ];
  };

  systemd.tmpfiles.rules = [
    "d ${paperlessData} 0750 paperless paperless - -"
    "d ${aissistData} 0700 paperless paperless - -"
  ];

  systemd.services.docker-paperless-aissist = {
    after = [
      "paperless-web.service"
      "ollama.service"
    ];
    wants = [
      "paperless-web.service"
      "ollama.service"
    ];
  };
}
