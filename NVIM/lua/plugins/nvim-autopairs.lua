return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
  
      npairs.setup({
        check_ts = true,  -- Bật Treesitter để hỗ trợ thông minh hơn
        disable_filetype = { "TelescopePrompt", "vim" }, -- Tắt tự động đóng trong một số filetype
        enable_check_bracket_line = false, -- Không tự động đóng nếu có dấu đóng trên cùng một dòng
      })
  
      -- Thêm cặp ký tự tùy chỉnh
      npairs.add_rules({
  --      Rule("<", ">", "c"),  -- Tự động đóng < > trong file Lua
        Rule("$", "$", "tex"),  -- Tự động đóng $ trong file TeX
        -- Rule("\[", "\]", "tex"),
      })
  
      -- Loại bỏ tự động đóng dấu " trong Python
      npairs.get_rules('"')[1]:with_pair(function()
        return vim.bo.filetype ~= "python"
      end)
    end
  }
  
