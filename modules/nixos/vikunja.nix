{
  ...
}:
{
  services.vikunja = {
    enable = true;
    # database.path = "/data/vikunja/vikunja.db";
    frontendScheme = "https";
    frontendHostname = "vikunja-xikibby.oracle.aranferran.com";
    settings = {
      service.enableregistration = false;
    #   files.basepath = lib.mkForce "/data/vikunja/files";
    };
  };

}
