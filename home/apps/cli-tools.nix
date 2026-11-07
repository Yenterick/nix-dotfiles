{ pkgs, inputs, ... }:

let
  # rmcl doesn't bundle Java; give it a modern default without putting java
  # on the global PATH. Older JDKs are linked below for per-instance java_path.
  rmcl = pkgs.symlinkJoin {
    name = "rmcl";
    paths = [
      # CurseForge imports abort on mods whose authors block third-party
      # downloads; skip them and list them in <instance>/minecraft/blocked-mods.tsv
      (inputs.rmcl.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ../../modules/packages/rmcl-skip-blocked-curseforge.patch ];
      }))
    ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/rmcl --suffix PATH : ${pkgs.jdk21}/bin
    '';
  };
in
{
  # Stable paths for rmcl's per-instance java_path (MC <=1.16 needs 8, 1.17-1.20.4 needs 17)
  xdg.dataFile."rmcl/java/8".source = pkgs.jdk8;
  xdg.dataFile."rmcl/java/17".source = pkgs.jdk17;
  xdg.dataFile."rmcl/java/21".source = pkgs.jdk21;

  home.packages = with pkgs; [
    fd
    ripgrep
    fzf
    jq
    vim
    unzip
    bat
    eza
    tree
    tlrc
    ncdu
    btop
    yazi
    lazygit
    lazydocker
    lazysql
    bluetui
    csvlens
    brightnessctl
    playerctl
    pulsemixer
    (callPackage ../../modules/packages/tfm-tui.nix { })
    (callPackage ../../modules/packages/orpheus.nix { })
    (callPackage ../../modules/packages/tanim.nix { })
    (callPackage ../../modules/packages/dripfetch.nix { })
    (callPackage ../../modules/packages/shoin.nix { })
    (callPackage ../../modules/packages/sqlmux.nix { })
    rmcl
    # SVG snapshot tests fail in the sandbox (font rendering differences)
    (inputs.bookokrat.packages.${stdenv.hostPlatform.system}.default.overrideAttrs { doCheck = false; })
  ];
}
