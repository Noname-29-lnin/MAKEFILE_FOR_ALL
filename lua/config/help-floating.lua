vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	callback = function()
        local crbuf = vim.api.nvim_get_current_buf()
        vim.cmd("wincmd c")
		-- vim.cmd("wincmd L")
		vim.api.nvim_open_win(crbuf, true, {
			relative = "editor",
			width = math.floor(vim.o.columns * 0.8),
			height = math.floor(vim.o.lines * 0.8),
			col = math.floor(vim.o.columns * 0.1),
			row = math.floor(vim.o.lines * 0.1),
			border = "rounded",
		})
	end,
})
vim.api.nvim_create_user_command("ShowTree", function(opts)
	local path = opts.args ~= "" and opts.args or vim.fn.getcwd()
	if vim.fn.executable("tree") == 0 then
		vim.notify("Error: 'tree' command not found. Install it first.", vim.log.levels.ERROR)
		return
	end

	local buf = vim.api.nvim_create_buf(false, true)
	local editor_width = vim.o.columns
	local editor_height = vim.o.lines
	local width = math.floor(editor_width * 0.6)
	local height = math.floor(editor_height * 0.9)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((editor_height - height) / 2),
		col = math.floor((editor_width - width) / 2),
		border = "rounded",
		style = "minimal",
	})

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Loading tree..." })
	local job_id = vim.fn.jobstart("tree -L 4 " .. vim.fn.shellescape(path), {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data then
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
			end
		end,
		on_exit = function()
			vim.api.nvim_buf_set_option(buf, "filetype", "tree")
		end,
	})
end, { nargs = "?", complete = "dir" })

vim.keymap.set("n", "<leader>vt", ":ShowTree<CR>", { desc = "Show directory tree in floating window" })
