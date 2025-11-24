{ pkgs, ... }:
{
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.arimo
  ];
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "IosevkaTermSlab Nerd Font"
          "Noto Serif"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Arimo Nerd Font"
          "Noto Sans"
          "Noto Color Emoji"
        ];
        monospace = [
          "FiraMono Nerd Font"
          "JetBrainsMono Nerd Font"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
