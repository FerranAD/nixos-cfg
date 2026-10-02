{ ... }:
{
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.oracle.aranferran.com";
      behind-proxy = true;
      auth-default-access = "deny-all";
      enable-login = true;
    };
  };
}
