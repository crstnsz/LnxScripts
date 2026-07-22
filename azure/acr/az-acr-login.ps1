#!/usr/bin/env pwsh

param (
    [Parameter(Mandatory=$true, HelpMessage="Digite o nome do seu Azure Container Registry (ex: meu_registro)")]
    [string]$RegistryName
)

# Verifica se o Azure CLI está instalado
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Error "O Azure CLI não está instalado. Por favor, instale-o antes de rodar o script."
    exit 1
}

Write-Host "Iniciando processo de login para o ACR: $RegistryName..." -ForegroundColor Cyan

# 1. Tenta fazer o login no Azure (se já estiver logado, ele apenas valida)
Write-Host "Validando autenticação no Azure..." -ForegroundColor Yellow
az login --output none

# 2. Executa o comando de login no ACR específico passado por parâmetro
Write-Host "Conectando ao Docker daemon do ACR..." -ForegroundColor Yellow
az acr login --name $RegistryName

if ($LASTEXITCODE -eq 0) {
    Write-Host "Login efetuado com sucesso no ACR '$RegistryName'!" -ForegroundColor Green
} else {
    Write-Error "Falha ao tentar logar no ACR '$RegistryName'."
    exit 1
}