
$ErrorActionPreference = "Stop"

Write-Host "=> Iniciando a configuração do Helix no Windows..." -ForegroundColor Cyan

# 1. Instalar o Helix via Winget (Padrão no Windows 10/11)
if (Get-Command hx -ErrorAction SilentlyContinue) {
    Write-Host "=> Helix já está instalado. Pulando instalação." -ForegroundColor Green
} else {
    Write-Host "=> Instalando Helix via Winget..." -ForegroundColor Yellow
    winget install Helix.Helix
}

# 2. Instalar o csharp-ls
if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
    Write-Host "ERRO: O .NET SDK não foi encontrado no sistema. Instale-o antes de prosseguir." -ForegroundColor Red
    exit 1
}

Write-Host "=> Instalando csharp-ls globalmente..." -ForegroundColor Yellow
try {
    dotnet tool install --global csharp-ls
} catch {
    Write-Host "=> csharp-ls já pode estar instalado." -ForegroundColor Gray
}

# 3. Criar diretório de configuração do Helix no Windows (%AppData%\helix)
$ConfigDir = Join-Path $env:APPDATA "helix"
if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir | Out-Null
}

# 4. Configurar Tema e Comportamento Base
Write-Host "=> Configurando config.toml (Tema jetbrains_dark)..." -ForegroundColor Yellow
$ConfigContent = @"
theme = "jetbrains_dark"

[editor]
line-number = "relative"
mouse = false
"@
Set-Content -Path (Join-Path $ConfigDir "config.toml") -Value $ConfigContent -Encoding UTF8

# 5. Configurar LSP do C#
Write-Host "=> Configurando languages.toml (csharp-ls)..." -ForegroundColor Yellow
$LanguagesContent = @"
[[language]]
name = "csharp"
language-servers = ["csharp-ls"]
"@
Set-Content -Path (Join-Path $ConfigDir "languages.toml") -Value $LanguagesContent -Encoding UTF8

Write-Host "==================================================" -ForegroundColor Green
Write-Host "✅ Instalação e configuração concluídas com sucesso!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
