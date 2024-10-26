{ inputs, ... }:
let
  flavor = "mocha";
  user = "ferran";
in {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    {
      catppuccin.flavor = flavor;
      catppuccin.enable = true;
      boot.plymouth.catppuccin.enable = true;
      services.displayManager.sddm.catppuccin.enable = false;
    }
    {
      home-manager.users.${user} = {
        imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
        catppuccin.flavor = flavor;
        catppuccin.enable = true;
        catppuccin.pointerCursor.enable = true;
        catppuccin.pointerCursor.accent = "dark";
        programs.fuzzel.catppuccin.enable = true;
        programs.hyprlock.catppuccin.enable = true;
        # Disable since it's horrible on zsh
        programs.zsh.syntaxHighlighting.catppuccin.enable = false;
      };
    }
  ];
}
