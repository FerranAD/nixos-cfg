{
  inputs,
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
  };
}
