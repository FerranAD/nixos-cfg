{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.pangolin = {
    enable = true;
    baseDomain = "oracle.aranferran.com";
    dashboardDomain = "pangolin.oracle.aranferran.com";
    letsEncryptEmail = "ferran@aranferran.com";
    openFirewall = true;
    environmentFile = config.age.secrets."pangolin.env".path;
    settings = {
      flags = {
        # Public TLS stays in Traefik; certificate import is for private-resource TLS.
        enable_acme_cert_sync = false;
        require_email_verification = false;
        disable_signup_without_invite = true;
        disable_user_create_org = true;
        allow_raw_resources = false;
      };
    };
  };

  # The package copies read-only .next directories, then removes them on restart.
  # Remove once fixed upstream: https://github.com/NixOS/nixpkgs/issues/538346
  systemd.services.pangolin.preStart = lib.mkBefore ''
    if [ -d .next ] && [ ! -L .next ]; then
      ${pkgs.findutils}/bin/find .next -type d -exec ${pkgs.coreutils}/bin/chmod u+w {} +
    fi
  '';

  services.traefik = {
    # The upstream WebSocket router needs a matcher to avoid catching dashboard pages.
    dynamicConfigOptions.http.routers.ws-router.rule =
      lib.mkForce "Host(`pangolin.oracle.aranferran.com`) && Header(`Upgrade`, `websocket`)";
  };
}
