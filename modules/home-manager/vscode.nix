{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixfmt-rfc-style
    nixd
  ];
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      enkia.tokyo-night
      catppuccin.catppuccin-vsc-icons
      vscodevim.vim
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
      eamodio.gitlens
      github.copilot
      github.copilot-chat
      ms-toolsai.jupyter
      ms-python.python
      ms-python.black-formatter
      tomoki1207.pdf
    ];
    userSettings = {
      "nix.serverPath" = "nixd";
      "nix.enableLanguageServer" = true;
      "nixpkgs" = {
        "expr" = "import <nixpkgs> { }";
      };
      "formatting" = {
        "command" = [ "nixfmt" ];
      };
      "options" = {
        "nixos" = {
          "expr" = ''(builtins.getFlake "../../").nixosConfigurations.albus.options'';
        };
      };
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
      "workbench.colorTheme" = "Tokyo Night";
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
      {
        "key" = "ctrl+enter";
        "command" = "-github.copilot.generate";
        "when" = "editorTextFocus && github.copilot.activated && !commentEditorFocused && !inInteractiveInput && !interactiveEditorFocused";
      }
      {
        "key" = "ctrl+enter";
        "command" = "notebook.cell.execute";
      }
      {
        "key" = "meta+enter";
        "command" = "-notebook.cell.execute";
      }
    ];
  };
}
