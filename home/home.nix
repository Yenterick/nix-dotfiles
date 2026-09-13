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
    ./desktop-apps.nix
    ./desktop-utils.nix
    ./spicetify.nix
    ./wallpaper.nix
    ./fastfetch.nix
  ];

  home.username = "yenterick";
  home.homeDirectory = "/home/yenterick";

  home.packages = [
    inputs.hyprmod.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.file.".config/hypr/hyprland.lua" = {
    force = true;
    text = builtins.replaceStrings
      [ "@INFINITE_DESKTOP_V2@" ]
      [ "${../modules/patches/infinite-desktop-v2}" ]
      (builtins.readFile ./hyprland.lua);
  };

  programs.home-manager.enable = true;
}