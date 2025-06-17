#!/bin/bash

# Script para configurar Neovim para C# com Omnisharp e plugins essenciais
# Suporta Linux (testado em Arch/Ubuntu) - adapte caminhos se necessário

set -e

echo "Iniciando configuração do Neovim para C#..."

# 1. Instalar dependências básicas
echo "Instalando dependências básicas..."
if command -v apt >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y curl git neovim dotnet-sdk-7.0 unzip
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -Sy --noconfirm curl git neovim dotnet-sdk unzip
else
  echo "Gerenciador de pacotes não suportado. Instale manualmente: curl, git, neovim, dotnet-sdk, unzip"
fi

# 2. Instalar packer.nvim (gerenciador de plugins para Neovim)
echo "Instalando packer.nvim..."
PACKER_PATH="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_PATH" ]; then
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_PATH"
fi

# 3. Baixar e configurar Omnisharp Language Server
echo "Instalando Omnisharp Language Server..."
OMNISHARP_VERSION="1.39.8"
OMNISHARP_DIR="${HOME}/.local/share/omnisharp"
OMNISHARP_BIN="${OMNISHARP_DIR}/omnisharp-roslyn-${OMNISHARP_VERSION}/OmniSharp"

if [ ! -f "$OMNISHARP_BIN" ]; then
  mkdir -p "$OMNISHARP_DIR"
  cd "$OMNISHARP_DIR"
  echo "Baixando Omnisharp..."
  curl -LO "https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${OMNISHARP_VERSION}/omnisharp-linux-x64-net7.0.zip"
  unzip "omnisharp-linux-x64-net7.0.zip"
  rm "omnisharp-linux-x64-net7.0.zip"
fi

# 4. Criar configuração Lua para Neovim (init.lua)
NVIM_CONFIG_DIR="${HOME}/.config/nvim"
mkdir -p "$NVIM_CONFIG_DIR"

echo "Criando configuração init.lua para Neovim..."

cat > "${NVIM_CONFIG_DIR}/init.lua" <<EOF
-- Configuração mínima para C# com Omnisharp no Neovim usando packer.nvim

-- Bootstrapping packer.nvim
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- gerenciador de plugins
  use 'neovim/nvim-lspconfig' -- configurações LSP
  use 'hrsh7th/nvim-cmp' -- autocomplete
  use 'hrsh7th/cmp-nvim-lsp' -- fonte LSP para nvim-cmp
  use 'L3MON4D3/LuaSnip' -- snippets
  use 'saadparwaiz1/cmp_luasnip' -- integração snippets + autocomplete
  use 'nvim-lua/plenary.nvim' -- utilitários Lua
  use 'nvim-telescope/telescope.nvim' -- fuzzy finder
end)

-- Configuração de autocomplete
vim.o.completeopt = "menu,menuone,noselect"

local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- Configuração do LSP Omnisharp
local lspconfig = require('lspconfig')

local pid = vim.fn.getpid()
local omnisharp_bin = "${OMNISHARP_BIN}"

lspconfig.omnisharp.setup {
  cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
  on_attach = function(client, bufnr)
    -- Configurações ao anexar o LSP
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  end,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}
EOF

echo "Configuração do Neovim criada em ${NVIM_CONFIG_DIR}/init.lua"

# 5. Instruções finais
echo "Configuração concluída!"
echo "Para usar, abra o Neovim e execute :PackerSync para instalar os plugins."
echo "Certifique-se de abrir um projeto C# com arquivos .csproj para que Omnisharp funcione corretamente."
echo "Exemplo: cd ~/meu-projeto-csharp && nvim ."

exit 0

