{ pkgs, ... }:
{
  programs.vscode = {
	  enable = true;
	  extensions = with pkgs.vscode-extensions; [
	    dracula-theme.theme-dracula
	    vscodevim.vim
	    yzhang.markdown-all-in-one
		bbenoist.nix
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
		keybindings = [
			{
				key = "ctrl+c";
				command = "editor.action.clipboardCopyAction";
				when = "textInputFocus";
			}
			{
				key = "ctrl+shift+j";
				command = "-workbench.action.search.toggleQueryDetails";
				when = "inSearchEditor || searchViewletFocus";
			}
			{
				key = "ctrl+shift+j";
				command = "editor.action.joinLines";
			}
		];
  };	
}