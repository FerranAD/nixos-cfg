{
  inputs,
  ...
}:
{
  imports = [
    inputs.forticlient-nixos.nixosModules.forticlient
  ];

  services.forticlient.enable = true;
  # Auto-unlock the keyring on login — use your display manager:
  services.forticlient.gnomeKeyring.pamServices = [
    "login"
    "sddm"
  ];
}
