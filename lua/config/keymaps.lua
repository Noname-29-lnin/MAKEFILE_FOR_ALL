-- Keymaps
vim.keymap.set("n", "<leader>q", ":q<CR>", {
  desc = 'Thoát'
})
vim.keymap.set("n", "<leader>Q", ":q!<CR>", {
  desc = 'Thoát không lưu'
})
vim.keymap.set('n', '<leader>qq', ':qa<CR>', {
  noremap = true, 
  silent = false,
  desc = 'Thoát toàn bộ'
})
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {
  desc = 'Di chuyển đoạn văn đã chọn đi xuống'
})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv",{
  desc = 'Di chuyển đoạn văn đã chọn đi lên'
})

-- ctrl+s để lưu file
vim.keymap.set('n', '<C-s>', ':w<cr>', {
  noremap = true,
  silent = false,
  desc = 'Lưu Buffer hiện tại'
})

-- ctrl+c để copy (sử dụng register hệ thống)
vim.keymap.set('v', '<C-c>', '"+y', {
  noremap = true,
  silent = false,
  desc = 'Copy vào Clipboard'
})

-- ctrl+v để paste (sử dụng register hệ thống)
vim.keymap.set('n', '<C-v>', '"+p', {
  noremap = true,
  silent = false,
  desc = 'Dán nội dung từ Clipboard trước đó vào sau con trỏ'
})
vim.keymap.set('i', '<C-v>', '<c-r>+', {
  noremap = true,
  silent = false,
  desc = 'Dán nội dung từ Clipboard trước đó vào sau con trỏ'
})
vim.keymap.set("x", "<leader>pp", '"_dP', {
  noremap = true,
  silent = false,
  desc = "Paste mà không ghi đè clipboard"
})
-- vim.keymap.set('x', '<leader>pc', function()
--   local reg_names = { 'a','b','c','d','e','f','g','h','i','j','k',
--                       '+', '*', '"', '0' }
--
--   -- Hiển thị danh sách register để chọn
--   vim.ui.select(reg_names, {
--     prompt = "Chọn register để copy vào:",
--     format_item = function(name)
--       return '"' .. name .. '"'
--     end
--   }, function(choice)
--     if choice then
--       -- Copy vùng chọn vào register đã chọn
--       vim.cmd('normal! "' .. choice .. 'y')
--       vim.notify("Đã copy vào register [" .. choice .. "]", vim.log.levels.INFO)
--     end
--   end)
-- end, {
--   noremap = true,
--   silent = true,
--   desc = "Chọn register để copy (Visual mode)"
-- })
-- vim.keymap.set('n', '<leader>pv', function()
--   -- Lấy danh sách các register có dữ liệu
--   local registers = {}
--   local reg_names = { '"', '0', '1','2','3','4','5','6','7','8','9',
--                       'a','b','c','d','e','f','g','h','i','j','k',
--                       '+', '*', '-', '_', '/' }
--
--   for _, name in ipairs(reg_names) do
--     local content = vim.fn.getreg(name)
--     if content ~= nil and content ~= '' then
--       -- Rút gọn nội dung dài
--       local short_content = content:gsub("\n", "\\n")
--       if #short_content > 50 then
--         short_content = short_content:sub(1, 47) .. "..."
--       end
--       table.insert(registers, { name = name, content = short_content })
--     end
--   end
--
--   if #registers == 0 then
--     vim.notify("Không có register nào có dữ liệu!", vim.log.levels.WARN)
--     return
--   end
--
--   -- Hiển thị chọn bằng vim.ui.select
--   vim.ui.select(registers, {
--     prompt = "Chọn register để paste:",
--     format_item = function(item)
--       return string.format("[%s] %s", item.name, item.content)
--     end
--   }, function(choice)
--     if choice then
--       -- Paste register được chọn tại vị trí con trỏ
--       vim.cmd('normal! "' .. choice.name .. 'p')
--     end
--   end)
-- end, {
--   noremap = true,
--   silent = true,
--   desc = "Chọn register để paste (Normal mode)"
-- })

-- no hight light
vim.keymap.set("n", "<esc>", "<cmd>noh<cr>", {
  silent = false,
  desc = 'Tắt hiện thị highline'
})
-- no keymap ctrl-z suspend neovim
vim.keymap.set("n", "<c-z>", "<nop>", {
  noremap = true,
  silent = false,
  desc = 'Loại bỏ phím tắt <C-z>'
})

-- Set up cuộn chuột 
vim.api.nvim_set_keymap('i', '<C-Up>', '<C-o><C-y>', {noremap = true, silent = true, desc = "cho phép cuộn trang lên" })
vim.api.nvim_set_keymap('i', '<C-Down>', '<C-o><C-e>', {noremap = true, silent = true, desc = "Cho phép cuộn trang xuống"})

-- Copy dòng hiện tại và dán phía trên
vim.keymap.set("n", "<C-S-Up>", "yyP", { noremap = true, silent = true , desc = 'Copy dòng hiện tại và dán phía trên'})
vim.keymap.set("v", "<C-S-Up>", "y`[Pgv", { noremap = true, silent = true, desc = 'Copy vùng chọn và dán phía trên' })

-- Copy dòng hiện tại và dán phía dưới
vim.keymap.set("n", "<C-S-Down>", "yyp", { noremap = true, silent = true , desc = 'Copy dòng hiện tại và dán phía dưới'})
vim.keymap.set("v", "<C-S-Down>", "y`]p", { noremap = true, silent = true, desc = 'Copy vùng chọn và dán phía dưới' })

-- find error (su dung lsp)
vim.keymap.set("n", "<leader>ce", function()
 	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
 	if #diagnostics > 0 then
 		local message = diagnostics[1].message
 		vim.fn.setreg("+", message)
 		print("copied diagnostic: " .. message)
 	else
    print("no diagnostic at cursor")
 	end
end, {
  noremap = true,
  silent = false,
  desc = 'Tìm các Error phát hiện bởi LSP'
})

-- keymaps for neotree
vim.keymap.set("n", "<leader>nt", ":Neotree filesystem reveal left<CR>", {
  desc = 'Mở Neotree bên tay trái'
})
vim.keymap.set("n", "<leader>xx", ":Neotree close<CR>", {
  desc = 'Đóng Neotree'
})
vim.keymap.set("n", "<leader>nf", function()
  vim.cmd("Neotree toggle")
  vim.cmd("wincmd |")  -- maximize width
  vim.cmd("wincmd _")  -- maximize height
end, { desc = "Open Neo-tree full screen" })

-- Obsidian
-- vim.keymap.set("n", "<leader>oo", ":ObsidianQuickSwitch<CR>", { desc = "Obsidian: Quick Switch" })
-- vim.keymap.set("n", "<leader>on", ":ObsidianNew<CR>", { desc = "Obsidian: New Note" })
-- vim.keymap.set("n", "<leader>ot", ":ObsidianToday<CR>", { desc = "Obsidian: Today Note" })
-- vim.keymap.set("n", "<leader>os", ":ObsidianSearch<CR>", { desc = "Obsidian: Search Notes" })
-- -- vim.keymap.set("n", "gf", ":ObsidianFollowLink<CR>", { desc = "Follow [[wiki]] link" })
-- vim.keymap.set("n", "<leader>om", ":ObsidianNew my-note<CR>", { desc = "Create note: my-note.md" })

-- keymaps for lsp
-- vim.keymap.set("n", "k", vim.lsp.buf.hover, {})
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
-- vim.keymap.set("n", "gd", vim.lsp.buf.declaration, {})
-- vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
-- vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

-- keymaps for telescope
local builtin = require("telescope.builtin")
-- tìm file trong thư mục hiện tại bằng fuzzy finder
vim.keymap.set("n", "<leader>ff", builtin.find_files, {
  desc = 'Tìm file trong thư mục hiện tại bằng fuzzy finder'
})
-- tìm file trong thư mục git (chỉ hoạt động nếu thư mục là một repo git)
vim.keymap.set("n", "<leader>pf", builtin.git_files, {
  desc = 'Tìm file trong thư mục git (chỉ hoạt động nếu thư mục là một repo git)'
})
-- tìm kiếm chuỗi trong toàn bộ dự án (dùng ripgrep nếu có)
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
  desc = 'Tìm kiếm chuỗi trong toàn bộ dự án (dùng ripgrep nếu có)'
})
-- liệt kê và tìm kiếm giữa các buffer đang mở
vim.keymap.set("n", "<leader>fb", builtin.buffers, {
  desc = 'Liệt kê và tìm kiếm giữa các buffer đang mở'
})

-- keymaps for comment

-- Keymaps for bufferline.nvim
-- Navigation between buffers
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", {
  desc = "Next buffer"
})
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", {
  desc = "Previous buffer"
})
-- Close buffers
vim.keymap.set("n", "<leader>bc", "<cmd>bdelete<cr>", {
  desc = "Close current buffer"
})
vim.keymap.set("n", "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", {
  desc = "Close all left buffers"
})
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseRight<cr>", {
  desc = "Close all right buffers"
})
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", {
  desc = "Close other buffers"
})
-- Go to buffer by number (1-9)
for i = 1, 9 do
  vim.keymap.set("n", "<leader>"..i, function()
    require("bufferline").go_to_buffer(i)
  end, {
    desc = "Go to buffer "..i
  })
end
vim.keymap.set("n", "<leader>0", function()
  require("bufferline").go_to_buffer(-1)
end, {
  desc = "Go to last buffer"
})

-- Buffer operations
vim.keymap.set("n", "<leader>bp", function()
  require("telescope.builtin").buffers({
    sort_mru = true,
    ignore_current_buffer = true,
    previewer = false,
    layout_config = {
      width = 0.8,
      height = 0.4
    },
    mappings = {
      i = { ["<c-d>"] = "delete_buffer" },
      n = { ["d"] = "delete_buffer" }
    }
  })
end, {
  desc = "Find buffers"
})

vim.keymap.set("n", "<leader>bs", "<cmd>BufferLineSortByExtension<cr>", {
  desc = "Sort by extension"
})

-- keymaps for split
vim.keymap.set('n', '<leader><left>',  '<c-w>h', {
  noremap = true,
  silent = false,
  desc = 'Di chuyển con trỏ sang bên trái của Buffer kế bên'
}) -- qua trái
vim.keymap.set('n', '<leader><right>', '<c-w>l', {
  noremap = true,
  silent = false,
  desc = 'Di chuyển con trỏ sang bên phải của Buffer kế bên'
}) -- qua phải
vim.keymap.set('n', '<leader><up>',    '<c-w>k', {
  noremap = true,
  silent = false,
  desc = 'Di chuyển con trỏ lên trên của Buffer kế bên'
}) -- lên trên
vim.keymap.set('n', '<leader><down>',  '<c-w>j', {
  noremap = true,
  silent = false,
  desc = 'Di chuyển con trỏ xuống dưới của Buffer kế bên'
})
-- vim.keymap.set('n', '<leader>sp', function()
--   vim.ui.select({ 
--     'left',
--     'right',
--     'up',
--     'down',
--     'vertical split',
--     'horizontal split',
--     'adjust width',
--     'adjust height'
--   }, {
--     prompt = 'window operation: ',
--     format_item = function(item)
--       local icons = {
--         ['left'] = 'left (chuyển buffer trái ⬅️)',
--         ['right'] = 'right (chuyển buffer phải ➡️)',
--         ['up'] = 'up (chuyển buffer lên ⬆️)',
--         ['down'] = 'down (chuyển buffer xuống ⬇️)',
--         ['vertical split'] = 'vertical (tách dọc ⇄)',
--         ['horizontal split'] = 'horizontal (tách ngang ⇅)',
--         ['adjust width'] = 'adjust width (điều chỉnh chiều rộng ↔️)',
--         ['adjust height'] = 'adjust height (điều chỉnh chiều cao ↕️)'
--       }
--       return icons[item] or item
--     end
--   }, function(choice)
--     local function swap_buffer(direction)
--       local current_win = vim.api.nvim_get_current_win()
--       local current_buf = vim.api.nvim_win_get_buf(current_win)
--       
--       -- Di chuyển sang hướng chỉ định
--       vim.cmd('wincmd ' .. direction)
--       local target_win = vim.api.nvim_get_current_win()
--       
--       -- Nếu tồn tại cửa sổ đích
--       if target_win ~= current_win then
--         local target_buf = vim.api.nvim_win_get_buf(target_win)
--         
--         -- Hoán đổi buffer giữa 2 cửa sổ
--         vim.api.nvim_win_set_buf(current_win, target_buf)
--         vim.api.nvim_win_set_buf(target_win, current_buf)
--         
--         -- Quay lại cửa sổ ban đầu
--         vim.api.nvim_set_current_win(current_win)
--       else
--         vim.notify("Không có cửa sổ " .. direction, vim.log.levels.WARN)
--       end
--     end
--
--     if choice == 'left' then
--       swap_buffer('h')
--     elseif choice == 'right' then
--       swap_buffer('l')
--     elseif choice == 'up' then
--       swap_buffer('k')
--     elseif choice == 'down' then
--       swap_buffer('j')
--     elseif choice == 'vertical split' then
--       vim.cmd('vsplit')
--     elseif choice == 'horizontal split' then
--       vim.cmd('split')
--     elseif choice == 'adjust width' or choice == 'adjust height' then
--       local is_width = choice == 'adjust width'
--       local prompt = is_width and 'Nhập số cột (Left/Right để điều chỉnh, Enter hoàn tất):' 
--                                or 'Nhập số dòng (Up/Down để điều chỉnh, Enter hoàn tất):'
--       local default_value = is_width and vim.fn.winwidth(0) or vim.fn.winheight(0)
--       
--       vim.ui.input({
--         prompt = prompt,
--         default = tostring(default_value),
--         -- Xử lý khi nhấn phím mũi tên
--         on_key = function(key, value)
--           local new_value = tonumber(value) or default_value
--           if key == 'Left' and is_width then
--             new_value = new_value - 1
--             vim.cmd('vertical resize ' .. new_value)
--             return tostring(new_value) -- Cập nhật giá trị hiển thị
--           elseif key == 'Right' and is_width then
--             new_value = new_value + 1
--             vim.cmd('vertical resize ' .. new_value)
--             return tostring(new_value)
--           elseif key == 'Up' and not is_width then
--             new_value = new_value - 1
--             vim.cmd('resize ' .. new_value)
--             return tostring(new_value)
--           elseif key == 'Down' and not is_width then
--             new_value = new_value + 1
--             vim.cmd('resize ' .. new_value)
--             return tostring(new_value)
--           end
--           -- Giữ nguyên giá trị cho các phím khác
--           return nil
--         end
--       }, function(input)
--         if input then
--           local new_size = tonumber(input)
--           if new_size then
--             if is_width then
--               vim.cmd('vertical resize ' .. new_size)
--             else
--               vim.cmd('resize ' .. new_size)
--             end
--           end
--         end
--       end)
--     end
--   end)
-- end, {
--   noremap = true,
--   silent = false,
--   desc = "Thao tác với cửa sổ (di chuyển/tách/điều chỉnh kích thước)"
-- })
-- vim.keymap.set('n', '<leader>sp', function()
--   vim.ui.select({ 
--     'vertical split',
--     'horizontal split',
--     'adjust width',
--     'adjust height'
--   }, {
--     prompt = 'window operation: ',
--     format_item = function(item)
--       local icons = {
--         ['vertical split'] = 'vertical (tách dọc ⇄)',
--         ['horizontal split'] = 'horizontal (tách ngang ⇅)',
--         ['adjust width'] = 'adjust width (điều chỉnh chiều rộng ↔️)',
--         ['adjust height'] = 'adjust height (điều chỉnh chiều cao ↕️)'
--       }
--       return icons[item] or item
--     end
--   }, function(choice)
--     if choice == 'vertical split' then
--       vim.cmd('vsplit')
--     elseif choice == 'horizontal split' then
--       vim.cmd('split')
--     elseif choice == 'adjust width' or choice == 'adjust height' then
--       local is_width = choice == 'adjust width'
--       local prompt = is_width and 'Nhập số cột (Left/Right để điều chỉnh, Enter hoàn tất):' 
--                                or 'Nhập số dòng (Up/Down để điều chỉnh, Enter hoàn tất):'
--       local default_value = is_width and vim.fn.winwidth(0) or vim.fn.winheight(0)
--       
--       vim.ui.input({
--         prompt = prompt,
--         default = tostring(default_value),
--         on_key = function(key, value)
--           local new_value = tonumber(value) or default_value
--           if key == 'Left' and is_width then
--             new_value = new_value - 1
--             vim.cmd('vertical resize ' .. new_value)
--             return tostring(new_value)
--           elseif key == 'Right' and is_width then
--             new_value = new_value + 1
--             vim.cmd('vertical resize ' .. new_value)
--             return tostring(new_value)
--           elseif key == 'Up' and not is_width then
--             new_value = new_value - 1
--             vim.cmd('resize ' .. new_value)
--             return tostring(new_value)
--           elseif key == 'Down' and not is_width then
--             new_value = new_value + 1
--             vim.cmd('resize ' .. new_value)
--             return tostring(new_value)
--           end
--           return nil
--         end
--       }, function(input)
--         if input then
--           local new_size = tonumber(input)
--           if new_size then
--             if is_width then
--               vim.cmd('vertical resize ' .. new_size)
--             else
--               vim.cmd('resize ' .. new_size)
--             end
--           end
--         end
--       end)
--     end
--   end)
-- end, {
--   noremap = true,
--   silent = false,
--   desc = "Thao tác với cửa sổ (tách/điều chỉnh kích thước)"
-- })
vim.keymap.set('n', '<leader>sp', function()
  vim.ui.select({
    'vertical split',
    'horizontal split',
    'adjust width',
    'adjust height'
  }, {
    prompt = 'window operation: ',
    format_item = function(item)
      local icons = {
        ['vertical split'] = 'vertical (⇄)',
        ['horizontal split'] = 'horizontal (⇅)',
        ['adjust width'] = 'adjust width (↔️)',
        ['adjust height'] = 'adjust height (↕️)'
      }
      return icons[item] or item
    end
  }, function(choice)
    if choice == 'vertical split' then
      vim.cmd('vsplit')
    elseif choice == 'horizontal split' then
      vim.cmd('split')
    elseif choice == 'adjust width' or choice == 'adjust height' then
      local is_width = choice == 'adjust width'
      local step = 5
      local size = is_width and vim.fn.winwidth(0) or vim.fn.winheight(0)

      -- thông báo trạng thái
      vim.notify("Resize mode: " .. choice .. " (Enter để thoát)")

      -- tạo keymap tạm thời trong mode normal
      local opts = { noremap = true, silent = true, buffer = 0 }

      local function resize(delta)
        size = size + delta
        if is_width then
          vim.cmd('vertical resize ' .. size)
        else
          vim.cmd('resize ' .. size)
        end
        vim.notify("Size = " .. size, vim.log.levels.INFO, { title = "Window Resize" })
      end

      -- map phím mũi tên
      vim.keymap.set('n', '<Left>', function() resize(-step) end, opts)
      vim.keymap.set('n', '<Right>', function() resize(step) end, opts)
      vim.keymap.set('n', '<Up>', function() if not is_width then resize(-step) end end, opts)
      vim.keymap.set('n', '<Down>', function() if not is_width then resize(step) end end, opts)

      -- map Enter để thoát mode resize
      vim.keymap.set('n', '<CR>', function()
        vim.notify("Final size = " .. size .. " ✅")
        -- xóa keymap tạm
        vim.keymap.del('n', '<Left>', opts)
        vim.keymap.del('n', '<Right>', opts)
        vim.keymap.del('n', '<Up>', opts)
        vim.keymap.del('n', '<Down>', opts)
        vim.keymap.del('n', '<CR>', opts)
      end, opts)
    end
  end)
end, {
  noremap = true,
  silent = false,
  desc = "Thao tác với cửa sổ (tách/điều chỉnh kích thước)"
})


-- tìm kiếm trong các tài liệu trợ giúp của neovim
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
  desc = "Mở trang trợ giúp trong Neovim"
})
vim.keymap.set("n", "<leader>ne", vim.diagnostic.goto_next, {
  desc = "Đi đến lỗi tiếp theo trong file"
})
vim.keymap.set("n", "<leader>pe", vim.diagnostic.goto_prev, {
  desc = "Đi đến lỗi trước đó trong file"
})
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
  desc = "Mở cửa sổ hiển thị chi tiết lỗi tại vị trí con trỏ"
})

-- copy current file path (absolute) into clipboard
vim.keymap.set("n", "<leader>cp", function()
	local filepath = vim.fn.expand("%:p")
	vim.fn.setreg("+", filepath) -- copy to neovim clipboard
	vim.fn.system("echo '" .. filepath .. "' | pbcopy") -- copy to macos clipboard
	print("copied: " .. filepath)
end, {
  desc = "copy absolute path to clipboard"
})

-- open the current file in browser
-- vim.keymap.set("n", "<leader>ob", function()
--   local file_path = vim.fn.expand("%:p") -- get the current file path
--   if file_path ~= "" then
--     local cmd = vim.fn.has("mac") == 1 and "open " .. file_path or "xdg-open " .. file_path
--     os.execute(cmd .. " &")
--   else
--     print("no file to open")
--   end
-- end, {
--   desc = "open current file in browser"
-- })
vim.keymap.set("n", "<leader>ob", function()
  local file_path = vim.fn.expand("%:p")
  if file_path ~= "" then
    vim.fn.jobstart({ "code", file_path }, { detach = true }) 
  else
    print("No file to open")
  end
end, {
  desc = "Open current file in VS Code"
})

-- Setting nvim-visual-multi 
-- vim.keymap.set('n', '<C-M-Up>', vm.add_cursor_up, { desc = "Add cursor up" })
-- vim.keymap.set('n', '<C-M-Down>', vm.add_cursor_down, { desc = "Add cursor down" })
