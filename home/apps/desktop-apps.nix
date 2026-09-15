{ pkgs, ... }:
{
  home.packages = [
    pkgs.discord
    pkgs.kdePackages.dolphin
    (pkgs.callPackage ../../modules/packages/emeraldian.nix { })
  ];
}
