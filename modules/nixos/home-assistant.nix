{
  config,
  lib,
  ...
}:
let
  port = 8123;
  secretsFile = config.age.secrets."home-assistant-secrets.yaml".path;
in
{
  systemd.tmpfiles.rules = [
    "d /data/home-assistant 0750 hass hass - -"
  ];

  services.home-assistant = {
    enable = true;
    configDir = "/data/home-assistant";

    extraComponents = [
      "assist_pipeline"
      "conversation"
      "default_config"
      "esphome"
      "met"
      "mobile_app"
      "ollama"
      "stt"
      "tts"
      "wyoming"
      "zha"
    ];

    config = {
      default_config = { };
      assist_pipeline = { };
      conversation = { };

      homeassistant = {
        name = "Dobby";
        latitude = "!secret home_latitude";
        longitude = "!secret home_longitude";
        elevation = "!secret home_elevation";
        unit_system = "metric";
        temperature_unit = "C";
        time_zone = config.time.timeZone;
        external_url = "https://homeassistant.aranferran.com";
        internal_url = "http://127.0.0.1:${toString port}";
      };

      http = {
        server_host = "127.0.0.1";
        server_port = port;
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
        ip_ban_enabled = true;
        login_attempts_threshold = 5;
      };
    };
  };

  systemd.services.home-assistant.preStart = lib.mkAfter ''
    ln -fs ${secretsFile} ${config.services.home-assistant.configDir}/secrets.yaml
  '';

  services.wyoming.faster-whisper.servers.dobby = {
    enable = true;
    uri = "tcp://0.0.0.0:10300";
    sttLibrary = "faster-whisper";
    model = "base-int8";
    language = "en";
  };

  services.wyoming.piper.servers.dobby = {
    enable = true;
    uri = "tcp://0.0.0.0:10200";
    voice = "en-us-ryan-medium";
  };
}
