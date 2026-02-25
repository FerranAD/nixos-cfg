{
  inputs,
  pkgs,
  nurPkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.default

    ./agenix.nix
    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/impermanence.nix
    ../../modules/nixos/nix-settings.nix
    ../../modules/nixos/network.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/power.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/boot.nix
    ../../modules/nixos/yubikey

    #Desktop
    ../../modules/nixos/xdg-portal.nix
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/file-manager.nix
    ../../modules/nixos/audio.nix
    ../../modules/catppuccin.nix
    ../../modules/nixos/sddm.nix
  ];

  virtualisation.virtualbox.host.enable = true;

  hardware = {
    bluetooth.enable = true;
    uinput.enable = true;
  };

  services.printing.enable = true;
  services.gvfs.enable = true;

  home-manager = {
    extraSpecialArgs = {
      inherit inputs nurPkgs;
    };
    useGlobalPkgs = true;
    users = {
      "ferran" = import ./home.nix;
    };
  };

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
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhmrNzsfb3fmufOfByUNngG4CeeyrsYrGX3mfx4N1FGTUOO/x3+0TqnAgHlm1J8SdfYxC8uM38VQa8TcwsYPGkjvLUuv8vnnZQj6BScpOs7TesUtL9j6qUU++1y60tRkpBF9MeGPQ4ADQRZG6XCvMh3l5MvLNLWhPMWw3+PUMoA2ogXw4kj8TrkXHBoUdrkjb8AW6AG17SIOLhqmnHtrcymkHyC4PWG4zUYZgHGWYOIz5yKGB7jYnjw/UAxPlcbSWZJlvuIaII6aUNJeEI87K+7QfmQzMfIuBzmx1AFSwt3yV5TRoWDN4u3Ns+Cxb+uei9xxEzCqHITE+VTIIgOBf6HPB28HnYgE4wetaEmgg0gfl3tUwNOBIQEDJxsmfvLs7Ws3NAqOziESMlJfv38TClTc/6WYQ0sNJXr721nsRfjwTREbRYEYlrOK2CxoS0OokcRPKuaTVOqznbp8MvBEy38/jRA+9CpChZshkJ6vVWaxO2/EK+SkPCgddtva9u9EIih/mlSGXam2vTd/hSJpJ9W35VDZvp/labRPWTmYTICiKE1Ii9LLBiZJINHHipnlaFYuEioWR5mh+qP41UNCsvaCv/XQuhXhJvm93P3tWHi3A72cOeH5gKuMnC5oQVX4Fi7+qMusT29Z4lB2LmyXGsFrbfXt3NeyfbJer+PKSPvw== cardno:24_684_025"
      ];
    };
  };

  users.users.root = {
    hashedPasswordFile = config.age.secrets.user-password.path;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhmrNzsfb3fmufOfByUNngG4CeeyrsYrGX3mfx4N1FGTUOO/x3+0TqnAgHlm1J8SdfYxC8uM38VQa8TcwsYPGkjvLUuv8vnnZQj6BScpOs7TesUtL9j6qUU++1y60tRkpBF9MeGPQ4ADQRZG6XCvMh3l5MvLNLWhPMWw3+PUMoA2ogXw4kj8TrkXHBoUdrkjb8AW6AG17SIOLhqmnHtrcymkHyC4PWG4zUYZgHGWYOIz5yKGB7jYnjw/UAxPlcbSWZJlvuIaII6aUNJeEI87K+7QfmQzMfIuBzmx1AFSwt3yV5TRoWDN4u3Ns+Cxb+uei9xxEzCqHITE+VTIIgOBf6HPB28HnYgE4wetaEmgg0gfl3tUwNOBIQEDJxsmfvLs7Ws3NAqOziESMlJfv38TClTc/6WYQ0sNJXr721nsRfjwTREbRYEYlrOK2CxoS0OokcRPKuaTVOqznbp8MvBEy38/jRA+9CpChZshkJ6vVWaxO2/EK+SkPCgddtva9u9EIih/mlSGXam2vTd/hSJpJ9W35VDZvp/labRPWTmYTICiKE1Ii9LLBiZJINHHipnlaFYuEioWR5mh+qP41UNCsvaCv/XQuhXhJvm93P3tWHi3A72cOeH5gKuMnC5oQVX4Fi7+qMusT29Z4lB2LmyXGsFrbfXt3NeyfbJer+PKSPvw== cardno:24_684_025"
    ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = true;
    settings.PermitRootLogin = "yes";
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    gnumake
    agenix-rekey
    nwg-displays
    nixos-anywhere
    texliveFull
    signal-desktop-bin
    onlyoffice-desktopeditors
    mpv
    htop
  ];

  programs.zsh.enable = true;
  programs.zsh.setOptions = [
    "EXTENDED_HISTORY"
    "APPEND_HISTORY"
    # "EMACS"
  ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.sudo.extraConfig = ''
    	Defaults lecture=never
  '';

  system.stateVersion = "24.05";
}
