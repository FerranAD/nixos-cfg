{ config, ... }:
let
  # Add or remove a block here; host defaults to <name>.oracle.aranferran.com.
  # host overrides only the name; the domain is always appended.
  # url creates a backend; service alone reuses a backend (or api@internal).
  entries = {
    traefik = {
      service = "api@internal";
      middlewares = [ "traefik-auth" ];
    };
    vikunja = {
      host = "vikunja-xikibby";
      url = "http://localhost:${toString config.services.vikunja.port}";
    };
    nextcloud = {
      host = "cloud";
      url = "http://localhost:8880";
    };
    privatebin = {
      url = "http://localhost:8881";
    };
    ntfy = {
      url = "http://${config.services.ntfy-sh.settings.listen-http}";
    };
  };
in
{
  imports = [ ./common.nix ];

  services.traefik.dynamicConfigOptions.http = import ./http.nix {
    domain = "oracle.aranferran.com";
    inherit entries;
  };
}
