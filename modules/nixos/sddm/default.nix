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
      pkgs.libsForQt5.qt5.qtgraphicaleffects
      sddm-themes.astronaut
    ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "astronaut";
  };
}