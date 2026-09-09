{ ... }:

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
    };
  };
}
