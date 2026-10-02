{ config, ... }:
{
  services.ntfy-sh = {
    enable = true;
    environmentFile = config.age.secrets."ntfy.env".path;
    settings = {
      base-url = "https://ntfy.oracle.aranferran.com";
      behind-proxy = true;
      auth-default-access = "deny-all";
      auth-access = [
        "*:general:rw"
      ];
      enable-login = true;
    };
  };
}
