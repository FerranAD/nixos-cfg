{ pkgs, ... }:
{
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin
    thunar-media-tags-plugin
    tumbler
  ];
}
