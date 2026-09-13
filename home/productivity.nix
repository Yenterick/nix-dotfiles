{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_26
    claude-code
    opencode
  ];
}
