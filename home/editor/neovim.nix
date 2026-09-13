{ pkgs, inputs, ... }:

let
  starter = inputs.lazyvim-starter;
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  home.file = {
    ".config/nvim/init.lua".source = "${starter}/init.lua";
    ".config/nvim/lua/config/lazy.lua".source = ./lazyvim/lua/config/lazy.lua;
    ".config/nvim/lua/config/options.lua".source = "${starter}/lua/config/options.lua";
    ".config/nvim/lua/config/keymaps.lua".source = "${starter}/lua/config/keymaps.lua";
    ".config/nvim/lua/config/autocmds.lua".source = "${starter}/lua/config/autocmds.lua";
    ".config/nvim/lua/plugins/example.lua".source = "${starter}/lua/plugins/example.lua";
    ".config/nvim/stylua.toml".source = "${starter}/stylua.toml";
    ".config/nvim/.neoconf.json".source = "${starter}/.neoconf.json";
  };

  home.packages = with pkgs; [
    neovim
    tree-sitter
    nerd-fonts.jetbrains-mono
  ];
}