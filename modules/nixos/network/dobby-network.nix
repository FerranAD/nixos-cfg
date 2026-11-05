{...}:
{
  networking = {
    firewall.enable = true;
    hostName = "dobby";
    networkmanager.enable = true;
    resolvconf.useLocalResolver = true;
  };

  systemd.services.wg = {
    after = [ "adguardhome.service" ];
    wants = [ "adguardhome.service" ];
  };
}
