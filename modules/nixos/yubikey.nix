{ pkgs, ... }: {
  services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
  services.dbus.packages = [ pkgs.gcr ];
  services.pcscd.enable = true;

  programs.yubikey-touch-detector.enable = false;
  programs.ssh.startAgent = false;

  security.pam.u2f.settings = {
    origin = "pam://yubi";
    enable = true;
    interactive = true;
    cue = true;
  };

  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubioath-flutter
  ];
  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  hardware.gpgSmartcards.enable = true;
}
