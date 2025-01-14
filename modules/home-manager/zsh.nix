{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    zsh-fzf-history-search
  ];
  programs = {
    bat.enable = true;
    lsd.enable = true;
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
