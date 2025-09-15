-- ==============================================================================
--  INIT.LUA - Configuração Neovim para Programação C#
-- ==============================================================================
local lazy_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazy_path,
  })
end
vim.opt.rtp:prepend(lazy_path)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- --- 1. Opções Gerais (Base) ---
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'auto'
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.history = 1000
vim.opt.mouse = 'a'
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.autoread = true

-- --- 2. Configuração de Plugins (com Lazy.nvim) ---
require('lazy').setup({
  -- =========================================================================
  --    UI / Qualidade de Vida
  -- =========================================================================
  {
    'ellisonleao/gruvbox.nvim',
    name = 'gruvbox',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('gruvbox')
      vim.o.background = 'dark'
      vim.g.gruvbox_contrast_dark = 'hard'
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        sort_by = 'file',
        view = { width = 30, relativenumber = true },
        renderer = {
          group_empty = true,
          full_name = true,
          highlight_git = true,
          icons = {
            git_placement = 'before',
            padding = ' ',
            symlink_arrow = ' ➜ ',
            show = { file = true, folder = true, folder_arrow = true, git = true },
            special_files = { 'Makefile', 'README.md', 'readme.md' },
            webdev_colors = true,
          },
        },
        filters = {
          dotfiles = false,
          exclude = { 'node_modules', '.git', '.vs' },
        },
      })
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'gruvbox',
          component_separators = { '', '' },
          section_separators = { '', '' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
      })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          file_sorter = require('telescope.sorters').get_fuzzy_file,
          file_ignore_patterns = { "node_modules", ".git", ".vs", "bin", "obj" },
        },
      })
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Workspace Diagnostics' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'csharp', 'lua', 'vim', 'vimdoc', 'markdown', 'json', 'yaml' },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },
  { 'JoosepAlviste/nvim-ts-context-commentstring' },
  { 'tpope/vim-fugitive' },
  { 'airblade/vim-gitgutter' },

  -- =========================================================================
  --    LSP, Autocompletar e Depuração
  -- =========================================================================
  { 'williamboman/mason.nvim', config = function() require('mason').setup() end },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'L3MON4D3/LuaSnip' },
  { 'j-hui/fidget.nvim', opts = {} },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'j-hui/fidget.nvim',
    },
    config = function()
      -- LSP Servers instalados pelo Mason
      local servers = {
        omnisharp = {},
        jsonls = {},
        yamlls = {},
        lua_ls = {},
      }

      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      local lspconfig = require('lspconfig')
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      -- Configuração de Autocompletar (nvim-cmp)
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
        }),
      })

      -- Configuração do OmniSharp com Mason
      require('mason-lspconfig').setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          -- Essa função automatiza o setup para todos os servers definidos acima
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
              settings = servers[server_name],
            })
          end,
          -- Configuração específica para OmniSharp (se precisar)
          omnisharp = function()
            lspconfig.omnisharp.setup({
              capabilities = capabilities,
              settings = {
                Formatting = {
                  Enable = true,
                },
              },
              filetypes = { 'cs', 'vb' },
            })
          end,
        },
      })

      -- Mapeamentos de teclas comuns para LSP
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to Definition' })
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to Declaration' })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to References' })
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to Implementation' })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous Diagnostic' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
      vim.keymap.set('n', '<leader>dl', vim.diagnostic.open_float, { desc = 'Show Line Diagnostics' })
      vim.keymap.set('n', '<leader>df', vim.diagnostic.set_loclist, { desc = 'Show All Diagnostics' })
      vim.keymap.set('n', '<leader>ws', lspconfig.util.textDocument_references, { desc = 'Workspace Symbols' })
      vim.keymap.set('n', '<leader>wf', vim.lsp.buf.format, { desc = 'Format Document' })
    end,
  },

  -- =========================================================================
  --    Depuração (DAP - Debug Adapter Protocol)
  -- =========================================================================
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      dapui.setup()
      dap.adapters.coreclr = {
        type = 'executable',
        command = 'netcoredbg',
        args = { '--interpreter=vscode' },
      }
      dap.configurations.cs = {
        {
          type = 'coreclr',
          name = 'launch - netcoredbg',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to .dll or .exe: ', vim.fn.getcwd() .. '/bin/Debug/net8.0/YourApp.dll', 'file')
          end,
          args = {},
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          stopOnEntry = true,
        },
      }
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'DAP: Continue' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'DAP: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'DAP UI: Toggle' })
    end,
  },
  
  -- =========================================================================
  --    Outras Utilidades (Testes, Snippets)
  -- =========================================================================
  { 'rafamadriz/friendly-snippets' },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/neotest-dotnet',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-dotnet')({
            args = { '--verbosity', 'normal' }
          }),
        },
      })
      vim.keymap.set('n', '<leader>tt', function() require('neotest').run.run_current_file() end, { desc = 'Run current file tests' })
    end,
  },
  {
    'folke/which-key.nvim',
    config = function() require('which-key').setup({}) end
  },
})