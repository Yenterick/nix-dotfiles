{ config, pkgs, inputs, ... }:

{
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;
      # "light" is the theme's default and renders as a plain white menu;
      # "dark" uses the terminus monospace font for a terminal-like look.
      theme = pkgs.sleek-grub-theme.override { withStyle = "dark"; };
    };
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
}
