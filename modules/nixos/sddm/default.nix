{
  pkgs,
  lib,
  inputs,
  ... 
}: 
{
  environment.systemPackages =
    let
      sddm-themes = pkgs.callPackage ./themes.nix { };
    in
    [
      (pkgs.where-is-my-sddm-theme.override {
        variants = [ "qt5" ];
        themeConfig.General = {
          background = "${../../../images/wallpaper.jpg}";
          blurRadius= 25;
          passwordTextColor= "#ffffff";
          basicTextColor="#313244";
          showSessionsByDefault= true;
        };
      })
    ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "where_is_my_sddm_theme_qt5";
  };
  services.displayManager = {
    sessionPackages = [
      ((pkgs.writeTextDir "share/wayland-sessions/hyprland-nvidia.desktop" ''
        [Desktop Entry]
        Name=Hyprland (NVIDIA)
        Comment=Hyprland completely running on NVIDIA
        Exec=nvidia-offload ${pkgs.hyprland}/bin/Hyprland
        Type=Application
      '')
      .overrideAttrs (_: {passthru.providedSessions = ["hyprland-nvidia"];}))
    ];
  };
}