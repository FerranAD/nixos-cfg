{ ... }:
{
  programs.difftastic.enable = true;
  programs.difftastic.git.enable = true;
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "Ferran Aran Domingo";
      user.email = "ferran@aranferran.com";
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
    signing.key = null; # Let gpg-agent decide the key
    signing.signByDefault = true;
    signing.format = "openpgp";
  };
  programs.zsh.shellAliases = {
    gad = "git add .";
    gco = "git commit";
    gl = "git log --oneline";
    gst = "git status";
  };
}
