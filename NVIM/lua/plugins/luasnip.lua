return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",  -- Kết nối LuaSnip với nvim-cmp
      "rafamadriz/friendly-snippets" -- Snippet mẫu từ VSCode
    },
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",    -- Hoàn thành từ LSP
  --     "hrsh7th/cmp-buffer",       -- Hoàn thành từ buffer hiện tại
  --     "hrsh7th/cmp-path",         -- Hoàn thành đường dẫn file
  --     "hrsh7th/cmp-cmdline",      -- Hoàn thành command line
  --   },
  --   config = function()
  --     local cmp = require("cmp")
  --     
  --     -- Tải snippets từ friendly-snippets
  --     require("luasnip.loaders.from_vscode").lazy_load()
  --
  --     cmp.setup({
  --       snippet = {
  --         expand = function(args)
  --           require("luasnip").lsp_expand(args.body)
  --         end,
  --       },
  --       window = {
  --         completion = cmp.config.window.bordered(),
  --         documentation = cmp.config.window.bordered(),
  --       },
  --       mapping = cmp.mapping.preset.insert({
  --         ["<C-b>"] = cmp.mapping.scroll_docs(-4),      -- Cuộn tài liệu lên
  --         ["<C-f>"] = cmp.mapping.scroll_docs(4),       -- Cuộn tài liệu xuống
  --         ["<C-Space>"] = cmp.mapping.complete(),       -- Mở menu hoàn thành
  --         ["<C-e>"] = cmp.mapping.abort(),              -- Đóng menu hoàn thành
  --         ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Xác nhận lựa chọn
  --         ["<C-k>"] = cmp.mapping.select_prev_item(),   -- Chọn mục phía trên
  --         ["<C-j>"] = cmp.mapping.select_next_item(),   -- Chọn mục phía dưới
  --       }),
  --       sources = cmp.config.sources({
  --         { name = "nvim_lsp" },     -- Từ LSP servers
  --         { name = "luasnip" },      -- Từ snippets
  --         { name = "buffer" },       -- Từ buffer hiện tại
  --         { name = "path" },         -- Đường dẫn file hệ thống
  --       }),
  --     })
  --   end,
  -- },
}
