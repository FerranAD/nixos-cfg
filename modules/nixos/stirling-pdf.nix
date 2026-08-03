{
  ...
}:
{
  services.stirling-pdf = {
    enable = true;

    environment = {
      SERVER_ADDRESS = "127.0.0.1";
      SERVER_PORT = 8882;
      SECURITY_ENABLELOGIN = true;
      SECURITY_INITIALLOGIN_USERNAME = "admin";
      SECURITY_INITIALLOGIN_PASSWORD = "changeme123";
      STORAGE_ENABLED=true;
      STORAGE_PROVIDER="local";
      STORAGE_LOCAL_BASEPATH = "/data/stirling-pdf";
    };
  };
}
