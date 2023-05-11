-- Update this path

return {
  -- add rust to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "rust")
      table.insert(opts.ensure_installed, "toml")
    end,
  },

  -- correctly setup lspconfig for Rust 🦀
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "simrat39/rust-tools.nvim",
    },
    opts = {
      servers = {
        rust_analyzer = {
          mason = false,
          settings = {
            ["rust-analyzer"] = {
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "self",
              },
              cargo = {
                buildScripts = {
                  enable = true,
                },
              },
              procMacro = {
                enable = true,
              },
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
      },
      setup = {
        rust_analyzer = function(_, opts)
          local codelldb_path = ""
          local liblldb_path = ""
          local this_os = vim.loop.os_uname().sysname

          local mason_registry = require("mason-registry")
          local codelldb = mason_registry.get_package("codelldb") -- note that this will error if you provide a non-existent package name
          local codelldb_install_path = codelldb:get_install_path() -- returns a string like "/home/user/.local/share/nvim/mason/packages/codelldb"
          -- The path in windows is different
          if this_os:find("Windows") then
            codelldb_path = codelldb_install_path .. "\\extension\\adapter\\codelldb.exe"
            liblldb_path = codelldb_install_path .. "\\extension\\lldb\\bin\\liblldb.dll"
          else
            -- The liblldb extension is .so for linux and .dylib for macOS
            codelldb_path = codelldb_install_path .. "/extension" .. "/adapter/codelldb"
            liblldb_path = codelldb_install_path
              .. "/extension"
              .. "/lldb/lib/liblldb"
              .. (this_os == "Linux" and ".so" or ".dylib")
          end

          local rust_tool_opts = vim.tbl_deep_extend("force", opts, {
            dap = {
              adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
            },
          })

          require("rust-tools").setup(rust_tool_opts)
          return true
        end,
      },
    },
  },
}
