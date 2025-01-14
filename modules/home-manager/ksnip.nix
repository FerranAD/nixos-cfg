{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.ksnip
  ];

  home.file.".config/ksnip/ksnip.conf".text = ''
[Application]
ApplicationStyle=Fusion
CloseToTray=false
MinimizeToTray=false
SaveDirectory=/home/ferran
TrayIconNotificationsEnabled=false
UseTrayIcon=false
PromptSaveBeforeExit=false
RememberLastSaveDirectory=true
    '';
}
 