{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.sddm-astronaut.override {
      embeddedTheme = "jake_the_dog";
    })
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    extraPackages = [ pkgs.kdePackages.qtmultimedia ];
    theme = "sddm-astronaut-theme";
  };

  services.displayManager = {
    sessionPackages = [
      (
        (pkgs.writeTextDir "share/wayland-sessions/hyprland-nvidia.desktop" ''
          [Desktop Entry]
          Name=Hyprland (NVIDIA)
          Comment=Hyprland completely running on NVIDIA
          Exec=nvidia-offload Hyprland
          Type=Application
        '').overrideAttrs
        (_: {
          passthru.providedSessions = [ "hyprland-nvidia" ];
        })
      )
    ];
  };
}
