{
  pkgs,
  ...
}:
{
  users.users.ferran.packages = with pkgs; [
    wayvnc
  ];

  # networking = {
  #   firewall = {
  #     enable = true;
  #     allowedTCPPorts = [
  #       22
  #       5900
  #     ];
  #   };
  # };

}
