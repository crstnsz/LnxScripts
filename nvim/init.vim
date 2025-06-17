" ==============================================================================
"  INIT.VIM - Configuração Neovim para Programação C#
" ==============================================================================

" --- 1. Opções Gerais (Base) ---
let mapleader = " "
let g:mapleader = " "

syntax enable
set encoding=utf-8 " Certifique-se de que a codificação é UTF-8

set number
set relativenumber
set signcolumn=auto " Adiciona coluna para sinais (diagnósticos, breakpoints)

set tabstop=4
set shiftwidth=4
set expandtab

set ignorecase
set smartcase

set history=1000
set mouse=a

set undofile " Persistir o histórico de undo
set updatetime=300 " Tempo para escrever swapfile e disparar 'CursorHold'

" Permite recarregar arquivos modificados externamente sem pedir
set autoread

" --- 2. Configuração do Lazy.nvim (Gerenciador de Plugins) ---a

let g:lazy_root = stdpath('data') . '/lazy'

if !isdirectory(g:lazy_root)
  echo "Installing lazy.nvim..."
  execute "silent !git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable --depth=1 " . g:lazy_root
  exec "Packadd lazy.nvim"
  au User LazyInstall finished | qall
endif

runtime! lazy.vim

" --- 3. Configuração de Plugins (em Lua) ---
lua << EOF
  require("lazy").setup({
    -- =========================================================================
    --   UI / Qualidade de Vida
    -- =========================================================================
    {
      'ellisonleao/gruvbox.nvim',
      name = 'gruvbox',
      priority = 1000,
      config = function()
        vim.cmd.colorscheme('gruvbox')
        vim.o.background = "dark"
        vim.g.gruvbox_contrast_dark = "hard" -- Ou "medium", "soft"
      end,
    },

    {
      'nvim-tree/nvim-tree.lua',
      dependencies = {
        'nvim-tree/nvim-web-devicons', -- Ícones para arquivos
      },
      config = function()
        require('nvim-tree').setup({
          sort_by = "file",
          view = {
            width = 30,
            relativenumber = true,
          },
          renderer = {
            group_empty = true,
            full_name = true,
            highlight_git = true,
            icons = {
              git_placement = "before",
              padding = " ",
              symlink_arrow = " ➜ ",
              show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
              },
              special_files = { "Makefile", "README.md", "readme.md" },
              webdev_colors = true,
            },
          },
          filters = {
            dotfiles = false,
            exclude = { "node_modules", ".git", ".vs" }, -- Adicione pastas comuns de C# para ignorar
          },
        })
        vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })
      end
    },

    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('lualine').setup({
          options = {
            icons_enabled = true,
            theme = 'auto', -- Ou 'gruvbox'
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
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
          },
        })
      end
    },

    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('telescope').setup({
          defaults = {
            file_sorter = require('telescope.sorters').get_fuzzy_file,
            file_ignore_patterns = { "node_modules", ".git", ".vs", "bin", "obj" }, -- Ignorar mais pastas
          },
        })
        -- Mapeamentos básicos para Telescope
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
        vim.keymap.set('n', '<leader>fb', builtin. buffers, { desc = 'Find buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
        vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Workspace Diagnostics' })
      end
    },

    {
      'feline-nvim/feline.nvim', -- Substituição para lualine, se quiser algo mais performático/configurável
      -- ... (se usar, remova lualine.nvim)
    },

    -- Coloração de parênteses e sintaxe aprimorada
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', config = function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = { "csharp", "lua", "vim", "vimdoc", "markdown", "json", "yaml" }, -- Instalar parsers para C# e outros
          sync_install = false,
          auto_install = true,
          highlight = {
            enable = true,
          },
          indent = { enable = true, },
        }
      end
    },
    { 'JoosepAlviste/nvim-ts-context-commentstring' }, -- Para comentários inteligentes

    -- Git Integration
    { 'tpope/vim-fugitive' }, -- Excelente integração Git
    { 'airblade/vim-gitgutter' }, -- Mostra mudanças Git na signcolumn

    -- =========================================================================
    --   LSP, Autocompletar e Depuração
    -- =========================================================================

    -- LSP Config (para Language Servers)
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        'williamboman/mason.nvim',      -- Gerenciador de servidores de linguagem
        'williamboman/mason-lspconfig.nvim', -- Integração Mason com lspconfig
        'hrsh7th/nvim-cmp',             -- Plugin de autocompletar
        'hrsh7th/cmp-nvim-lsp',         -- Fonte de autocompletar para LSP
        'saadparwaiz1/cmp_luasnip',     -- Fonte de autocompletar para Snippets
        'L3MON4D3/LuaSnip',             -- Engine de Snippets
        'j-hui/fidget.nvim',            -- Notificações visuais do LSP
      },
      config = function()
        require('mason').setup()
        require('mason-lspconfig').setup({
          ensure_installed = { "omnisharp", "jsonls", "yamlls", "lua_ls" }, -- Instala OmniSharp e outros LSPs
          -- Ou se preferir csharp_ls:
          -- ensure_installed = { "csharp_ls", "jsonls", "yamlls", "lua_ls" },
        })

        local lspconfig = require('lspconfig')
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        -- Configuração de Autocompletar (nvim-cmp)
        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirma seleção com Enter
          }),
          sources = cmp.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
            { name = 'buffer' },
          })
        })

        -- Configuração do OmniSharp (para C#)
        lspconfig.omnisharp.setup({
            cmd = { "dotnet", os.getenv("HOME") .. "/.local/share/omnisharp/omnisharp.net.6.0/OmniSharp.dll" }, -- <--- AJUSTE ESTE CAMINHO PARA O SEU OMNISHARP
            -- Ou no Windows: { "dotnet", os.getenv("UserProfile") .. "\\AppData\\Local\\omnisharp\\omnisharp.net.6.0\\OmniSharp.dll" },
            -- Se você preferir csharp_ls, use:
            -- cmd = { "csharp_ls" },
            enable_symlinks = true,
            organize_imports_on_format = true,
            disable_formatting = false,
            handlers = {
              -- Alguma configuração extra para OmniSharp (opcional)
            },
            capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
            settings = {
                Formatting = {
                    Enable = true,
                    -- Outras opções de formatação aqui, se precisar
                },
                DotNet = {
                    Test = {
                        DiscoverTestsWhenProjectLoading = true,
                        RunTestsWhenTestFileChanges = false,
                    }
                }
            },
            -- Evento para carregar o LSP apenas para arquivos C#
            filetypes = { 'cs', 'vb' },
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
        vim.keymap.set('n', '<leader>wf', vim.lsp.buf.format, { desc = 'Format Document' }) -- Formatação com LSP
      end
    },

    -- Depuração (DAP - Debug Adapter Protocol)
    {
      'mfussenegger/nvim-dap',
      dependencies = {
        'rcarriga/nvim-dap-ui', -- Interface de usuário para o DAP
      },
      config = function()
        local dap = require('dap')
        local dapui = require('dapui')

        dapui.setup()

        -- Configuração para o depurador .NET (netcoredbg)
        dap.adapters.coreclr = {
          type = 'executable',
          command = '/usr/bin/netcoredbg', -- <--- AJUSTE ESTE CAMINHO PARA SEU NETCOREDBG
          -- Ou no Windows: 'C:\\path\\to\\netcoredbg.exe',
          args = { '--interpreter=vscode' }
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
          {
            type = 'coreclr',
            name = 'attach - netcoredbg',
            request = 'attach',
            processId = function()
              return vim.fn.input('Process ID to attach to: ', '', 'num')
            end,
          },
        }

        -- Mapeamentos de teclas para DAP
        vim.keymap.set('n', '<F5>', dap.continue, { desc = 'DAP: Continue' })
        vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'DAP: Step Over' })
        vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'DAP: Step Into' })
        vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'DAP: Step Out' })
        vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'DAP: Toggle Breakpoint' })
        vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = 'DAP: Set Conditional Breakpoint' })
        vim.keymap.set('n', '<leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = 'DAP: Set Log Point' })
        vim.keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = 'DAP: Toggle REPL' })
        vim.keymap.set('n', '<leader>dq', dap.disconnect, { desc = 'DAP: Disconnect' })
        vim.keymap.set('n', '<leader>dc', dap.run_to_cursor, { desc = 'DAP: Run to Cursor' })

        -- UI do DAP
        vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'DAP UI: Toggle' })
        vim.keymap.set('n', '<leader>dO', dapui.open, { desc = 'DAP UI: Open' })
        vim.keymap.set('n', '<leader>dC', dapui.close, { desc = 'DAP UI: Close' })
        vim.keymap.set('n', '<leader>de', dapui.eval, { desc = 'DAP UI: Evaluate' })
        vim.keymap.set('n', '<leader>ds', dapui.sidebar_toggle, { desc = 'DAP UI: Sidebar Toggle' })
      end
    },

    -- =========================================================================
    --   Outras Utilidades (Testes, Snippets)
    -- =========================================================================

    -- Snippets (se não for usar cmp_luasnip)
    { 'rafamadriz/friendly-snippets' }, -- Coleção de snippets

    -- Test Runner (Exemplo para .NET)
    {
      'nvim-neotest/neotest',
      dependencies = {
        'nvim-neotest/neotest-dotnet', -- Adaptador para .NET
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim', -- Necessário para neotest
      },
      config = function()
        require('neotest').setup({
          adapters = {
            require('neotest-dotnet')({
              -- Path to dotnet CLI if not in PATH
              -- dotnet_cmd = '/usr/local/bin/dotnet',
              -- Additional arguments to dotnet test
              args = { '--verbosity', 'normal' }
            }),eotest
          floating_panel = {
            enabled = true,
            height = 0.5,
            width = 0.5,
            border = 'solid',
          },
        })
        vim.keymap.set('n', '<leader>tt', function() require('neotest').run.run_current_file() end, { desc = 'Run current file tests' })
        vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.toggle() end, { desc = 'Toggle test summary' })
        vim.keymap.set('n', '<leader>to', function() require('neotest').output_panel.toggle() end, { desc = 'Toggle test output' })
      end
    },

    -- Para gerenciar múltiplos projetos .NET ou soluções
    {
      'folke/which-key.nvim', -- Ajuda a descobrir mapeamentos de teclas
      config = function()
        require('which-key').setup({})
      end
    },

  })
EOF
