--- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- UI
vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "white" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#ead84e" })
vim.opt.colorcolumn = "94"

-- Clipboard & Search
vim.opt.clipboard = "unnamedplus"  -- Prefer 'unnamedplus' for + register
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Colorscheme Persistence
local config_path = vim.fn.stdpath("config") .. "/colorscheme.vim"

function SetColorScheme(scheme)
    pcall(vim.cmd, "colorscheme " .. scheme)
    vim.fn.writefile({ scheme }, config_path)
end

vim.api.nvim_create_user_command("SetColorScheme", function(opts)
    SetColorScheme(opts.args)
end, { nargs = 1, complete = "color" })

-- Load saved colorscheme
if vim.fn.filereadable(config_path) == 1 then
    local scheme = vim.fn.readfile(config_path)[1]
    if scheme and scheme ~= "" then
        pcall(vim.cmd, "colorscheme " .. scheme)
    end
end

-- Auto-save on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        local scheme = vim.g.colors_name
        if scheme then
            vim.fn.writefile({ scheme }, config_path)
        end
    end,
})
-- vim.cmd("set expandtab")
-- vim.cmd("set tabstop=4")
-- vim.cmd("set softtabstop=4")
-- vim.cmd("set shiftwidth=4")
-- vim.cmd("set number")
-- vim.cmd("set relativenumber")
-- vim.cmd("set cursorline")
-- vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "white" })
-- vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#ead84e" })
-- vim.api.nvim_set_option("clipboard", "unnamed")
-- vim.opt.hlsearch = true
-- vim.opt.incsearch = true
-- -- move selected lines
-- vim.opt.colorcolumn = "94"
--
-- -- colorcheme
-- local config_path = vim.fn.stdpath("config") .. "/colorscheme.vim"
--
-- -- Hàm đặt colorscheme và lưu lại lựa chọn
-- function SetColorScheme(scheme)
--     vim.cmd("colorscheme " .. scheme)
--     vim.fn.writefile({ scheme }, config_path) -- Chỉ lưu tên scheme, không có "colorscheme "
-- end
--
-- -- Tạo lệnh `:SetColorScheme`
-- vim.api.nvim_create_user_command("SetColorScheme", function(opts)
--     SetColorScheme(opts.args)
-- end, { nargs = 1, complete = "color" })
--
-- -- Tải colorscheme đã lưu khi khởi động
-- if vim.fn.filereadable(config_path) == 1 then
--     local scheme = vim.fn.readfile(config_path)[1]
--     if scheme and scheme ~= "" then
--         vim.cmd("colorscheme " .. scheme)
--     end
-- end
-- -- background
-- -- set language based on vim mode
-- -- requires im-select https://github.com/daipeihust/im-select
-- -- recommend installing it by brew
-- local function get_current_layout()
-- 	local f = io.popen("im-select")
-- 	local layout = nil
-- 	if f ~= nil then
-- 		layout = f:read("*all"):gsub("\n", "")
-- 		f:close()
-- 	end
-- 	return layout
-- end
--
-- -- Save current layout
-- local last_insert_layout = get_current_layout()
-- local english_layout = "com.apple.keylayout.ABC"
--
-- -- If exit insert mode, in command mode -> eng layout,
-- -- save the current layout to the variable, then use it for the
-- -- next insert time
-- vim.api.nvim_create_autocmd("InsertLeave", {
-- 	callback = function()
-- 		local current = get_current_layout()
-- 		last_insert_layout = current
-- 		os.execute("im-select " .. english_layout)
-- 	end,
-- })
--
-- -- mode change to normal -> eng layout
-- vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
-- 	pattern = "*:*n",
-- 	callback = function()
-- 		os.execute("im-select " .. english_layout)
-- 	end,
-- })
--
-- -- when back to nvim, restore prev layout
-- vim.api.nvim_create_autocmd("InsertEnter", {
-- 	callback = function()
-- 		os.execute("im-select " .. last_insert_layout)
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd({ "FocusGained" }, {
-- 	callback = function()
-- 		os.execute("im-select " .. last_insert_layout)
-- 	end,
-- })
