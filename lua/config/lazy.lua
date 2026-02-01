-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\" -- for plugin mappings

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure checker for automatic updates
  checker = {
    enabled = true, -- Bật tự động kiểm tra cập nhật
    notify = false, -- Tắt thông báo khi có cập nhật
    frequency = 86400, -- Kiểm tra mỗi 24 giờ (giây)
  },
  -- Tắt rocks vì không cần thiết
  rocks = {
    enabled = false,
  },
})

-- Tự động chạy `:Lazy sync` khi có cập nhật
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyCheckDone",
  callback = function()
    if require("lazy").has_updates() then
      require("lazy").sync({ wait = true })
    end
  end,
})
