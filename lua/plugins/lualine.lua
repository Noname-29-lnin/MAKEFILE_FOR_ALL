return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional: for icons
  config = function()
    require("lualine").setup({
      options = {
        theme = "ayu_mirage", -- Built-in theme (if available)
        -- OR: Custom theme (see below)
        component_separators = { left = "│", right = "│" }, -- Clean separators
        section_separators = { left = "", right = "" }, -- No bold separators
        disabled_filetypes = { "NvimTree", "alpha" }, -- Disable in these windows
      },
      sections = {
        lualine_a = { "mode" }, -- Left-aligned mode (NORMAL, INSERT, etc.)
        lualine_b = { "branch", "diff", "diagnostics" }, -- Git + LSP info
        lualine_c = { { "filename", path = 1 } }, -- Current file path
        lualine_x = { "encoding", "fileformat", "filetype" }, -- Right-aligned metadata
        lualine_y = { "progress" }, -- Current line/total
        lualine_z = { "location" }, -- Cursor position
      },
      extensions = { "fugitive", "nvim-tree" }, -- Plugin integrations
    })
  end,
}

-- return {
-- 	"nvim-lualine/lualine.nvim",
-- 	config = function()
-- 		require("lualine").setup({
-- 			options = {
-- 				theme = "ayu_mirage",
-- 			},
-- 		})
-- 	end,
-- }
