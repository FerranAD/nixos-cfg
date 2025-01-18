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
        # Disable since it's horrible on zsh
        catppuccin.zsh-syntax-highlighting.enable = false;
      };
    }
  ];
}
