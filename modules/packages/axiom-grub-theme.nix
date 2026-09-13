{ lib, stdenvNoCC, fetchFromGitHub, nixos-icons, imagemagick }:

let
  src = fetchFromGitHub {
    owner = "Jacksaur";
    repo = "Gorgeous-GRUB-Archive";
    rev = "3a8e0fe2471a9d00d7480a010e57d0b4ce488113";
    hash = "sha256-YCE5AqtU4Yw8hHg9mVm91lAG9VY+BnwBvRs1zcNghwE=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "axiom-grub-theme";
  version = "unstable-2026-09-13";

  inherit src;
  dontUnpack = true;

  nativeBuildInputs = [ imagemagick ];

  installPhase = ''
    mkdir -p $out
    tar -xzf ${src}/Axiom.tar.gz -C $out
    rm -rf $out/.git
    convert ${nixos-icons}/share/icons/hicolor/512x512/apps/nix-snowflake.png \
      -fill "#5277C3" -colorize 100 \
      -morphology Dilate Disk:3 \
      -resize 48x48 $out/icons/nixos.png
  '';

  meta = {
    description = "Axiom GRUB2 theme (recreation by elisenlebkuch, original by LEGENDARYBIBO)";
    homepage = "https://github.com/Jacksaur/Gorgeous-GRUB-Archive";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
