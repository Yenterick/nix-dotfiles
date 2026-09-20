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
    extraConfig = {
      show-icons = true;
    };
    theme = {
      "*" = {
        font = "JetBrainsMono Nerd Font 12";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral palette.foreground;
        margin = 0;
        padding = 0;
        spacing = 0;
      };

      "window" = {
        location = mkLiteral "center";
        width = 480;
        background-color = mkLiteral palette.background;
      };

      "inputbar" = {
        spacing = mkLiteral "8px";
        padding = mkLiteral "8px";
        background-color = mkLiteral palette.background;
      };

      "prompt, entry, element-icon, element-text" = {
        vertical-align = mkLiteral "0.5";
      };

      "prompt" = {
        text-color = mkLiteral palette.accent;
      };

      "entry" = {
        blink = false;
      };

      "textbox" = {
        padding = mkLiteral "8px";
        background-color = mkLiteral palette.background;
      };

      "listview" = {
        padding = mkLiteral "4px 0";
        lines = 8;
        columns = 1;
        fixed-height = true;
      };

      "element" = {
        padding = mkLiteral "8px";
        spacing = mkLiteral "8px";
      };

      "element normal normal" = {
        text-color = mkLiteral palette.foreground;
      };

      "element normal urgent" = {
        text-color = mkLiteral palette.color3;
      };

      "element normal active" = {
        text-color = mkLiteral palette.accent;
      };

      "element alternate active" = {
        text-color = mkLiteral palette.accent;
      };

      "element selected" = {
        text-color = mkLiteral palette.background;
      };

      "element selected normal, element selected active" = {
        background-color = mkLiteral palette.accent;
      };

      "element selected urgent" = {
        background-color = mkLiteral palette.color3;
      };

      "element-icon" = {
        size = mkLiteral "0.8em";
      };

      "element-text" = {
        text-color = mkLiteral "inherit";
      };
    };
  };
}
