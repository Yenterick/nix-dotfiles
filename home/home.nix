{ pkgs, inputs, ... }:

{
  imports = [
    ./core/shell.nix
    ./desktop/kitty.nix
    ./desktop/waybar.nix
    ./editor/neovim.nix
    ./apps/cli-tools.nix
    ./apps/productivity.nix
    ./apps/dev-tools.nix
    ./apps/fun.nix
    ./desktop/theme.nix
    ./apps/desktop-apps.nix
    ./desktop/desktop-utils.nix
    ./apps/spicetify.nix
    ./desktop/wallpaper.nix
    ./apps/fastfetch.nix
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
      (builtins.readFile ./desktop/hyprland.lua);
  };

  home.file.".config/hypr/hyprland-gui.lua" = {
    force = true;
    source = ./desktop/hyprland-gui.lua;
  };

  programs.home-manager.enable = true;
}