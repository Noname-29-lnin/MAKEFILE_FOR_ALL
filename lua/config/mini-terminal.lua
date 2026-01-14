
local state = { floating = { buf = -1, win = -1 }, prev_win = nil }

local function create_floating_window(opts)
    opts = opts or {}
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)

    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local buf
    if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    local config = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded"
    }
    vim.api.nvim_set_hl(0, "MyFloatingWindow", { bg = "#1e1e1e", fg = "#ffffff", blend = 10 })
    local win = vim.api.nvim_open_win(buf, true, config)

    return { buf = buf, win = win }
end

local function toggle_term()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.prev_win = vim.api.nvim_get_current_win()  -- Lưu cửa sổ trước đó
        state.floating = create_floating_window { buf = state.floating.buf }
        vim.api.nvim_set_current_win(state.floating.win)

        -- Nếu buffer chưa phải là terminal, thì mở terminal
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd("terminal")
        end

        vim.cmd("startinsert")
    else
        vim.api.nvim_win_hide(state.floating.win)
        if vim.api.nvim_win_is_valid(state.prev_win) then
            vim.api.nvim_set_current_win(state.prev_win)
        end
    end
end

-- Cấu hình một terminal nhỏ trong nvim
vim.api.nvim_create_user_command("FTerm", toggle_term, {})
vim.keymap.set({ "n", "t" }, "<leader>T", toggle_term)
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
