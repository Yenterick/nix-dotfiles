{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (python3.withPackages (ps: [ ps.evdev ]))
    gcc
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
  ];
}
