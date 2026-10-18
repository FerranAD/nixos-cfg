{ config, ... }:
{
  services.beszel.agent = {
    enable = true;
    smartmon = {
      enable = true;
      deviceAllow = [
        "/dev/nvme0"
        "/dev/nvme0n1"
      ];
    };
    environment = {
      HUB_URL = "http://127.0.0.1:${toString config.services.beszel.hub.port}";
      DISABLE_SSH = "true";
    };
    environmentFile = config.age.secrets."beszel-agent.env".path;
  };

  systemd.services.beszel-agent = {
    wants = [ "beszel-hub.service" ];
    after = [ "beszel-hub.service" ];
  };
}
