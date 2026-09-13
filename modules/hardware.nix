{ pkgs, ... }:

{
  services.udev.packages = [ pkgs.brightnessctl ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;
}
