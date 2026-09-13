{ pkgs, ... }:

{
  users.users."yenterick" = {
    isNormalUser = true;
    description = "Yenterick";
    extraGroups = [ "networkmanager" "wheel" "docker" "input" "video" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
