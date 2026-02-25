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
      nixfmt
      nixd
      vscode-alias
      mypy
    ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = true;
  };
  programs.vscode.profiles.default = {
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
      # Style
      enkia.tokyo-night
      catppuccin.catppuccin-vsc-icons

      # Language
      ms-toolsai.jupyter
      ms-python.python
      # ms-python.vscode-pylance
      matangover.mypy
      charliermarsh.ruff
      jnoortheen.nix-ide
      yzhang.markdown-all-in-one

      # Tools
      mechatroner.rainbow-csv
      vscodevim.vim
      github.copilot
      github.copilot-chat
      aaron-bond.better-comments
      mkhl.direnv
      james-yu.latex-workshop
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
      "editor.wordWrap" = "on";
      "vim.handleKeys" = {
        "<C-w>" = false;
        "<C-p>" = false;
      };
      "vim.useSystemClipboard" = true;
      "files.autoSave" = "afterDelay";
      "workbench.colorTheme" = "Tokyo Night";
      "workbench.iconTheme" = "catppuccin-mocha";
      "window.titleBarStyle" = "custom";
      "window.dialogStyle" = "custom";
      "chat.disableAIFeatures" = false;
      "mypy.checkNotebooks" = true;
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
