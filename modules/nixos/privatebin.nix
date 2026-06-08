{
  config,
  ...
}:
{
  services.privatebin.enable = true;
  services.privatebin.enableNginx = true;
  services.privatebin.virtualHost = "privatebin.oracle.aranferran.com";
  services.nginx.virtualHosts."${config.services.privatebin.virtualHost}".listen = [
    {
      addr = "127.0.0.1";
      port = 8881;
    }
  ];
}