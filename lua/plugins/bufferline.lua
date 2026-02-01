return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",  -- Hiển thị buffer dưới dạng tab
          numbers = "ordinal",  -- Đánh số buffer
          diagnostics = "nvim_lsp",  -- Hiển thị lỗi từ LSP
          separator_style = "thick",  -- Kiểu phân cách dày giữa các buffer
          show_buffer_close_icons = false,  -- Ẩn icon đóng buffer
          show_close_icon = false,
          always_show_bufferline = true,
          enforce_regular_tabs = true, -- Giữ tab cùng kích thước
          max_name_length = 18, -- Giới hạn độ dài tên file hiển thị
          max_prefix_length = 15, -- Giới hạn độ dài tiền tố
          tab_size = 18, -- Kích thước tab
          indicator = {
            icon = "▎",  -- Dấu hiệu buffer đang mở
            style = "icon",
          },
          separator_style = { "▏", "▏" }, -- Đường phân cách buffer
          buffer_close_icon = "✖", -- Icon đóng buffer
          modified_icon = "●", -- Icon hiển thị file đã sửa đổi
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          highlights = {
            buffer_selected = {
              fg = "#ffffff", -- Màu buffer đang chọn
              bold = true,
              italic = false,
            },
            separator_selected = {
              fg = "#61afef", -- Màu separator khi buffer được chọn
            },
            separator_visible = {
              fg = "#3e4451",
            },
            separator = {
              fg = "#3e4451",
            },
          },
          offsets = {
            {
              filetype = "NvimTree",
              text = "📂 File Explorer",
              highlight = "Directory",
              separator = true
            }
          },
        }
      })
  
      -- -- 🚀 Thiết lập phím tắt nhanh
      -- local keymap = vim.keymap.set
      -- keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true, desc = "Chuyển buffer tiếp theo" })
      -- keymap("n", "<leader>bc", ":bd<CR>", { silent = true, desc = "Đóng buffer hiện tại" })
      -- keymap("n", "<leader>bp", ":BufferLinePick<CR>", { silent = true, desc = "Chọn buffer bằng số" })
      -- keymap("n", "<leader>bs", ":BufferLineSortByExtension<CR>", { silent = true, desc = "Sắp xếp buffer theo loại file" })
    end
  }
  