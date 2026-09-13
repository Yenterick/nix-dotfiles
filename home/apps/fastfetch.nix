{ ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "NixOS_small";
        padding = {
          top = 1;
        };
      };
      display = {
        separator = " ";
      };
      modules = [
        "title"
        "separator"
        "os"
        "kernel"
        "uptime"
        "shell"
        "terminal"
        "cpu"
        "memory"
        "disk"
        "break"
        "colors"
      ];
    };
  };
}
