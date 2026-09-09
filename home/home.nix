{ pkgs, inputs, ... }:

{
  imports = [
    ./shell.nix
    ./kitty.nix
    ./waybar.nix
    ./neovim.nix
    ./cli-tools.nix
    ./productivity.nix
    ./dev-tools.nix
    ./fun.nix
    ./theme.nix
  ];

  home.username = "yenterick";
  home.homeDirectory = "/home/yenterick";

  home.packages = [
    inputs.hyprmod.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.file.".config/hypr/hyprland.lua".source = ./hyprland.lua;

  programs.home-manager.enable = true;
}