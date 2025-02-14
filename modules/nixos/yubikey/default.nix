{ pkgs, ... }:
{
  services.udev.packages = with pkgs; [
    yubikey-personalization
    libu2f-host
  ];
  services.dbus.packages = [ pkgs.gcr ];
  services.pcscd.enable = true;

  programs.yubikey-touch-detector.enable = true;
  programs.yubikey-touch-detector.libnotify = true;
  programs.ssh.startAgent = false;

  security.pam.u2f.settings = {
    origin = "pam://yubi";
    enable = true;
    interactive = true;
    cue = true;
  };

  # Import the custom package here
  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubioath-flutter
    age-plugin-yubikey
    (pkgs.callPackage ./icon/icon.nix { })
  ];
  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  hardware.gpgSmartcards.enable = true;
}
