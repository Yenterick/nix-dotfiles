{ pkgs, ... }:

{
  # General-purpose command-line utilities.
  home.packages = with pkgs; [
    fd
    ripgrep
    fzf
    jq
    unzip
    bat
    eza
    tlrc
    ncdu
    btop
    fastfetch
    yazi
    lazygit
    lazydocker
    lazysql
  ];
}
