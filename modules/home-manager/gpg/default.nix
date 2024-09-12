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
      sshKeys = [ "99C6A5713950906F2D6E82ECE088F51931A156CC" ];
      extraConfig = ''
        allow-preset-passphrase
      '';
      pinentryPackage = pkgs.pinentry-gnome3;
    };
    # This is the key-grip, not the same as the key fingerprint.
    home.file.".pam-gnupg".text = ''
        99C6A5713950906F2D6E82ECE088F51931A156CC
    '';
    programs.ssh.enable = true;
    # programs.ssh = {
    #   enable = true;
    #   hashKnownHosts = true;
    #   matchBlocks = cfg.sshHosts;
    # };
    home.packages = [
      pkgs.pinentry-gnome3
    ];
}
