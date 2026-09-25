{
  config,
  ...
}:
let
  aissistData = "/data/paperless-aissist";
in
{
  services.paperless = {
    enable = true;
    address = "127.0.0.1";

    dataDir = "/data/paperless/data";
    mediaDir = "/data/paperless/media";
    consumptionDir = "/data/paperless/consume";
    consumptionDirIsPublic = false;
    database.createLocally = true;
    passwordFile = config.age.secrets.paperless-admin-pass.path;

    settings = {
      PAPERLESS_ADMIN_USER = "admin";
      PAPERLESS_URL = "https://paperless.aranferran.com";

      PAPERLESS_CONSUMER_DELETE_DUPLICATES=true;
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
      directory = "/data/paperless/export";
      onCalendar = "02:30:00";
    };
  };

  virtualisation.oci-containers.containers.paperless-aissist = {
    image = "docker.io/nyxtronlab/paperless-aissist:latest";
    autoStart = true;
    extraOptions = [ "--network=host" ];
    environment = {
      PUID = toString config.ids.uids.paperless;
      PGID = toString config.ids.gids.paperless;
    };
    volumes = [ "${aissistData}:/app/data" ];
  };

  systemd.tmpfiles.rules = [
    "d /data/paperless 0750 paperless paperless - -"
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
