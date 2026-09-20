{ pkgs, lib, inputs, ... }:

let
  starter = inputs.lazyvim-starter;
  palette = import ../core/palette.nix;
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
    ".config/nvim/lua/config/options.lua".source = ./lazyvim/lua/config/options.lua;
    ".config/nvim/lua/config/keymaps.lua".source = "${starter}/lua/config/keymaps.lua";
    ".config/nvim/lua/config/autocmds.lua".source = "${starter}/lua/config/autocmds.lua";
    ".config/nvim/lua/plugins/example.lua".source = "${starter}/lua/plugins/example.lua";
    ".config/nvim/lua/plugins/completion.lua".source = ./lazyvim/lua/plugins/completion.lua;
    ".config/nvim/lua/plugins/web.lua".source = ./lazyvim/lua/plugins/web.lua;
    ".config/nvim/stylua.toml".source = "${starter}/stylua.toml";
    ".config/nvim/.neoconf.json".source = "${starter}/.neoconf.json";

    ".config/nvim/colors/custom.lua".text = ''
      vim.cmd("hi clear")
      if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
      end
      vim.o.background = "dark"
      vim.o.termguicolors = true
      vim.g.colors_name = "custom"

      local function hi(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
      end

      hi("Normal", { fg = "${palette.foreground}", bg = "${palette.background}" })
      hi("NormalFloat", { fg = "${palette.foreground}", bg = "${palette.background}" })
      hi("FloatBorder", { fg = "${palette.color8}", bg = "${palette.background}" })
      hi("CursorLine", { bg = "${palette.color0}" })
      hi("CursorLineNr", { fg = "${palette.accent}", bold = true })
      hi("LineNr", { fg = "${palette.color8}" })
      hi("SignColumn", { bg = "${palette.background}" })
      hi("Visual", { bg = "${palette.color5}" })
      hi("Search", { fg = "${palette.background}", bg = "${palette.accent}" })
      hi("IncSearch", { fg = "${palette.background}", bg = "${palette.color9}" })
      hi("MatchParen", { bg = "${palette.color6}", bold = true })
      hi("Pmenu", { fg = "${palette.foreground}", bg = "${palette.background}" })
      hi("PmenuSel", { fg = "${palette.background}", bg = "${palette.accent}" })
      hi("StatusLine", { fg = "${palette.foreground}", bg = "${palette.color0}" })
      hi("StatusLineNC", { fg = "${palette.color8}", bg = "${palette.color0}" })
      hi("WinSeparator", { fg = "${palette.color0}" })
      hi("VertSplit", { fg = "${palette.color0}" })
      hi("TabLine", { fg = "${palette.color8}", bg = "${palette.color0}" })
      hi("TabLineSel", { fg = "${palette.foreground}", bg = "${palette.background}" })
      hi("WinBar", { fg = "${palette.foreground}", bg = "${palette.background}" })
      hi("WinBarNC", { fg = "${palette.color8}", bg = "${palette.background}" })
      hi("Title", { fg = "${palette.accent}", bold = true })
      hi("NonText", { fg = "${palette.color8}" })
      hi("EndOfBuffer", { fg = "${palette.background}" })
      hi("MsgArea", { fg = "${palette.foreground}" })
      hi("ErrorMsg", { fg = "${palette.color3}", bold = true })
      hi("WarningMsg", { fg = "${palette.color10}" })
      hi("MoreMsg", { fg = "${palette.color4}" })
      hi("Question", { fg = "${palette.color4}" })
      hi("DiffAdd", { fg = "${palette.foreground}", bg = "${palette.color4}" })
      hi("DiffChange", { fg = "${palette.foreground}", bg = "${palette.color6}" })
      hi("DiffDelete", { fg = "${palette.foreground}", bg = "${palette.color3}" })
      hi("DiffText", { fg = "${palette.foreground}", bg = "${palette.color12}" })

      hi("Comment", { fg = "${palette.color8}", italic = true })
      hi("Constant", { fg = "${palette.color9}" })
      hi("String", { fg = "${palette.color2}" })
      hi("Character", { fg = "${palette.color2}" })
      hi("Number", { fg = "${palette.color9}" })
      hi("Boolean", { fg = "${palette.color9}" })
      hi("Float", { fg = "${palette.color9}" })
      hi("Identifier", { fg = "${palette.color6}" })
      hi("Function", { fg = "${palette.color12}" })
      hi("Statement", { fg = "${palette.accent}" })
      hi("Conditional", { fg = "${palette.accent}" })
      hi("Repeat", { fg = "${palette.accent}" })
      hi("Label", { fg = "${palette.color5}" })
      hi("Operator", { fg = "${palette.foreground}" })
      hi("Keyword", { fg = "${palette.accent}", bold = true })
      hi("Exception", { fg = "${palette.color3}" })
      hi("PreProc", { fg = "${palette.color13}" })
      hi("Include", { fg = "${palette.color13}" })
      hi("Define", { fg = "${palette.color13}" })
      hi("Macro", { fg = "${palette.color13}" })
      hi("PreCondit", { fg = "${palette.color13}" })
      hi("Type", { fg = "${palette.color10}" })
      hi("StorageClass", { fg = "${palette.color10}" })
      hi("Structure", { fg = "${palette.color10}" })
      hi("Typedef", { fg = "${palette.color10}" })
      hi("Special", { fg = "${palette.color5}" })
      hi("SpecialChar", { fg = "${palette.color5}" })
      hi("Delimiter", { fg = "${palette.color7}" })
      hi("Underlined", { fg = "${palette.color4}", underline = true })
      hi("Error", { fg = "${palette.color3}", bold = true })
      hi("Todo", { fg = "${palette.background}", bg = "${palette.color10}", bold = true })
    '';

    ".config/nvim/lua/plugins/colorscheme.lua".text = ''
      return {
        { "LazyVim/LazyVim", opts = { colorscheme = "custom" } },
      }
    '';
  };

  home.packages = with pkgs; [
    neovim
    tree-sitter
    nerd-fonts.jetbrains-mono
  ];

  # Nix store files keep a fixed mtime across generations, so Neovim's
  # vim.loader bytecode cache (~/.cache/nvim/luac) never sees our nvim
  # config files as "changed" and keeps serving stale compiled versions.
  # Clear it on every switch so edits actually take effect.
  home.activation.clearNvimLuaCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -rf "$HOME/.cache/nvim/luac"
  '';
}