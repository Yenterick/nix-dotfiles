return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- nil comes from nixpkgs; Mason would try to build it with cargo
        nil_ls = { mason = false },
      },
    },
  },
}
