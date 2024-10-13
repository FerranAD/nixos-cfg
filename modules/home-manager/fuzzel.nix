{ pkgs, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        exit-on-keyboard-focus-loss = "no";
      };
      key-bindings = {
        # Remaped since it defaults to Control+k
        delete-line-forward= "Control+d";

        next = "Down Control+j";
        prev = "Up Control+k";
      };
    };
  };
}