{ ... }:

let
  palette = import ../core/palette.nix;
in
{
  programs.waybar = {
    enable = true;

    style = ''
      * { font-family: "JetBrainsMono Nerd Font"; font-size: 13px; border: none; }
      window#waybar { background: rgba(19,0,0,0.85); color: ${palette.foreground}; }
      #workspaces button { padding: 0 8px; color: ${palette.color8}; }
      #workspaces button.active, #workspaces button.focused { color: ${palette.foreground}; background: rgba(135,85,116,0.25); }
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