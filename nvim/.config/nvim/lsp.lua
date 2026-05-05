-- ######################################### --
--               LSP                         --
-- ######################################### --

local function on_attach(client, bufnr)
	local _map = vim.keymap.set
	local _opts = { noremap = true, silent = true, buffer = bufnr }

	_map("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, _opts)

	_map("n", "<leader>k", function()
		vim.diagnostic.open_float()
	end, _opts)

	_map("n", "gd", vim.lsp.buf.definition, _opts)
	_map("n", "gr", vim.lsp.buf.references, _opts)
	_map("n", "gi", vim.lsp.buf.implementation, _opts)
	_map("n", "K", vim.lsp.buf.hover, _opts)
	-- diagnostics
	vim.diagnostic.config({
		virtual_text = true,
		signs = true,
		update_in_insert = false,
		underline = true,
		severity_sort = false,
		float = {
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})

	-- vim.diagnostic.config({
	-- 	virtual_text = {
	-- 		prefix = function(diagnostic)
	-- 			local symbols = { [vim.diagnostic.severity.ERROR] = ";; error: " }
	-- 			return symbols[diagnostic.severity] or ""
	-- 		end,
	-- 		spacing = 2,
	-- 		source = "if_many",
	-- 	},
	-- 	float = {
	-- 		border = "",
	-- 		source = true,
	-- 		header = "",
	-- 		prefix = "",
	-- 	},
	-- 	signs = true,
	-- 	underline = { severity = { min = vim.diagnostic.severity.ERROR } },
	-- 	update_in_insert = false,
	-- 	severity_sort = true,
	-- })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

local server = vim.fn.stdpath("data") .. "/mason/bin/"

vim.lsp.config("clangd", {
	cmd = {
		server .. "clangd",
		"--background-index",
		"--pch-storage=memory",
		"--all-scopes-completion",
		"--pretty",
		"--header-insertion=never",
		"-j=4",
		"--header-insertion-decorators",
		"--function-arg-placeholders",
		"--completion-style=detailed",
	},
	filetypes = { "c", "cpp", "h", "objc", "objcpp", "cuda" },
	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"configure.ac", -- AutoTools
		".git",
	},
	on_attach = on_attach,
	capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
	cmd = { server .. "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("pylsp", {
	cmd = { server .. "pylsp" },
	filetypes = { "py", "python" },
	settings = {
		python = {
			pythonPath = vim.fn.exepath("python3"),
		},
	},
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("bashls", {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash" },

	on_attach = on_attach,

	capabilities = capabilities,

	root_dir = function(bufnr, on_dir)
		local cwd = vim.fn.getcwd()
		on_dir(cwd)
	end,
})

vim.lsp.config("rust_analyzer", {
	cmd = { server .. "rust-analyzer" },
	filetypes = { "rust" },

	on_attach = on_attach,

	capabilities = capabilities,
})
