{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.ripgrep-all.enable = true;
  programs.ripgrep.enable = true;
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorschemes.catppuccin.enable = true;

    clipboard.register = "unnamedplus";
    clipboard.providers.wl-copy.enable = true;
    globals.mapleader = " ";

    plugins.lualine.enable = true;
    plugins.treesitter.enable = true;
    plugins.web-devicons.enable = true;
    plugins.telescope = {
        enable = true;
        extensions = {
          fzf-native = {
            enable = true;
          };
        };
        keymaps = {
          "<leader>f" = {
            action = "git_files";
            options = {
              desc = "Telescope Git Files";
            };
          };
          "<leader>ff" = "live_grep";
        };
      };
  };
}
