{ ... }:

{
  services.hyprpaper = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = {
      splash = false;
      preload = [ "${./wallpapers/wallpaper.jpg}" ];
      wallpaper = [
        {
          monitor = "";
          path = "${./wallpapers/wallpaper.jpg}";
        }
      ];
    };
  };
}
