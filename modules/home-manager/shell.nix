{ lib, pkgs, ... }:
let
  zsh-direnv-hook = "eval \"$(direnv hook zsh)\"";
  zsh-init-direnv-flake = ''
    flakify() {
      if [ ! -e flake.nix ]; then
        nix flake new -t github:nix-community/nix-direnv .
        rm .envrc
        echo "use flake" > .envrc
        direnv allow
      fi
      ''${EDITOR:-vim} flake.nix
    }
  '';
in
{
  home.packages = with pkgs; [
    zsh-fzf-history-search
  ];

  # Make direnv cache live on cache directory instead of at each project
  home.file.".config/direnv/direnvrc".text = ''
      : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(sha1sum - <<< "$PWD" | head -c40)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
          )}"
      }
  '';

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = false;
      nix-direnv.enable = true;
      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };

    bat.enable = true;

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        cp = "cp -iv";
        mv = "mv -iv";
        rm = "rm -vI";
        ls = "${pkgs.lsd}/bin/lsd -h";
        grep = "grep --color=auto";
        diff = "diff --color=auto";
        cat = "${pkgs.bat}/bin/bat";
        clipclear = "${pkgs.clipse}/bin/clipse -clear";
      };
      initExtra = ''
        nixr() {
          nix run "nixpkgs#$1" ''${@:2}
        }

        nixs() {
          nix shell "nixpkgs#$1" ''${@:2}
        }

        ${zsh-direnv-hook}
        ${zsh-init-direnv-flake}
      '';
    };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$localip"
          "$shlvl"
          "$singularity"
          "$kubernetes"
          "$directory"
          "$vcsh"
          "$fossil_branch"
          "$fossil_metrics"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_metrics"
          "$git_status"
          "$hg_branch"
          "$pijul_channel"
          "$docker_context"
          "$package"
          "$c"
          "$cmake"
          "$cobol"
          "$daml"
          "$dart"
          "$deno"
          "$dotnet"
          "$elixir"
          "$elm"
          "$erlang"
          "$fennel"
          "$gleam"
          "$golang"
          "$guix_shell"
          "$haskell"
          "$haxe"
          "$helm"
          "$java"
          "$julia"
          "$kotlin"
          "$gradle"
          "$lua"
          "$nim"
          "$nodejs"
          "$ocaml"
          "$opa"
          "$perl"
          "$php"
          "$pulumi"
          "$purescript"
          "$python"
          "$quarto"
          "$raku"
          "$rlang"
          "$red"
          "$ruby"
          "$rust"
          "$scala"
          "$solidity"
          "$swift"
          "$terraform"
          "$typst"
          "$vlang"
          "$vagrant"
          "$zig"
          "$buf"
          "$nix_shell"
          "$conda"
          "$meson"
          "$spack"
          "$memory_usage"
          "$aws"
          "$gcloud"
          "$openstack"
          "$azure"
          "$nats"
          "$direnv"
          "$env_var"
          "$crystal"
          "$custom"
          "$sudo"
          "$cmd_duration"
          "$line_break"
          "$jobs"
          "$battery"
          "$time"
          "$status"
          "$os"
          "$container"
          "$shell"
        ];
      };
    };
  };
}
