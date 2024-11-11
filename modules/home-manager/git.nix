{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Ferran Aran";
    userEmail = "ferran@ferranaran.com";
    difftastic = {
      enable = true;
    };
    signing.key = null; # Let gpg-agent decide the key
    signing.signByDefault = true;
    extraConfig = {
      color = {
        ui = "auto";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
    };
  };
  programs.zsh.shellAliases = {
    gad = "git add .";
    gco = "git commit";
    gl = "git log --oneline";
    gst = "git status";
  };
}
