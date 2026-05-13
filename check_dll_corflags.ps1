#!/usr/bin/env powershell

param(
    [Parameter(Mandatory=$false)]
    [string]$FolderPath
)

function Get-DllArchitecture {
    param(
        [string]$DllPath
    )
    
    try {
        $assemblyName = [System.Reflection.AssemblyName]::GetAssemblyName($DllPath)
        $architecture = $assemblyName.ProcessorArchitecture
        
        switch ($architecture) {
            "MSIL" { return "AnyCPU" }
            "X86" { return "x86 (32-bit)" }
            "Amd64" { return "x64 (64-bit)" }
            "IA64" { return "IA64 (64-bit)" }
            "Arm" { return "ARM" }
            default { return "Desconhecido" }
        }
    }
    catch [System.BadImageFormatException] {
        return "Não é uma DLL .NET válida"
    }
    catch {
        return "Erro: $($_.Exception.Message)"
    }
}

# Solicita o caminho da pasta se não foi fornecido
if (-not $FolderPath) {
    $FolderPath = Read-Host "Digite o caminho da pasta"
}

# Verifica se a pasta existe
if (-not (Test-Path -Path $FolderPath -PathType Container)) {
    Write-Host "Pasta não encontrada!" -ForegroundColor Red
    exit
}

# Busca todas as DLLs na pasta
$dllFiles = Get-ChildItem -Path $FolderPath -Filter "*.dll"

if ($dllFiles.Count -eq 0) {
    Write-Host "Nenhuma DLL encontrada na pasta." -ForegroundColor Yellow
    exit
}

Write-Host "`nAnalisando $($dllFiles.Count) arquivo(s) DLL...`n" -ForegroundColor Cyan
Write-Host ("{0,-50} {1}" -f "Arquivo", "Arquitetura")
Write-Host ("-" * 70)

# Analisa cada DLL
$results = @()
foreach ($dll in $dllFiles) {
    $architecture = Get-DllArchitecture -DllPath $dll.FullName
    
    $result = [PSCustomObject]@{
        Arquivo = $dll.Name
        Arquitetura = $architecture
    }
    $results += $result
    
    Write-Host ("{0,-50} {1}" -f $dll.Name, $architecture)
}

Write-Host "`nPressione qualquer tecla para sair..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")