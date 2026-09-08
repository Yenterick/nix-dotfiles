{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };

  home.packages = with pkgs; [
    lazygit
    fd
    fzf
    pkgs.nerd-fonts.jetbrains-mono
  ];
}