#!/usr/bin/env powershell

param (
    [Parameter(Mandatory=$true, HelpMessage="Domíminio do Azure (ex: contoso.onmicrosoft.com) ou ID do Tenant (ex: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx) ")]
    [string]$TenantId
)

# Verifica se o Azure CLI está instalado
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Error "O Azure CLI não está instalado. Por favor, instale-o antes de rodar o script."
    exit 1
}

Write-Host "Iniciando processo de autenticação no Azure..." -ForegroundColor Cyan

az acr login -n $TenantId
