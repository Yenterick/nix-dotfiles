{ config, pkgs, inputs, ... }:

{
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;
      theme = pkgs.sleek-grub-theme.override { withStyle = "dark"; };
    };
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
}
