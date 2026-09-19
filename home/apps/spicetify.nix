{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  palette = import ../core/palette.nix;
  hex = builtins.replaceStrings [ "#" ] [ "" ];

  spotify = pkgs.spotify.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/spotify --add-flags "--disable-gpu-compositing"
    '';
  });

  spicetifyCliVersion = "2.45.1";

  spicetifyCliRawSrc = pkgs.fetchFromGitHub {
    owner = "spicetify";
    repo = "cli";
    tag = "v${spicetifyCliVersion}";
    hash = "sha256-Mu97p0HlvmEMkPV/VvHztJ1VqocxXoAXRtDKLGYd9mk=";
  };

  spicetifyWrapperJs = pkgs.runCommand "spicetifyWrapper.js" {
    nativeBuildInputs = [ pkgs.esbuild ];
  } ''
    esbuild ${spicetifyCliRawSrc}/src/jsHelper/spicetifyWrapper/index.js \
      --bundle --minify --target=chrome108 --format=iife \
      --outfile=$out
  '';

  spicetifyCliSrc = pkgs.runCommand "spicetify-cli-src-${spicetifyCliVersion}-patched" { } ''
    cp -r ${spicetifyCliRawSrc} $out
    chmod -R u+w $out
    cp ${spicetifyWrapperJs} $out/jsHelper/spicetifyWrapper.js
  '';

  spicetifyCli = pkgs.spicetify-cli.overrideAttrs (old: {
    version = spicetifyCliVersion;
    src = spicetifyCliSrc;
    vendorHash = "sha256-nrUaocs+so35MDxC6TkRSakYKWmhoysrvhE6fXRvYco=";
  });
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    spotifyPackage = spotify;
    spicetifyPackage = spicetifyCli;

    theme = spicePkgs.themes.text;
    sidebarConfig = false;

    customColorScheme = with palette; {
      accent = hex accent;
      accent-active = hex color9;
      accent-inactive = hex background;
      banner = hex accent;
      border-active = hex accent;
      border-inactive = hex color8;
      header = hex color0;
      highlight = hex color6;
      main = hex background;
      notification = hex color5;
      notification-error = hex color3;
      subtext = hex color7;
      text = hex foreground;
    };

    enabledCustomApps = with spicePkgs.apps; [
      marketplace
    ];
  };
}
