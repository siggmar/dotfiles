-- ######################################### --
--               CONFIG                      --
-- ######################################### --

vim.g.mapleader = ","

-- general
-- vim.o.clipboard = "unnamedplus"
vim.g.clipboard = {
	name = "wl-clipboard",
	copy = {
		["+"] = "wl-copy",
		["*"] = "wl-copy",
	},
	paste = {
		["+"] = "wl-paste",
		["*"] = "wl-paste",
	},
	cache_enabled = 0,
}

vim.o.cursorline = false
vim.o.termguicolors = true
vim.o.updatetime = 200
vim.o.completeopt = "menuone,noinsert,noselect"

-- display
-- vim.o.guicursor = "i:block"
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "number"
vim.o.colorcolumn = "80"
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.pumheight = 6
vim.o.wrap = false

-- search
vim.o.ignorecase = true
vim.o.smartcase = true

-- tabs / indent
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.autoindent = true

-- backup / undo
vim.o.undofile = true
vim.o.writebackup = true
vim.o.swapfile = false
