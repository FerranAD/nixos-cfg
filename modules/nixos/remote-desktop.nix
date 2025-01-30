{
  pkgs,
  ...
}:
{
  users.users.ferran.packages = with pkgs; [
    wayvnc
  ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        5900
      ];
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = true;
    settings.PermitRootLogin = "no";
  };
}
