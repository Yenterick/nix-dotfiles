{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emeraldian";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "iamrohithrnair";
    repo = "emeraldian";
    tag = "v${version}";
    hash = "sha256-GMiXFGRYGIjLD+X0XDBazenPNAmhi2eaqVb4RyG5ebo=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";

  meta = {
    description = "Terminal UI for Obsidian vaults: live-preview notes, backlinks, images, and a force-directed graph";
    homepage = "https://emeraldian-tui.github.io";
    license = lib.licenses.gpl3Plus;
    mainProgram = "emeraldian";
    platforms = lib.platforms.unix;
  };
}
