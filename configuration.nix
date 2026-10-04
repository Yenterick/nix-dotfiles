{ pkgs, inputs, ... }:

let
  webkitCompatPkgs = import inputs.nixpkgs-webkit-compat {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    ./modules/system/boot.nix
    ./modules/system/hardware.nix
    ./modules/system/keyboard.nix
    ./modules/system/locale.nix
    ./modules/system/networking.nix
    ./modules/system/nix-settings.nix
    ./modules/system/nix-ld.nix
    ./modules/system/packages.nix
    ./modules/system/users.nix
    ./modules/desktop/desktop.nix
    ./modules/desktop/virtualisation.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.appimage = {
      enable = true;
      binfmt = true;
      package = webkitCompatPkgs.appimage-run.override {
        extraPkgs = pkgs: [ pkgs.webkitgtk_4_0 pkgs.libsoup_2_4 ];
      };
  };

  system.stateVersion = "26.05";
}
