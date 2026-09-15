{ ... }:

let
  palette = import ../core/palette.nix;

  # surface_container tones: background lifted toward color0 for the pill fills
  surfaceContainer = "#23130c";
  surfaceContainerHighest = "#2d1f14";
in
{
  programs.waybar.enable = true;

  xdg.configFile = {
    "waybar/config.jsonc".source = ./waybar/config.jsonc;
    "waybar/style.css".source = ./waybar/style.css;

    "waybar/modules/groups.jsonc".source = ./waybar/modules/groups.jsonc;
    "waybar/modules/distro.jsonc".source = ./waybar/modules/distro.jsonc;
    "waybar/modules/storage.jsonc".source = ./waybar/modules/storage.jsonc;
    "waybar/modules/system.jsonc".source = ./waybar/modules/system.jsonc;
    "waybar/modules/workspace.jsonc".source = ./waybar/modules/workspace.jsonc;
    "waybar/modules/idle-inhibitor.jsonc".source = ./waybar/modules/idle-inhibitor.jsonc;
    "waybar/modules/audio.jsonc".source = ./waybar/modules/audio.jsonc;
    "waybar/modules/connections.jsonc".source = ./waybar/modules/connections.jsonc;
    "waybar/modules/battery.jsonc".source = ./waybar/modules/battery.jsonc;
    "waybar/modules/clock.jsonc".source = ./waybar/modules/clock.jsonc;

    "waybar/tokens/state.css".source = ./waybar/tokens/state.css;
    "waybar/tokens/workspace.css".source = ./waybar/tokens/workspace.css;
    "waybar/tokens/widget.css".source = ./waybar/tokens/widget.css;
    "waybar/tokens/batt-clock.css".source = ./waybar/tokens/batt-clock.css;
    "waybar/tokens/slider.css".source = ./waybar/tokens/slider.css;

    "waybar/tokens/colors.css".text = ''
      /* Generated from ../core/palette.nix — edit the palette there, not here */

      @define-color background ${palette.background};
      @define-color on_background ${palette.foreground};

      @define-color surface_container ${surfaceContainer};
      @define-color surface_container_highest ${surfaceContainerHighest};

      @define-color primary ${palette.accent};
      @define-color on_primary ${palette.foreground};

      @define-color secondary_fixed_dim ${palette.color7};
      @define-color tertiary ${palette.color8};
      @define-color tertiary_fixed ${palette.color9};
      @define-color outline_variant ${palette.color6};

      @define-color success ${palette.color12};
      @define-color warning ${palette.color10};
      @define-color critical ${palette.color3};
      @define-color error_container ${palette.color1};

      @define-color terminal_accent ${palette.color4};
      @define-color obsidian_accent ${palette.color9};
      @define-color spotify_accent ${palette.color12};
      @define-color browser_accent ${palette.color3};
    '';
  };
}
