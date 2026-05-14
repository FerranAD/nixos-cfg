{
  config,
  ...
}:
{
  services.shiori = {
    enable = true;
    port = 8275;
    environmentFile = config.age.secrets."shiori.env".path;
  };
}