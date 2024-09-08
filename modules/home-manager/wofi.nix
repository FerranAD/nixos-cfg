{ ... }:
let
  wofiStyle = ''
  '';
in
{
  programs.wofi = {
    enable = true;
    # style = wofiStyle;
  };
}