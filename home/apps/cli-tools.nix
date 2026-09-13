{ pkgs, ... }:

{
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
    yazi
    lazygit
    lazydocker
    lazysql
    brightnessctl
    playerctl
  ];
}
