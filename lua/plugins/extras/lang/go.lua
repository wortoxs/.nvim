return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "go")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = { "go", "gomod" },
    lazy = true,
    opts = {
      servers = {
        gopls = {},
      },
    },
  },

  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      --   "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}
