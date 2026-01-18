{ pkgs, inputs, ... }:

{
  # home.packages = [ inputs.pkgs.pyprland ];

  # programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]

    plugins = [
      "scratchpads",
      "magnify",
    ]

    [scratchpads.term]
    animation = ""
    command = "alacritty --class alacritty-dropterm"
    class = "alacritty-dropterm"
    position = "30% 6%"
    size = "40% 30%"
    max_size = "1920px 100%"
  '';
}
