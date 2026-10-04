{ pkgs, ... }:

{
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  hardware.steam-hardware.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    gamescope
    protontricks
    winetricks
    wineWow64Packages.stable
    lutris
    vulkan-tools
  ];
}
