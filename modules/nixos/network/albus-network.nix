{...}:
{
  networking = {
    firewall.enable = true;
    hostName = "albus";
    networkmanager.enable = true;
  };

  systemd.services.tailscaled.after = ["NetworkManager-wait-online.service"];
}