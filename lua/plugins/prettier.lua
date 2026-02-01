return {
  {
    "MunifTanjim/prettier.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",  -- Cần cho LSP integration
      "jose-elias-alvarez/null-ls.nvim"  -- Tùy chọn nếu muốn dùng qua null-ls
    },
    config = function()
      require("prettier").setup({
        bin = 'prettier',  -- Hoặc đường dẫn đầy đủ nếu không trong PATH
        filetypes = {
          "css",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "json",
          "scss",
          "less",
          "html",
          "vue",
          "svelte",
          "markdown",
          "yaml",
          "graphql",
        },
        -- Cấu hình mặc định
        cli_options = {
          arrow_parens = "always",
          bracket_spacing = true,
          bracket_same_line = false,
          embedded_language_formatting = "auto",
          end_of_line = "lf",
          html_whitespace_sensitivity = "css",
          jsx_single_quote = false,
          print_width = 80,
          prose_wrap = "preserve",
          quote_props = "as-needed",
          semi = true,
          single_attribute_per_line = false,
          single_quote = false,
          tab_width = 2,
          trailing_comma = "es5",
          use_tabs = false,
          vue_indent_script_and_style = false,
        },
      })

      -- Keymap để format code với Prettier
      vim.keymap.set('n', '<leader>p', '<cmd>Prettier<CR>', { desc = 'Format code with Prettier' })

      -- Tự động format khi save (tùy chọn)
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.js', '*.jsx', '*.ts', '*.tsx', '*.css', '*.scss', '*.json', '*.html', '*.vue' },
        callback = function()
          vim.cmd('Prettier')
        end,
      })
    end
  }
}
