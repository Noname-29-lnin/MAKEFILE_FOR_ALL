-- return {
--   "nvim-neo-tree/neo-tree.nvim",
--   branch = "v3.x",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
--     "MunifTanjim/nui.nvim",
--     -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window
--   },
--   lazy = false, -- neo-tree will lazily load itself
--   ---@module "neo-tree"
--   ---@type neotree.Config?
--   opts = {
--     filesystem = {
--       filtered_items = {
--         visible = true,       -- Hiện các file ẩn trong tree
--         hide_dotfiles = false, -- Không ẩn dotfiles (., .git, .config, ...)
--         hide_gitignored = false, -- Không ẩn file bị git ignore
--       },
--     },
--   },
-- }

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(file_path)
          if file_path:match("%.pdf$") then
            vim.fn.jobstart({ "firefox", file_path }, { detach = true })
            vim.cmd("bd!")
          elseif file_path:match("%.png$")
              or file_path:match("%.jpg$")
              or file_path:match("%.jpeg$")
              or file_path:match("%.gif$") then
            vim.fn.jobstart({ "xdg-open", file_path }, { detach = true })
            vim.cmd("bd!")
          elseif file_path:match("%.md$") then
            vim.fn.jobstart({ "code", file_path }, { detach = true })
            vim.cmd("bd!")
          end
        end,
      },
    },
  },
}
