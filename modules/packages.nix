{ pkgs, ... }:

{
  # System-wide tools only; per-user CLI/dev tooling lives in home/*.nix.
  environment.systemPackages = with pkgs; [
    git
    vim
    firefox
  ];
}
