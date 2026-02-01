return {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- Gợi ý từ LSP
      "hrsh7th/cmp-buffer",       -- Gợi ý từ buffer hiện tại
      "hrsh7th/cmp-path",         -- Gợi ý đường dẫn file
      "hrsh7th/cmp-cmdline",      -- Gợi ý trong command-line
      "L3MON4D3/LuaSnip",         -- Snippet engine
      "saadparwaiz1/cmp_luasnip", -- Gợi ý snippet
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
  
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),  -- Gọi menu gợi ý
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Chọn gợi ý
          ["<Tab>"] = cmp.mapping.select_next_item(), -- Chuyển đến mục tiếp theo
          ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Chuyển đến mục trước
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- LSP (Language Server)
          { name = "buffer" },   -- Biến & hàm trong buffer
          { name = "path" },     -- Đường dẫn file
          { name = "luasnip" },  -- Snippet
        }),
      })
    end
  }
  
