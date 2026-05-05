-- ######################################### --
--                KEYMAPS                    --
-- ######################################### --

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = ","

-- window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

map("n", "<leader>f", function()
	require("conform").format({
		async = true,
		lsp_format = "never",
	})
end)

-- format on save
-- vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
--     callback = function()
--         vim.lsp.buf.format({ async = true })
--     end
-- })

map({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, opts)

map({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, opts)

map("o", "r", function()
	require("flash").remote()
end, opts)

map({ "o", "x" }, "R", function()
	require("flash").treesitter_search()
end, opts)

map("c", "<c-s>", function()
	require("flash").toggle()
end, opts)
