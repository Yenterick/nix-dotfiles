{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "powerlevel10k/powerlevel10k";
      custom = "${pkgs.zsh-powerlevel10k}/share/zsh";
      plugins = [ "git" "docker" ];
    };

    shellAliases = {
      ll = "ls -la";
      lg = "lazygit";
    };

    initContent = "[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh && fastfetch";
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = "Yenterick";
      user.email = "yenterick@gmail.com";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];
}
