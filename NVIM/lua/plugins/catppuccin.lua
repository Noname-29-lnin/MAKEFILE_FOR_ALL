return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- Load this plugin first
  opts = { -- Catppuccin configuration options
    flavour = "mocha", -- latte, frappe, macchiato, mocha (default: mocha)
    background = {
      light = "latte", -- for light mode
      dark = "mocha",  -- for dark mode
    },
    transparent_background = true, -- Disable background (make it transparent)
    show_end_of_buffer = false, -- Hide ~ lines after the end of a buffer
    term_colors = true, -- Enable terminal colors
    styles = {
      comments = { "italic" }, -- Italic comments
      conditionals = { "italic" },
    },
    integrations = {
      telescope = true,
      mason = true,
      treesitter = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
      },
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin") -- Set as default colorscheme
  end,
}
