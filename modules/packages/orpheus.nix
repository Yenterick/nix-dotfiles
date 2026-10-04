{ lib, buildGoModule, fetchFromGitHub, pkg-config, libvorbis, libogg, flac, alsa-lib }:

buildGoModule {
  pname = "orpheus";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "Cabritto-Corps";
    repo = "orpheus";
    rev = "fc8ac2d1ac33b23120bf33697562a50a1b01219c";
    hash = "sha256-kmd84RxCg2RkJ+OcxXEAr89HvwHDsp7w2IsDzD0E/nE=";
  };

  vendorHash = "sha256-5trLz/bL6OsV/v3xBLQTBQ+jGy0sIcSvayVcwpkxKQo=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libvorbis libogg flac alsa-lib ];

  subPackages = [ "cmd/orpheus" ];

  meta = {
    description = "Terminal UI player for Spotify";
    homepage = "https://github.com/Cabritto-Corps/orpheus";
    license = lib.licenses.mit;
    mainProgram = "orpheus";
    platforms = lib.platforms.unix;
  };
}
