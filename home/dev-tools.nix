{ pkgs, ... }:

{
  # General-purpose language toolchains: Python, a C compiler, Rust/Cargo.
  home.packages = with pkgs; [
    python3
    gcc
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
  ];
}
