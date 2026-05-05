require("config.options")
require("config.plugins")
require("config.keys")
require("config.lsp")

-- ######################################### --
--                SETUP                       --
-- ######################################### --

-- treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "c", "python" },
	sync_install = false,
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			node_decremental = "grm",
		},
	},
	ignore_install = {},
	modules = {},
})

-- mason
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"lua_ls",
		"pylsp",
		"clangd",
		"rust_analyzer",
	},
	handlers = {
		function(server_name)
			vim.lsp.enable(server_name)
		end,
	},
})

-- color highlight
-- require("colorizer").setup() // deprecated vim.tbl_flatten

-- lsp signature
require("lsp_signature").setup({
	bind = true,
	handler_opts = {
		border = "none",
	},
	hint_prefix = "",
	floating_window = false,
})

-- indent-blankline
require("ibl").setup({
	scope = {
		show_start = false,
		show_end = false,
	},
	indent = { char = "│" },

	-- "⁞, ⋮, ┆, ┊, ┋, ┇, │"
})

require("blink.cmp").setup({
	keymap = {
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<CR>"] = {
			function(cmp)
				if cmp.snippet_active() then
					return cmp.accept()
				else
					return cmp.select_and_accept()
				end
			end,
			"snippet_forward",
			"fallback",
		},
	},

	completion = {
		documentation = {
			auto_show = false,
		},
		list = {
			selection = {
				preselect = false,
				auto_insert = false,
			},
		},
	},
})

-- lualine
require("lualine").setup({
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			"filename",
			function()
				return vim.fn["nvim_treesitter#statusline"](180)
			end,
		},
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- formatter
require("conform").setup({
	formatters = {
		prettier = {
			prepend_args = {
				"--tab-width",
				"4",
				"--use-tabs",
				"false",
			},
		},
		["clang-format"] = {
			prepend_args = {
				"-style={"
					.. "BasedOnStyle: LLVM, "
					.. "AlignAfterOpenBracket: BlockIndent, "
					.. "AllowShortCaseLabelsOnASingleLine: true, "
					.. "AllowShortIfStatementsOnASingleLine: WithoutElse, "
					.. "AllowShortLoopsOnASingleLine: true, "
					.. "BreakBeforeBraces: Linux, "
					.. "BinPackArguments: false, "
					.. "BinPackParameters: false, "
					.. "IndentWidth: 4, "
					.. "}",
			},
		},
	},

	-- Map of filetype to formatters
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		css = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },

		["*"] = { "trim_whitespace" },
	},
})

-- movement
require("flash").setup()

-- colorscheme

-- vim.cmd.colorscheme("seoul256")
vim.g.seoul256_background = 234 -- 233 - 239

-- vim.cmd.colorscheme("gruvbox-material")
-- vim.cmd.colorscheme("tokyonight-night")
vim.cmd.colorscheme("mellow")
vim.o.background = "dark"
