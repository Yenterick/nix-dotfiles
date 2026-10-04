{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "tanim";
  version = "unstable-2026-01-02";

  src = fetchFromGitHub {
    owner = "SantiagoSchez";
    repo = "tanim";
    rev = "80b8131faa97f00217bde16f7d3430532e9d5b02";
    hash = "sha256-T/bhs+QxT7F6mtHHNg8K8UGWCYEn2tX8ENzyjiKxtiY=";
  };

  cargoHash = "sha256-vImVs1zkVKmrqKFZU0XkaOMOwdJ3gCJLL3R+10+ah28=";

  meta = {
    description = "Endless procedural screensaver animations for your terminal";
    homepage = "https://github.com/SantiagoSchez/tanim";
    license = lib.licenses.mit;
    mainProgram = "tanim";
    platforms = lib.platforms.unix;
  };
}
