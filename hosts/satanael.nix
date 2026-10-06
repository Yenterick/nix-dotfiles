{ pkgs, inputs, ... }:

let
  webkitCompatPkgs = import inputs.nixpkgs-webkit-compat {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  imports = [ ./satanael-hardware.nix ../modules/desktop/gaming.nix ];

  networking.hostName = "satanael";

  programs.appimage.package = webkitCompatPkgs.appimage-run.override {
    extraPkgs = pkgs: [ pkgs.webkitgtk_4_0 pkgs.libsoup_2_4 ];
  };

  hardware.graphics.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  swapDevices = [
    { device = "/var/lib/swapfile"; size = 16 * 1024; }
  ];
}
