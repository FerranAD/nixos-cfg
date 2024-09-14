{
  pkgs,
  inputs,
  ... 
}: {
  environment.systemPackages =
    let
      sddm-themes = pkgs.callPackage ./themes.nix { };
    in
    [
      # sddm-themes.astronaut
      (pkgs.where-is-my-sddm-theme.override {
        variants = [ "qt5" ];
      })
    ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "where_is_my_sddm_theme_qt5";
  };
}