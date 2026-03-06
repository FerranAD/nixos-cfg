{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      disable-ccid = true;
    };
    settings = {
      with-fingerprint = true;
      use-agent = true;
    };
    publicKeys = [ { source = ./yubikey.pub; } ];
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableBashIntegration = true;
    enableExtraSocket = true;
    sshKeys = [ "C646325B370E1294EB3A06ECF4FCA8E88BA16531" ];
    extraConfig = ''
      allow-preset-passphrase
    '';
    pinentry.package = pkgs.pinentry-gnome3;
  };
  # This is the key-grip, not the same as the key fingerprint.
  home.file.".pam-gnupg".text = ''
    C646325B370E1294EB3A06ECF4FCA8E88BA16531
  '';
  home.packages = [ pkgs.pinentry-gnome3 ];
}
