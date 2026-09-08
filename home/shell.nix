{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" ];
    };

    shellAliases = {
      ll = "ls -la";
      lg = "lazygit";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = "Yenterick";
      user.email = "yenterick@example.com";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    fd
    ripgrep
    fzf
    lazygit
    unzip
    lazydocker
    lazysql
  ];
}