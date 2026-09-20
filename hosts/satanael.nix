{ ... }:

{
  imports = [ ./satanael-hardware.nix ];

  networking.hostName = "satanael";

  hardware.graphics.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;
  services.xserver.videoDrivers = [ "nvidia" ];
}
