{
  pkgs,
  ... 
}: {
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
    services.logind.lidSwitch = "ignore";
    services.logind.lidSwitchExternalPower = "ignore";
}