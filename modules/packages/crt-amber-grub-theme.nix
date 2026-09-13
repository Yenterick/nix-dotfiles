{ lib, stdenvNoCC, fetchFromGitHub, nixos-icons, imagemagick }:

let
  src = fetchFromGitHub {
    owner = "Jacksaur";
    repo = "CRT-Amber-GRUB-Theme";
    rev = "91c376037d6fe2eb62b82cb5f7b5148438c8ed77";
    hash = "sha256-ATm0b9e3Qcv42E5CQYB7Umc8NpWw90QdjJmArOKbmaY=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "crt-amber-grub-theme";
  version = "unstable-2026-09-13";

  inherit src;

  nativeBuildInputs = [ imagemagick ];

  installPhase = ''
    mkdir -p $out
    cp -r . $out/
    convert ${nixos-icons}/share/icons/hicolor/512x512/apps/nix-snowflake.png \
      -fill "#5277C3" -colorize 100 \
      -morphology Dilate Disk:3 \
      -resize 32x32 $out/icons/nixos.png
  '';

  meta = {
    description = "Retro amber CRT terminal styled GRUB theme";
    homepage = "https://github.com/Jacksaur/CRT-Amber-GRUB-Theme";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
