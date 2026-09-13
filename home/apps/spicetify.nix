{ pkgs, ... }:

{
  home.packages = [
    (pkgs.spotify.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/spotify --add-flags "--disable-gpu-compositing"
      '';
    }))
  ];
}
