{ pkgs, ... }:

{
  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.luajit}/lib/pkgconfig";
  };

  home.packages = with pkgs; [
    (python3.withPackages (ps: [ ps.evdev ]))
    gcc
    gnumake
    pkg-config
    luajit
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
  ];
}
