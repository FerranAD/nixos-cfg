{
  pkgs,
  lib,
  inputs,
  ... 
}: 
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  environment.systemPackages =
    let
      sddm-themes = pkgs.callPackage ./themes.nix { };
    in
    [
      # sddm-themes.astronaut
      (pkgs.where-is-my-sddm-theme.override {
        variants = [ "qt5" ];
        themeConfig.General = {
          background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          backgroundMode = "none";
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
        Exec=${lib.getExe nvidia-offload} ${pkgs.hyprland}/bin/Hyprland
        Type=Application
      '')
      .overrideAttrs (_: {passthru.providedSessions = ["hyprland-nvidia"];})) # This tells Nix it is a session providing "steam" in the derivation, which allows it to be defined as a session to `sessionPackages`
    ];
  };
}