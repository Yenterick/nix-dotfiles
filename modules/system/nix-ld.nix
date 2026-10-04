{ pkgs, ... }:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
    curl
    icu
    libuv
    glib
    gtk3
    nss
    nspr
    atk
    cups
    dbus
    expat
    pango
    cairo
    fontconfig
    freetype
    alsa-lib
    libpulseaudio
    libGL
    vulkan-loader
    libxkbcommon
    libx11
    libxext
    libxrandr
    libxcomposite
    libxdamage
    libxfixes
    libxtst
    libxcb
    SDL2
  ];
}
