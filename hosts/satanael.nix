{ ... }:

{
  imports = [ ./satanael-hardware.nix ../modules/desktop/gaming.nix ];

  networking.hostName = "satanael";

  hardware.graphics.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  swapDevices = [
    { device = "/var/lib/swapfile"; size = 16 * 1024; }
  ];
}
