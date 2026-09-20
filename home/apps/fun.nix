{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cowsay
    lolcat
    fortune
    sl
    cmatrix
    cbonsai
    figlet
    toilet
    boxes

    pipes
    asciiquarium
    nyancat
    hollywood
    tty-clock
    cava
    genact
    unimatrix
    bb
  ];

  programs.zsh.shellAliases = {
    moo = "fortune | cowsay | lolcat";
  };
}
