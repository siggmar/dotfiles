-- ######################################### --
--               CONFIG                      --
-- ######################################### --

vim.g.mapleader = ","

-- general
vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true
vim.o.termguicolors = true
vim.o.updatetime = 200
vim.o.completeopt = "menuone,noinsert,noselect"

-- display
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes:1"
vim.o.colorcolumn = "80"
vim.o.scrolloff = 8
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

-- ######################################### --
--                KEYMAPS                    --
-- ######################################### --

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- format on save
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    callback = function()
        vim.lsp.buf.format({ async = true })
    end
})


-- ######################################### --
--                PLUGINS                    --
-- ######################################### --

vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/tpope/vim-dispatch",
    "https://github.com/cohama/lexima.vim",        -- auto klammern
    "https://github.com/ray-x/lsp_signature.nvim", -- function args
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/saghen/blink.cmp",
    "https://github.com/kyazdani42/nvim-web-devicons",
    "https://github.com/nvim-lualine/lualine.nvim",

    -- colorschemes
    "https://github.com/junegunn/seoul256.vim",
    "https://github.com/sainnhe/gruvbox-material",
    "https://github.com/morhetz/gruvbox",
})

-- ######################################### --
--                SETUP                       --
-- ######################################### --

-- treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "c", "python" },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
    ignore_install = {},
})

-- mason
require("mason").setup()

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
})

require("blink.cmp").setup({
    keymap = {
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = {
            function(cmp)
                if cmp.snippet_active() then
                    return cmp.accept()
                else
                    return cmp.select_and_accept()
                end
            end,
            'snippet_forward',
            'fallback',
        },
    },
    completion = {
        list = {
            selection = {
                preselect = true,
                auto_insert = false,
            }
        }
    }
})

-- lualine
require('lualine').setup {
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
            'filename',
            function()
                return vim.fn['nvim_treesitter#statusline'](180)
            end },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
}

-- colorscheme

-- vim.cmd.colorscheme("seoul256")
-- vim.g.seoul256_background = 237 -- 233 - 239

vim.cmd.colorscheme("gruvbox-material")
vim.o.background = "dark"

-- ######################################### --
--               LSP                         --
-- ######################################### --

local server = vim.fn.stdpath("data") .. "/mason/bin/"

local function on_attach(client, bufnr)
    local _opts = { noremap = true, silent = true, buffer = bufnr }

    map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, _opts)
    map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, _opts)
    map("n", "gd", function() vim.lsp.buf.definition() end, _opts)

    -- diagnostics
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

require("blink.cmp").setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
}

vim.lsp.config("clangd", {
    cmd = { server .. "clangd",
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
    filetypes = { 'c', 'cpp', 'h', 'objc', 'objcpp', 'cuda' },
    root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac', -- AutoTools
        '.git'
    },
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.enable("clangd")

vim.lsp.config("lua_ls", {
    cmd = { server .. "lua-language-server" },
    filetypes = { 'lua' },
    root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
        '.luacheckrc',
        '.stylua.toml',
        'stylua.toml',
        'selene.toml',
        'selene.yml',
        '.git'
    },
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            }
        }
    },
    capabilities = capabilities,
    on_attach = on_attach
})

vim.lsp.enable("lua_ls")
