{ pkgs, config, ... }:
{
  users = {
    defaultUserShell = pkgs.zsh;
    users.ferran = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "vboxusers"
        "wheel"
        "udev"
        "adbusers"
        "kvm"
      ];
      uid = 1000;
      packages = [
        pkgs.kitty
        pkgs.material-design-icons
      ];
      hashedPasswordFile = config.age.secrets.user-password.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDO11F5Mw0JYYi/IgmgfV7bRZS7yDi5y/FSDpM3Ep6Qt openpgp:0xBC69F42C"
      ];
    };
  };
}