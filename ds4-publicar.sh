#!/bin/bash

# --- CONFIGURAÇÕES DO AZURE DEVOPS ---
PIPELINE_NAME="Publicar"
ORG_URL="https://dev.azure.com/docspider"
PROJECT_NAME="docspider4"
DEFAULT_BRANCH="main" # Branch padrão caso não encontre nenhuma
# -------------------------------------

echo "🚀 Iniciando processo de disparo do Azure Pipeline..."

# 1. Tenta pegar a branch atual do Git (funciona com Oh My Zsh ou qualquer terminal)
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)

if [ -n "$CURRENT_BRANCH" ]; then
    echo "📌 Branch atual detectada: '$CURRENT_BRANCH'"
    # Pergunta se deseja usar a detectada ou digitar outra
    read -p "Deseja usar esta branch? (S/n): " response
    response=${response,,} # Transforma em minúsculo
    
    if [[ "$response" =~ ^(no|n)$ ]]; then
        read -p "Digite o nome da branch que deseja usar: " TARGET_BRANCH
    else
        TARGET_BRANCH=$CURRENT_BRANCH
    fi
else
    # Caso não esteja em um repositório git ou não detecte a branch
    echo "⚠️ Não foi possível detectar uma branch Git automaticamente."
    read -p "Digite o nome da branch (Pressione Enter para usar '$DEFAULT_BRANCH'): " TARGET_BRANCH
    TARGET_BRANCH=${TARGET_BRANCH:-$DEFAULT_BRANCH}
fi

# Validação rápida para garantir que a variável não está vazia
if [ -z "$TARGET_BRANCH" ]; then
    echo "❌ Erro: Nenhuma branch foi selecionada. Abortando."
    exit 1
fi

echo "🔄 Disparando pipeline '$PIPELINE_NAME' na branch '$TARGET_BRANCH'..."

# 2. Executa o comando da Azure CLI
az pipelines run \
    --name "$PIPELINE_NAME" \
    --organization "$ORG_URL" \
    --project "$PROJECT_NAME" \
    --branch "$TARGET_BRANCH" \
    --open

if [ $? -eq 0 ]; then
    echo "✅ Pipeline disparado com sucesso! Acompanhe a execução no navegador."
else
    echo "❌ Falha ao disparar o pipeline. Verifique se você está logado via 'az login'."
fi