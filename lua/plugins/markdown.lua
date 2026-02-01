return {
  -- 1. Enhanced Markdown rendering with Treesitter
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.nvim",
    },
    ft = "markdown",
    opts = {
      -- Disable LaTeX support to avoid warnings
      latex = { enabled = false },

      -- New config structure
      highlight = {
        inline_code = { conceal = true },
        headings = { "Title" }, -- maps to heading highlights
      },
      code = {
        enable = true,         -- replaces "codeblock"
        lang = true,           -- language-based highlighting
      },
    },
  },

  -- 2. Improved Markdown syntax features
  {
    "preservim/vim-markdown",
    ft = "markdown",
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_conceal = 0
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_toc_autofit = 1
    end,
  },

  -- 3. Obsidian-style wiki links and notes
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/Documents/notes",
        },
      },
      completion = {
        nvim_cmp = true,
      },
    },
  },

  -- 4. (Optional) Markdown snippets
  -- {
  --   "L3MON4D3/LuaSnip",
  --   dependencies = {
  --     "rafamadriz/friendly-snippets",
  --   },
  --   config = function()
  --     require("luasnip.loaders.from_vscode").lazy_load()
  --   end,
  -- },
}
