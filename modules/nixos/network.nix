{
  config,
  ...
}:
{
  networking = {
    hostName = "albus";
    networkmanager.enable = true;
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    authKeyFile = config.age.secrets.tailscale-authkey.path;
  };

  systemd.services.tailscaled.after = ["NetworkManager-wait-online.service"];
}
