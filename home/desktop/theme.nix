{ pkgs, config, ... }:

let
  palette = import ../core/palette.nix;
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
    colorScheme = "dark"; # also flips the GNOME/portal color-scheme dconf key
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3"; # Qt apps (e.g. dolphin) follow the GTK dark theme
    style.name = "adwaita-dark";
  };

  programs.rofi = {
    enable = true;
    theme = {
      "*" = {
        background-color = mkLiteral palette.background;
        foreground-color = mkLiteral palette.foreground;
        border-color = mkLiteral palette.accent;
      };
      "window" = {
        border = mkLiteral "2px";
        border-color = mkLiteral palette.accent;
        border-radius = mkLiteral "8px";
        background-color = mkLiteral palette.background;
      };
      "element selected" = {
        background-color = mkLiteral palette.accent;
        text-color = mkLiteral palette.background;
      };
    };
  };
}
