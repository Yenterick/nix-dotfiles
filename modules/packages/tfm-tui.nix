{ lib, stdenvNoCC, fetchurl, makeWrapper, librsvg, imagemagick, ffmpeg, glib, wl-clipboard }:

stdenvNoCC.mkDerivation {
  pname = "tfm-tui";
  version = "0.1.0-beta.0";

  src = fetchurl {
    url = "https://github.com/clarkarch/tfm-tui/releases/download/v0.1.0-beta.0/tfm-x86_64-linux.gz";
    hash = "sha256-RuSDRLI6/6fm3IMysZyFeiAS3F3l6s2olct6nLVQ658=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  # Do not run autoPatchelfHook/patchelf on this binary: it's a
  # `bun build --compile` self-contained executable with an embedded
  # bundle trailer, and patchelf rewriting the ELF breaks Bun's ability
  # to find that trailer (it silently falls back to plain `bun` CLI
  # behavior instead of running the app). It already runs fine unpatched
  # via nix-ld, which this system has enabled.

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    gunzip -c $src > $out/bin/.tfm-unwrapped
    chmod +x $out/bin/.tfm-unwrapped
    makeWrapper $out/bin/.tfm-unwrapped $out/bin/tfm \
      --prefix PATH : ${lib.makeBinPath [ librsvg imagemagick ffmpeg glib wl-clipboard ]}
    ln -s $out/bin/tfm $out/bin/terminal-file-manager
    runHook postInstall
  '';

  meta = {
    description = "Modern mouse-first terminal file manager";
    homepage = "https://github.com/clarkarch/tfm-tui";
    mainProgram = "tfm";
    platforms = [ "x86_64-linux" ];
  };
}
