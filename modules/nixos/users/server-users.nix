{ pkgs, config, ... }:
{
  users.users.ferran = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      neovim
      htop
      git
    ];
    hashedPasswordFile = config.age.secrets.user-password.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDO11F5Mw0JYYi/IgmgfV7bRZS7yDi5y/FSDpM3Ep6Qt openpgp:0xBC69F42C"
    ];
  };
}