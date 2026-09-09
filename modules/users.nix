{ pkgs, ... }:

{
  users.users."yenterick" = {
    isNormalUser = true;
    description = "Yenterick";
    extraGroups = [ "networkmanager" "wheel" "docker" "input" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
