return {
    {
      "sainnhe/everforest", -- Colorscheme Everforest
      config = function()
      -- Thiết lập colorscheme Everforest
          vim.g.everforest_background = "hard" -- 'hard', 'medium', hoặc 'soft'
          vim.g.everforest_better_performance = 1 -- Cải thiện hiệu suất
          vim.g.everforest_enable_italic = 1 -- Bật chữ nghiêng
          vim.g.everforest_transparent_background = 1 -- Nền trong suốt (nếu hỗ trợ)
      end,
    },
  }
  