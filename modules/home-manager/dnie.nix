{
  inputs,
  ...
}:
{
  imports = [
    inputs.autofirma-nix.homeManagerModules.default
  ];

  programs.autofirma.enable = true;
  programs.autofirma.firefoxIntegration.profiles = {
    ferran = {
      enable = true;
    };
  };
}