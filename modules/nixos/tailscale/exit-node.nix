{config, ...}:
{

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    authKeyFile = config.age.secrets.tailscale-authkey.path;
    extraSetFlags = [
      "--advertise-exit-node"
    ];
  };
}