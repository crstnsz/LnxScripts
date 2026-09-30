#!/bin/bash

# Aborta o script em caso de erro
set -e

echo -e "\033[1;36m=> Iniciando a configuração do Helix no Linux...\033[0m"

# 1. Instalar o Helix
if command -v hx &> /dev/null; then
    echo -e "\033[1;32m=> Helix já está instalado. Pulando instalação.\033[0m"
else
    echo -e "\033[1;33m=> Instalando Helix...\033[0m"
    if command -v apt &> /dev/null; then
        sudo add-apt-repository ppa:maveonair/helix-editor -y
        sudo apt update
        sudo apt install helix -y
    elif command -v pacman &> /dev/null; then
        sudo pacman -S helix --noconfirm
    elif command -v dnf &> /dev/null; then
        sudo dnf copr enable varlad/helix -y
        sudo dnf install helix -y
    else
        echo "Gerenciador de pacotes não reconhecido (APT, Pacman, DNF não encontrados)."
        echo "Por favor, instale o Helix manualmente."
        exit 1
    fi
fi

# 2. Instalar o csharp-ls
if ! command -v dotnet &> /dev/null; then
    echo -e "\033[1;31mERRO: O .NET SDK não foi encontrado no sistema.\033[0m"
    echo "Instale o .NET SDK antes de prosseguir."
    exit 1
fi

echo -e "\033[1;33m=> Instalando csharp-ls globalmente...\033[0m"
dotnet tool install --global csharp-ls || echo "=> csharp-ls já pode estar instalado."

# 3. Criar diretório de configuração do Helix no Linux (~/.config/helix)
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/helix"
mkdir -p "$CONFIG_DIR"

# 4. Configurar Tema e Comportamento Base
echo -e "\033[1;33m=> Configurando config.toml (Tema jetbrains_dark)...\033[0m"
cat <<EOF > "$CONFIG_DIR/config.toml"
theme = "jetbrains_dark"

[editor]
line-number = "relative"
mouse = false
EOF

# 5. Configurar LSP do C#
echo -e "\033[1;33m=> Configurando languages.toml (csharp-ls)...\033[0m"
cat <<EOF > "$CONFIG_DIR/languages.toml"
[[language]]
name = "csharp"
language-servers = ["csharp-ls"]
EOF

echo -e "\033[1;32m==================================================\033[0m"
echo -e "\033[1;32m✅ Instalação e configuração concluídas com sucesso!\033[0m"
echo -e "\033[1;32m==================================================\033[0m"
echo "⚠️ ATENÇÃO (Linux): Se o Helix não reconhecer o 'csharp-ls',"
echo "adicione a seguinte linha ao final do seu ~/.bashrc ou ~/.zshrc:"
echo 'export PATH="$PATH:$HOME/.dotnet/tools"'
