{
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
  };
}
