{ ... }:

let
  palette = import ./palette.nix;
in
{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      background_opacity = "0.64";
      background_blur = "0";
      window_padding_width = 12;

      foreground = palette.foreground;
      background = palette.background;
      cursor = palette.cursor;
      selection_background = palette.color11;
      selection_foreground = palette.background;

      color0 = palette.color0;
      color1 = palette.color1;
      color2 = palette.color2;
      color3 = palette.color3;
      color4 = palette.color4;
      color5 = palette.color5;
      color6 = palette.color6;
      color7 = palette.color7;
      color8 = palette.color8;
      color9 = palette.color9;
      color10 = palette.color10;
      color11 = palette.color11;
      color12 = palette.color12;
      color13 = palette.color13;
      color14 = palette.color14;
      color15 = palette.color15;
    };
  };
}
