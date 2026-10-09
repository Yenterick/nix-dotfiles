{ pkgs, inputs, ... }:

{
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
    inputs.epubworm.packages.${stdenv.hostPlatform.system}.default
  ];
}
