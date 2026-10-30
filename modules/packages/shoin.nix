{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "shoin";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "nol00p";
    repo = "Shoin";
    rev = "338c2eb48ef9b9df3fe3b54103c29eb9bbc278ce";
    hash = "sha256-D2zMaWGzSLEKuLIlafciMqtgOPdxlMGBsbaxzHJRpEc=";
  };

  cargoHash = "sha256-wSCkd+4YFkFYZt+Ig4OVNfficF+6XGpXpF5RS4soOdo=";

  meta = {
    description = "No-clutter terminal Markdown editor with modal editing";
    homepage = "https://github.com/nol00p/Shoin";
    license = lib.licenses.asl20;
    mainProgram = "shoin";
    platforms = lib.platforms.unix;
  };
}
