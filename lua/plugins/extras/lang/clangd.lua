return {

  -- add c/c++ to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "c")
      table.insert(opts.ensure_installed, "cpp")
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "p00f/clangd_extensions.nvim",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
      },
    },
    opts = {
      -- make sure mason installs the server
      servers = {
        clangd = { mason = false },
      },
      setup = {
        clangd = function(_, opts)
          require("clangd_extensions").setup({
            server = opts,
          })
          return true
        end,
      },
    },
  },
}
