{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.autofirma-nix.homeManagerModules.default
  ];

  programs.configuradorfnmt.enable = true;
  programs.configuradorfnmt.firefoxIntegration.profiles = {
    ferran = {
      enable = true;
    };
  };

  programs.autofirma.enable = true;
  programs.autofirma.firefoxIntegration.profiles = {
    ferran = {
      enable = true;

    };
    policies.SecurityDevices = {
      "OpenSC PKCS#11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
      "DNIeRemote" = "${config.programs.dnieremote.finalPackage}/lib/libdnieremotepkcs11.so";
    };
  };
}
