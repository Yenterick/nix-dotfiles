{ pkgs, ... }:

{
  # Dev/AI productivity tooling.
  home.packages = with pkgs; [
    nodejs_26
    claude-code
    opencode
  ];
}
