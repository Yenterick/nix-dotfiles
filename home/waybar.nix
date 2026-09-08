{ ... }:

{
  programs.waybar = {
    enable = true;

    style = ''
      * { font-family: "JetBrainsMono Nerd Font"; font-size: 13px; border: none; }
      window#waybar { background: rgba(30,30,46,0.85); color: #cdd6f4; }
      #workspaces button { padding: 0 8px; color: #7f849c; }
      #workspaces button.active, #workspaces button.focused { color: #a6adc8; background: rgba(137,180,250,0.15); }
      #clock, #cpu, #memory, #network, #pulseaudio, #tray { padding: 0 10px; }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "pulseaudio" "cpu" "memory" "tray" ];

        "hyprland/workspaces" = {
          sort-by-number = true;
        };

        clock = {
          format = "{:%a %d %b %H:%M}";
        };

        cpu = {
          format = "CPU: {usage}%";
        };

        memory = {
          format = "RAM: {}%";
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "{ifname}";
          format-disconnected = "no net";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "muted";
        };

        tray = {
          spacing = 8;
        };
      };
    };
  };
}