{
  services.libretranslate = {
    enable = true;
    dataDir = "/data/libretranslate";
    updateModels = true;
    extraArgs."load-only" = "en,es,ca";
  };
}
