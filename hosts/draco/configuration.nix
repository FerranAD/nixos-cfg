{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./agenix.nix
    ./hardware-configuration.nix
    ../../modules/nixos/nix-settings.nix
  ];

  boot.loader = {
    efi.efiSysMountPoint = "/boot";
    systemd-boot.enable = true;
  };

  services.nextcloud = {
    enable = false;
    package = pkgs.nextcloud29;
    hostName = "draco";
    config.adminpassFile = config.age.secrets.nextcloud-admin-pass.path;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) contacts calendar;
    };
    extraAppsEnable = true;
    appstoreEnable = true;
  };

  networking.hostName = "draco";
  networking.networkmanager.enable = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    authKeyFile = config.age.secrets.tailscale-authkey.path;
  };

  services.monero = {
    enable = true;
    rpc.address = "100.83.251.121";
    rpc.port = 30123;
    extraConfig = ''
      confirm-external-bind=1
    '';
  };

  services.pulseaudio.enable = false;

  time.timeZone = "Europe/Madrid";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  services.libinput.enable = true;

  users.users.ferran = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhmrNzsfb3fmufOfByUNngG4CeeyrsYrGX3mfx4N1FGTUOO/x3+0TqnAgHlm1J8SdfYxC8uM38VQa8TcwsYPGkjvLUuv8vnnZQj6BScpOs7TesUtL9j6qUU++1y60tRkpBF9MeGPQ4ADQRZG6XCvMh3l5MvLNLWhPMWw3+PUMoA2ogXw4kj8TrkXHBoUdrkjb8AW6AG17SIOLhqmnHtrcymkHyC4PWG4zUYZgHGWYOIz5yKGB7jYnjw/UAxPlcbSWZJlvuIaII6aUNJeEI87K+7QfmQzMfIuBzmx1AFSwt3yV5TRoWDN4u3Ns+Cxb+uei9xxEzCqHITE+VTIIgOBf6HPB28HnYgE4wetaEmgg0gfl3tUwNOBIQEDJxsmfvLs7Ws3NAqOziESMlJfv38TClTc/6WYQ0sNJXr721nsRfjwTREbRYEYlrOK2CxoS0OokcRPKuaTVOqznbp8MvBEy38/jRA+9CpChZshkJ6vVWaxO2/EK+SkPCgddtva9u9EIih/mlSGXam2vTd/hSJpJ9W35VDZvp/labRPWTmYTICiKE1Ii9LLBiZJINHHipnlaFYuEioWR5mh+qP41UNCsvaCv/XQuhXhJvm93P3tWHi3A72cOeH5gKuMnC5oQVX4Fi7+qMusT29Z4lB2LmyXGsFrbfXt3NeyfbJer+PKSPvw== cardno:24_684_025"
    ];
  };

  environment.systemPackages = with pkgs; [
    tailscale
    vim
    neovim
    wget
    git
    gnumake
  ];

  services.xserver.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.11";
}
