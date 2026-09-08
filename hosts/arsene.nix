{ ... }:

{
  imports = [ ../hardware-configuration.nix ];
  networking.hostName = "arsene";
  hardware.graphics.enable = true;
}
