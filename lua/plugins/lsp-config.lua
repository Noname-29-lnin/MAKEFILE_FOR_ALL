-- return {
--   {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--       "williamboman/mason.nvim",
--       "williamboman/mason-lspconfig.nvim",
--     },
--     config = function()
--       -- Setup mason
--       require("mason").setup()
--       require("mason-lspconfig").setup({
--         ensure_installed = { "lua_ls", "clangd", "pyright" }
--       })
--
--       local lspconfig = require("lspconfig")
--       local capabilities = require("cmp_nvim_lsp").default_capabilities()
--
--       local on_attach = function(client, bufnr)
--         vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
--       end
--
--       -- Cấu hình các LSP server
--       lspconfig.lua_ls.setup({
--         on_attach = on_attach,
--         capabilities = capabilities,
--         settings = {
--           Lua = {
--             runtime = {
--               version = "LuaJIT",
--             },
--             diagnostics = {
--               globals = { "vim" },
--             },
--             workspace = {
--               library = vim.api.nvim_get_runtime_file("", true),
--               checkThirdParty = false,
--             },
--             telemetry = {
--               enable = false,
--             },
--           },
--         },
--       })
--
--       lspconfig.clangd.setup({
--         on_attach = on_attach,
--         capabilities = capabilities,
--         cmd = {
--           "clangd",
--           "--background-index",
--           "--clang-tidy",
--           "--header-insertion=never",
--           "--all-scopes-completion",
--           "--completion-style=detailed",
--           "--cross-file-rename",
--         },
--       })
--
--       lspconfig.pyright.setup({
--         on_attach = on_attach,
--         capabilities = capabilities,
--         settings = {
--           python = {
--             analysis = {
--               autoSearchPaths = true,
--               diagnosticMode = "workspace",
--               useLibraryCodeForTypes = true,
--               typeCheckingMode = "basic",
--             },
--           },
--         },
--       })
--     end,
--   },
--   -- Tách riêng cấu hình null-ls và prettier
--   {
--     "jose-elias-alvarez/null-ls.nvim",
--     dependencies = { "nvim-lua/plenary.nvim" },
--     config = function()
--       local null_ls = require("null-ls")
--       null_ls.setup({
--         sources = {
--           null_ls.builtins.formatting.prettier.with({
--             filetypes = {
--               "javascript",
--               "javascriptreact",
--               "typescript",
--               "typescriptreact",
--               "vue",
--               "css",
--               "scss",
--               "less",
--               "html",
--               "json",
--               "yaml",
--               "markdown",
--               "graphql"
--             },
--           }),
--         },
--       })
--     end
--   },
--   {
--     "MunifTanjim/prettier.nvim",
--     config = function()
--       require("prettier").setup({
--         bin = 'prettier',
--         filetypes = {
--           "css",
--           "javascript",
--           "javascriptreact",
--           "typescript",
--           "typescriptreact",
--           "json",
--           "scss",
--           "less",
--           "html",
--           "vue",
--           "markdown",
--           "yaml"
--         }
--       })
--     end
--   }
-- }

return {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- để capabilities có completion nâng cao
    },
    config = function()
      -- Mason setup
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd", "pyright" },
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local bufmap = function(mode, lhs, rhs)
          vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
        end
        -- phím tắt cơ bản
        bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
        bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
        bufmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
        bufmap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
        bufmap("n", "gr", "<cmd>Telescope lsp_references<CR>")
        bufmap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
      end

      -- Lua LSP
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      -- C/C++
      lspconfig.clangd.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          "--all-scopes-completion",
          "--completion-style=detailed",
          "--cross-file-rename",
        },
      })

      -- Python
      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic",
            },
          },
        },
      })
    end,
  },

  -- Formatter/Linter qua null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          -- Prettier
          null_ls.builtins.formatting.prettier.with({
            filetypes = {
              "javascript", "javascriptreact",
              "typescript", "typescriptreact",
              "vue", "css", "scss", "less",
              "html", "json", "yaml", "markdown",
              "graphql",
            },
          }),
          -- Bạn có thể thêm black (python) hoặc clang_format (C/C++) nếu muốn:
          -- null_ls.builtins.formatting.black,
          -- null_ls.builtins.formatting.clang_format,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
            })
          end
        end,
      })
    end,
  },
}
