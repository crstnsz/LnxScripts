#!/usr/bin/env powershell

param (
    [Parameter(Position = 0)]
    [string]$CaminhoArquivo
)

# Se o caminho não foi passado por argumento, solicita ao usuário
if ([string]::IsNullOrWhiteSpace($CaminhoArquivo)) {
    $CaminhoArquivo = Read-Host "Digite o caminho completo do executável ou DLL"
}

# Limpa o caminho (remove aspas duplas caso o usuário tenha colado com elas)
$CaminhoArquivo = $CaminhoArquivo.Replace('"', '').Trim()

# Valida se o arquivo realmente existe antes de tentar ler
if (-Not (Test-Path $CaminhoArquivo -PathType Leaf)) {
    Write-Host "Erro: O arquivo não foi encontrado no caminho especificado: $CaminhoArquivo" -ForegroundColor Red
    exit
}

try {
    # Carrega o assembly apenas para reflexão (não executa nenhum código dele)
    $assembly = [System.Reflection.Assembly]::ReflectionOnlyLoadFrom($CaminhoArquivo)

    # Inicializa as variáveis com valores padrão válidos
    $peKind = [System.Reflection.PortableExecutableKinds]::ILOnly
    $machine = [System.Reflection.ImageFileMachine]::I386

    # Executa a leitura passando as variáveis por referência
    $assembly.ManifestModule.GetPEKind([ref]$peKind, [ref]$machine)

    # Saída formatada e colorida (Bonitinha)
    Write-Host ""
    Write-Host "===========================================" -ForegroundColor Cyan
    Write-Host "      Análise de Arquitetura do Assembly   " -ForegroundColor Cyan
    Write-Host "===========================================" -ForegroundColor Cyan
    Write-Host "Arquivo:  " -NoNewline; Write-Host $assembly.ManifestModule.Name -ForegroundColor Yellow
    Write-Host "Versão:   " -NoNewline; Write-Host $assembly.GetName().Version -ForegroundColor Yellow
    Write-Host "PEKind:   " -NoNewline; Write-Host $peKind -ForegroundColor Green
    Write-Host "Machine:  " -NoNewline; Write-Host $machine -ForegroundColor Green
    Write-Host "===========================================" -ForegroundColor Cyan

    # Conclusão inteligente baseada nos flags
    if ($peKind -match "Preferred32Bit") {
        Write-Host "[!] Diagnóstico: O assembly é AnyCPU, mas tem a flag 'Prefer 32-bit' ATIVADA." -ForegroundColor Magenta
        Write-Host "    Isso fará com que ele rode em 32-bits mesmo em servidores 64-bits." -ForegroundColor Gray
    } elseif ($peKind -eq "ILOnly" -and $machine -eq "I386") {
        Write-Host "[+] Diagnóstico: O assembly é AnyCPU puro." -ForegroundColor DarkGreen
        Write-Host "    Ele vai rodar nativamente como 64-bits em sistemas 64-bits." -ForegroundColor Gray
    } elseif ($machine -eq "AMD64") {
        Write-Host "[+] Diagnóstico: O assembly é estritamente 64 bits (x64)." -ForegroundColor DarkGreen
    } elseif ($machine -eq "I386" -and $peKind -match "Required32Bit") {
        Write-Host "[-] Diagnóstico: O assembly é estritamente 32 bits (x86)." -ForegroundColor Yellow
    }
    Write-Host ""

} catch {
    Write-Host "Erro ao ler o arquivo. Tem certeza que é um executável ou DLL válido do .NET?" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor DarkRed
}