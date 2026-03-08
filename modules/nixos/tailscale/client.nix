{config, ...}:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    authKeyFile = config.age.secrets.tailscale-authkey.path;
    extraDaemonFlags = [ "--encrypt-state=false" ];
  };
}