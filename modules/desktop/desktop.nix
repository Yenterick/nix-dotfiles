{ lib, ... }:

let
  palette = import ../../home/core/palette.nix;
  toLyColor = hex: "0x00" + lib.removePrefix "#" hex;
in
{
  programs.hyprland.enable = true;

  programs.dconf.enable = true;

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "gameoflife";
      bg = toLyColor palette.background;
      fg = toLyColor palette.foreground;
      border_fg = toLyColor palette.accent;
      gameoflife_fg = toLyColor palette.accent;
      bigclock = "en";
      bigclock_12hr = false;
      bigclock_seconds = true;
      hide_key_hints = false;
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  systemd.user.targets.hyprland-session = {
    description = "Hyprland session target";
    requires = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
  };
}
