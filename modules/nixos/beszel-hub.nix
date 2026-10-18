{ config, ... }:
{
  services.beszel.hub = {
    enable = true;
    environment.APP_URL = "https://beszel.aranferran.com";
    environmentFile = config.age.secrets."beszel-hub.env".path;
  };
}
