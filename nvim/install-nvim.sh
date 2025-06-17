#!/bin/bash

set -e

echo "Atualizando repositórios e instalando dependências básicas..."
sudo apt update
sudo apt install -y git curl build-essential cmake ninja-build gettext unzip python3-pip

echo "Instalando Node.js (necessário para alguns plugins do Neovim)..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

echo "Instalando pynvim para suporte Python no Neovim..."
pip3 install --user pynvim

echo "Clonando repositório do Neovim para compilação da versão mais recente..."
git clone https://github.com/neovim/neovim.git ~/neovim
cd ~/neovim
git checkout stable  # ou uma versão específica, ex: v0.9.5

echo "Compilando e instalando o Neovim..."
make CMAKE_BUILD_TYPE=Release
sudo make install

echo "Removendo diretório temporário do Neovim..."
cd ~
rm -rf ~/neovim

echo "Instalando OmniSharp para suporte C# LSP..."
# Dependência do OmniSharp: mono-runtime
sudo apt install -y mono-runtime
# Baixar e instalar OmniSharp (versão estável mais recente)
OMNISHARP_VERSION="latest"
OMNISHARP_URL=$(curl -s https://api.github.com/repos/OmniSharp/omnisharp-roslyn/releases/latest | grep browser_download_url | grep linux-x64.tar.gz | cut -d '"' -f 4)
mkdir -p ~/.omnisharp
curl -L $OMNISHARP_URL -o ~/.omnisharp/omnisharp.tar.gz
tar -xzf ~/.omnisharp/omnisharp.tar.gz -C ~/.omnisharp
rm ~/.omnisharp/omnisharp.tar.gz

echo "Configurando Neovim para C# com vim-plug e LSP..."

# Instalar vim-plug para Neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Criar diretório de configuração do Neovim
mkdir -p ~/.config/nvim

# Criar arquivo init.vim com configuração básica para C#
cat > ~/.config/nvim/init.vim << 'EOF'
call plug#begin('~/.local/share/nvim/plugged')

" Plugin para LSP e autocompletar
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

call plug#end()

" Configuração do LSP para C# usando OmniSharp
lua << EOF
local nvim_lsp = require('lspconfig')
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  })
})

nvim_lsp.omnisharp.setup{
  cmd = { os.getenv("HOME") .. "/.omnisharp/omnisharp/OmniSharp" },
  on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr

