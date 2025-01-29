{ pkgs, ... }:
{
  home.packages =
    let
      vscode-alias = pkgs.writeShellScriptBin "code" ''
        #!/bin/sh
        exec codium "$@"
      '';
    in
    with pkgs;
    [
      nixfmt-rfc-style
      nixd
      vscode-alias
    ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      # Style
      enkia.tokyo-night
      catppuccin.catppuccin-vsc-icons

      # Language
      ms-toolsai.jupyter
      ms-python.python
      ms-python.black-formatter
      jnoortheen.nix-ide
      yzhang.markdown-all-in-one
      tomoki1207.pdf

      # Tools
      vscodevim.vim
      eamodio.gitlens
      github.copilot
      github.copilot-chat
      aaron-bond.better-comments
      mkhl.direnv
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
      "window.titleBarStyle" = "custom";
      "window.dialogStyle" = "custom";
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
        "when" =
          "editorTextFocus && github.copilot.activated && !commentEditorFocused && !inInteractiveInput && !interactiveEditorFocused";
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
