{ pkgs, ... }:
{
  programs.vscode = {
	  enable = true;
	  extensions = with pkgs.vscode-extensions; [
	    dracula-theme.theme-dracula
	    vscodevim.vim
	    yzhang.markdown-all-in-one
	    jnoortheen.nix-ide
      eamodio.gitlens
	  ];
    userSettings = {
    	"keyboard.dispatch" = "keyCode";
			"vim.handleKeys" = {
					"<C-w>" = false;
					"<C-p>" = false;
			};
			"files.autoSave" = "afterDelay";
			"workbench.colorTheme" = "Dracula Theme";
		};
  };	
}