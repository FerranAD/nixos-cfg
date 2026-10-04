{
  inputs,
  ...
}:
{
  imports = [
    inputs.tokendrain.nixosModules.tokendrain
  ];
  services.tokendrain = {
    enable = true;
    web = {
      listenAddress = "127.0.0.1";
      port = 8742;
      publicUrl = "https://tokendrain.aranferran.com";
    };
    concurrency = 2;
    auth = {
      mode = "none";
      # adminTokenFile = "/run/secrets/tokendrain-admin";
    };
    microvm = {
      hypervisor = "firecracker";
      defaults = {
        vcpus = 4;
        memoryMiB = 4096;
        diskGiB = 40;
      };
      networking.allowLan = false;
    };
  };
}
