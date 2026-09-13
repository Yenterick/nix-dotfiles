{ pkgs, ... }:

let
  palette = import ../core/palette.nix;
in
{
  services.mako = {
    enable = true;
    settings = {
      background-color = palette.background;
      text-color = palette.foreground;
      border-color = palette.accent;
      border-radius = 8;
      border-size = 2;
      default-timeout = 5000;
    };
  };

  services.cliphist.enable = true;

  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    pavucontrol
  ];
}
