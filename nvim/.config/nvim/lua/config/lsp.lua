-- ######################################### --
--               LSP                         --
-- ######################################### --

local function on_attach(client, bufnr)
	local map = vim.keymap.set
	local opts = { noremap = true, silent = true, buffer = bufnr }

	map("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, opts)

	map("n", "<leader>k", function()
		vim.diagnostic.open_float()
	end, opts)

	map("n", "gd", vim.lsp.buf.definition, opts)
	map("n", "gr", vim.lsp.buf.references, opts)
	map("n", "gi", vim.lsp.buf.implementation, opts)
	map("n", "K", vim.lsp.buf.hover, opts)

	-- diagnostics
	vim.diagnostic.config({
		virtual_text = true,
		signs = true,
		update_in_insert = false,
		underline = true,
		severity_sort = false,
		float = {
			border = "rounded",
			source = true,
			header = "",
			prefix = "",
		},
	})

	vim.diagnostic.config({
		virtual_text = {
			prefix = function(diagnostic)
				local symbols = { [vim.diagnostic.severity.ERROR] = ";; error: " }
				return symbols[diagnostic.severity] or ""
			end,
			spacing = 2,
			source = "if_many",
		},
		float = {
			border = "",
			source = true,
			header = "",
			prefix = "",
		},
		signs = true,
		underline = { severity = { min = vim.diagnostic.severity.ERROR } },
		update_in_insert = false,
		severity_sort = true,
	})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--pch-storage=memory",
		"--all-scopes-completion",
		"--pretty",
		"--header-insertion=never",
		"-j=4",
		"--header-insertion-decorators",
		"--function-arg-placeholders",
		"--completion-style=detailed",
		"--cross-file-rename",
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
	cmd = { "lua-language-server" },
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

vim.lsp.config("rust_analyzer", {

	settings = {
		["rust-analyzer"] = {
			inlayHints = {
				typeHints = {
					enable = true,
				},
				parameterHints = {
					enable = true,
				},
				chainingHints = {
					enable = true,
				},
			},
		},
	},
	on_attach = on_attach,
	capabilities = capabilities,
})
