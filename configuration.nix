{ ... }:

{
  imports = [
    ./modules/boot.nix
    ./modules/desktop.nix
    ./modules/locale.nix
    ./modules/networking.nix
    ./modules/nix-settings.nix
    ./modules/packages.nix
    ./modules/users.nix
    ./modules/virtualisation.nix
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
