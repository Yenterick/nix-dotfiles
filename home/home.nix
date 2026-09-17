{ pkgs, inputs, osConfig, lib, ... }:

let
  isArsene = osConfig.networking.hostName == "arsene";

  # Only arsene's HDMI port should mirror the internal display; satanael
  # (desktop, no internal display) should extend as normal.
  laptopDisplayRules =
    if isArsene then ''
      -- Mirror the internal display instead of extending onto it whenever a
      -- monitor is connected via HDMI (this laptop's only HDMI port enumerates
      -- as HDMI-A-1). The mode is pinned to eDP-1's own mode so the two
      -- outputs share identical timings during mirroring.
      hl.monitor({
          output   = "HDMI-A-1",
          mode     = "1366x768@60",
          position = "auto",
          scale    = "auto",
          mirror   = "eDP-1",
      })

      -- Clamshell mode: closing the lid while docked to an HDMI monitor hands
      -- the desktop over to that monitor at its own native resolution
      -- (instead of mirroring a now-off internal panel); with no external
      -- monitor connected, closing the lid just suspends as usual. Opening
      -- the lid restores the internal panel and the default mirror above.
      hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/lid-handler.sh close"), { locked = true })
      hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/lid-handler.sh open"), { locked = true })''
    else "";
in
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
      [ "@INFINITE_DESKTOP_V2@" "@HDMI_MIRROR_RULE@" ]
      [ "${../modules/patches/infinite-desktop-v2}" laptopDisplayRules ]
      (builtins.readFile ./desktop/hyprland.lua);
  };

  home.file.".config/hypr/hyprland-gui.lua" = {
    force = true;
    source = ./desktop/hyprland-gui.lua;
  };

  home.file.".config/hypr/scripts/lid-handler.sh" = lib.mkIf isArsene {
    force = true;
    source = ./desktop/scripts/lid-handler.sh;
    executable = true;
  };

  programs.home-manager.enable = true;
}