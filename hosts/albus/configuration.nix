{ inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/xdg-portal.nix
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/yubikey
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/thunar.nix
    ../../modules/nixos/power.nix
    ../../modules/nixos/audio.nix
    ../../modules/cattpuccin.nix
    ../../modules/nixos/sddm.nix
    ../../modules/nixos/boot.nix
    inputs.home-manager.nixosModules.default
  ];
  age.identityPaths = [ "/home/ferran/.ssh/agenix" ];
  age.rekey = {
    hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIid1Lb2Zrsm/gacF7OOtbak7f6EBSsm7NvQ7g2nda2T ferran@albus";
    masterIdentities = [ ../../modules/nixos/yubikey/yubikey-5c-age.pub ];
    storageMode = "local";
    localStorageDir = ./. + "/secrets/rekeyed/albus";
  };
  age.secrets.weather-api.rekeyFile = ./. + "/secrets/weather-api.age";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  hardware = {
    bluetooth.enable = true;
    uinput.enable = true;
  };

  networking = {
    hostName = "albus";
    networkmanager.enable = true;
  };

  services.printing.enable = true;
  services.gvfs.enable = true;

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
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
      description = "Ferran";
      extraGroups = [
        "networkmanager"
        "wheel"
        "udev"
      ];
      packages = [
        pkgs.kitty
        pkgs.dolphin
        pkgs.material-design-icons
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    gnumake
    agenix-rekey
  ];

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.zsh.setOptions = [ "EXTENDED_HISTORY" "APPEND_HISTORY" "EMACS" ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "24.05";
}
