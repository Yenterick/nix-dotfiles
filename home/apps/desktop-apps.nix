{ pkgs, ... }:
{
  home.packages = [
    (pkgs.symlinkJoin {
      name = "discord";
      paths = [ pkgs.discord ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/discord \
          --add-flags "--ozone-platform=x11"
        ln -sf $out/bin/discord $out/bin/Discord
      '';
    })
    pkgs.kdePackages.dolphin
    (pkgs.callPackage ../../modules/packages/emeraldian.nix { })
  ];
}
