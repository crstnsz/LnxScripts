" =============================
" === CONFIGURAÇÃO GERAL ====
" =============================

" Usar UTF-8
set encoding=utf-8
set fileencoding=utf-8

" Aparência
syntax on
set number
set relativenumber
set cursorline
set termguicolors

" Indentação
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

" Busca
set ignorecase
set smartcase
set incsearch
set hlsearch

" Desabilitar swap/backup
set noswapfile
set nobackup
set nowritebackup

" Performance
set updatetime=300

" Mapleader
let mapleader=" "

" =============================
" === GERENCIADOR DE PLUGINS ==
" =============================

" Instalar Lazy.nvim (recomendado)
lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  -- Temas
  { "catppuccin/nvim", name = "catppuccin" },

  -- File Explorer
  "nvim-tree/nvim-tree.lua",

  -- Statusline
  "nvim-lualine/lualine.nvim",

  -- Fuzzy Finder
  "nvim-telescope/telescope.nvim",
  "nvim-lua/plenary.nvim",

  -- Syntax Highlight e Code Parsing
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Autocomplete
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- LSP
  "neovim/nvim-lspconfig",

  -- Debug Adapter Protocol
  "mfussenegger/nvim-dap",

  -- Linter e Formatter
  "jose-elias-alvarez/null-ls.nvim",

  -- Git
  "lewis6991/gitsigns.nvim",
})
EOF

" =============================
" === TEMA ===================
" =============================
colorscheme catppuccin

" =============================
" === STATUSLINE =============
" =============================
lua << EOF
require('lualine').setup {
  options = { theme = 'catppuccin' }
}
EOF

" =============================
" === FILE EXPLORER ==========
" =============================
lua << EOF
require('nvim-tree').setup {}
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
EOF

" =============================
" === TELESCOPE ==============
" =============================
lua << EOF
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)
vim.keymap.set('n', '<leader>fb', builtin.buffers)
vim.keymap.set('n', '<leader>fh', builtin.help_tags)
EOF

" =============================
" === TREESITTER =============
" =============================
lua << EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c_sharp", "lua", "json", "yaml", "markdown" },
  highlight = { enable = true },
  indent = { enable = true }
}
EOF

" =============================
" === AUTOCOMPLETE ===========
" =============================
lua << EOF
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }
  }, {
    { name = 'buffer' },
    { name = 'path' }
  })
})
EOF

" =============================
" === LSP C# ==================
" =============================
lua << EOF
local lspconfig = require('lspconfig')

-- Configuração do OmniSharp
lspconfig.omnisharp.setup {
    cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
}

-- Keybinds padrão LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
EOF

" =============================
" === NULL-LS (FORMAT/LINT) ===
" =============================
lua << EOF
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.csharpier,
    },
})
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
EOF

" =============================
" === DAP (DEBUG) =============
" =============================
lua << EOF
local dap = require('dap')

dap.adapters.coreclr = {
  type = 'executable',
  command = '/path/to/netcoredbg', -- 👉 Substituir pelo caminho do seu netcoredbg
  args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
  {
    type = 'coreclr',
    name = 'Launch - NetCoreDbg',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}
EOF

" =============================
" === GITSIGNS ================
" =============================
lua << EOF
require('gitsigns').setup()
EOF


