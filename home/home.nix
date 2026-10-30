{ pkgs, inputs, osConfig, lib, ... }:

let
  isArsene = osConfig.networking.hostName == "arsene";

  # arsene uses Hyprland's default pointer sensitivity; satanael keeps the
  # tuned value we already had.
  mouseSensitivity = if isArsene then "0" else "-0.7";

  # arsene's internal display mirrors the HDMI monitor; on satanael the HDMI
  # TV mirrors the main DP monitor.
  laptopDisplayRules =
    if isArsene then ''
      -- When a monitor is plugged into HDMI (this laptop's only HDMI port
      -- enumerates as HDMI-A-1) it becomes the real desktop at its native
      -- resolution (1920x1080 on a typical monitor/projector) and the
      -- 1366x768 laptop panel mirrors it, shrunk to fit. Closing the lid while
      -- docked turns the panel off; with no external monitor, closing the lid
      -- just suspends. lid-handler.sh applies the layout on start, hotplug and
      -- lid events.
      -- The laptop panel always runs at a ~1080p-sized desktop (2048x1152
      -- logical; 0.6667 is the only scale below 1 Hyprland accepts for this
      -- 1366x768 panel).
      hl.monitor({
          output   = "eDP-1",
          mode     = "preferred",
          position = "auto",
          scale    = 0.666667,
      })

      hl.monitor({
          output   = "HDMI-A-1",
          mode     = "preferred",
          position = "auto",
          scale    = 1,
      })

      local displayHandler = os.getenv("HOME") .. "/.config/hypr/scripts/lid-handler.sh"
      hl.on("hyprland.start",  function () hl.exec_cmd(displayHandler .. " sync") end)
      hl.on("monitor.added",   function () hl.exec_cmd(displayHandler .. " sync") end)
      hl.on("monitor.removed", function () hl.exec_cmd(displayHandler .. " sync") end)

      hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd(displayHandler .. " close"), { locked = true })
      hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd(displayHandler .. " open"), { locked = true })''
    else ''
      -- satanael: the HP monitor on DP-3 is the main desktop and the LG TV on
      -- HDMI-A-1 always mirrors it.
      hl.monitor({
          output   = "DP-3",
          mode     = "preferred",
          position = "0x0",
          scale    = 1,
      })

      hl.monitor({
          output   = "HDMI-A-1",
          mode     = "1920x1080@60",
          position = "auto",
          scale    = 1,
          mirror   = "DP-3",
      })

      -- If the HP monitor is turned off (it disconnects), mirror-handler.sh
      -- un-mirrors the TV so it keeps working as a normal desktop, and
      -- mirrors it again once the HP comes back.
      local mirrorHandler = os.getenv("HOME") .. "/.config/hypr/scripts/mirror-handler.sh"
      hl.on("hyprland.start",  function () hl.exec_cmd(mirrorHandler) end)
      hl.on("monitor.added",   function () hl.exec_cmd(mirrorHandler) end)
      hl.on("monitor.removed", function () hl.exec_cmd(mirrorHandler) end)
      hl.on("config.reloaded", function () hl.exec_cmd(mirrorHandler) end)'';
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
    ./desktop/zen-browser.nix
    ./desktop/tfm.nix
  ];

  home.username = "yenterick";
  home.homeDirectory = "/home/yenterick";

  home.packages = [
    inputs.hyprmod.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.file.".config/hypr/hyprland.lua" = {
    force = true;
    text = builtins.replaceStrings
      [ "@INFINITE_DESKTOP_V2@" "@HDMI_MIRROR_RULE@" "@MOUSE_SENSITIVITY@" ]
      [ "${../modules/patches/infinite-desktop-v2}" laptopDisplayRules mouseSensitivity ]
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

  home.file.".config/hypr/scripts/mirror-handler.sh" = lib.mkIf (!isArsene) {
    force = true;
    source = ./desktop/scripts/mirror-handler.sh;
    executable = true;
  };

  programs.home-manager.enable = true;
}