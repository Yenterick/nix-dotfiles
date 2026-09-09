{ pkgs, ... }:

{
  # Terminal joke/toy binaries.
  home.packages = with pkgs; [
    cowsay
    lolcat
    fortune
    sl
    cmatrix
    cbonsai
    figlet
  ];

  programs.zsh.shellAliases = {
    moo = "fortune | cowsay | lolcat";
  };
}
