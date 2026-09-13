{ ... }:

{
  imports = [
    ./modules/system/boot.nix
    ./modules/system/hardware.nix
    ./modules/system/locale.nix
    ./modules/system/networking.nix
    ./modules/system/nix-settings.nix
    ./modules/system/packages.nix
    ./modules/system/users.nix
    ./modules/desktop/desktop.nix
    ./modules/desktop/gaming.nix
    ./modules/desktop/virtualisation.nix
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
