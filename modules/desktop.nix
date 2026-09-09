{ ... }:

{
  programs.hyprland.enable = true;
  services.displayManager.ly.enable = true;

  # Needed for GTK/portal dark-mode (color-scheme) settings to apply at runtime.
  programs.dconf.enable = true;

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
