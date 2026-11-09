{ pkgs, ... }:

{
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  hardware.steam-hardware.enable = true;

  # Game streaming host; connect with Moonlight. Web UI at https://localhost:47990
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # required for KMS capture on Wayland
    openFirewall = true;
  };

  # Minecraft server (~/Documents/minecraft-server) for LAN play
  networking.firewall.allowedTCPPorts = [ 25565 ];

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
