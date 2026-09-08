{ pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };

  home.file.".config/nvim" = {
    source = inputs.lazyvim-starter;
    force = true;
  };

  home.packages = with pkgs; [
    lazygit
    fd
    fzf
    ripgrep
    nodejs
    tree-sitter
    unzip
    gcc
    pkgs.nerd-fonts.jetbrains-mono
  ];
}