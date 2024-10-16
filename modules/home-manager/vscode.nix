{ pkgs, ... }:
{
  programs.vscode = {
	enable = true;
	enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
	extensions = with pkgs.vscode-extensions; [
		dracula-theme.theme-dracula
		vscodevim.vim
		yzhang.markdown-all-in-one
		bbenoist.nix
		eamodio.gitlens
		catppuccin.catppuccin-vsc-icons
		github.copilot
		github.copilot-chat
		ms-toolsai.jupyter
		ms-python.python
		tomoki1207.pdf
	];
    userSettings = {
		"github.copilot.enable" = {
			"*" = true;
    		"markdown" = true;
		};
    	"keyboard.dispatch" = "keyCode";
			"vim.handleKeys" = {
					"<C-w>" = false;
					"<C-p>" = false;
			};
			"files.autoSave" = "afterDelay";
			"workbench.colorTheme" = "Dracula";
			"workbench.iconTheme" = "catppuccin-mocha";
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
