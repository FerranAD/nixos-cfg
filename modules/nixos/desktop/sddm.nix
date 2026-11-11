{ inputs, pkgs, ... }:
{
  imports = [ inputs.silentSDDM.nixosModules.default ];

  programs.silentSDDM = {
    enable = true;
    theme = "default";
    backgrounds.wallpaper = ../../../images/wallpaper.jpg;
    settings = {
      LoginScreen.background = "wallpaper.jpg";
      LockScreen.background = "wallpaper.jpg";
    };
  };

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };

    sessionPackages = [
      (
        (pkgs.writeTextDir "share/wayland-sessions/hyprland-nvidia.desktop" ''
          [Desktop Entry]
          Name=Hyprland (NVIDIA)
          Comment=Hyprland completely running on NVIDIA
          Exec=nvidia-offload ${pkgs.hyprland}/bin/Hyprland
          Type=Application
        '').overrideAttrs
        (_: {
          passthru.providedSessions = [ "hyprland-nvidia" ];
        })
      )
    ];
  };
}
