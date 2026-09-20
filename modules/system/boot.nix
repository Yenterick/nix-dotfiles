{ config, pkgs, inputs, ... }:

{
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;
      useOSProber = true;
      theme = pkgs.callPackage ../packages/crt-amber-grub-theme.nix { };
    };
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
}
