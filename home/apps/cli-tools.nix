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
    tree
    tlrc
    ncdu
    btop
    yazi
    lazygit
    lazydocker
    lazysql
    bluetui
    csvlens
    brightnessctl
    playerctl
  ];
}
