{ pkgs, ... }:

{
  # Dark mode everywhere: GTK, Qt, and rofi all follow one switch.
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
    theme = "Arc-Dark";
  };
}
