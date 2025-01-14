{ inputs, ... }:
let
  flavor = "mocha";
  user = "ferran";
in
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    {
      catppuccin.flavor = flavor;
      catppuccin.enable = true;
      catppuccin.plymouth.enable = true;
      catppuccin.sddm.enable = false;
    }
    {
      home-manager.users.${user} = {
        imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
        catppuccin.flavor = flavor;
        catppuccin.enable = true;
        catppuccin.cursors.enable = true;
        catppuccin.cursors.accent = "dark";
        catppuccin.fuzzel.enable = true;
        catppuccin.hyprlock.enable = true;
        catppuccin.kvantum.enable = true;
        # Disable since it's horrible on zsh
        catppuccin.zsh-syntax-highlighting.enable = false;
      };
    }
  ];
}
