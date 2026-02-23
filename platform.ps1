param (
    [Parameter(Mandatory=$true)]
    [string]$Path
)

if (-not (Test-Path $Path)) {
    Write-Error "Arquivo não encontrado: $Path"
    return
}

# Executa o corflags e captura a saída como uma lista de strings
$out = corflags.exe $Path 2>$null

if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro: Não foi possível ler a DLL. O corflags.exe está no PATH?" -ForegroundColor Red
    return
}

# Extrai os valores usando Regex (mais robusto que grep/awk no Windows)
$pe = ($out | Select-String "PE\s+:\s+(.+)").Matches.Groups[1].Value.Trim()
$req32 = ($out | Select-String "32BITREQ\s+:\s+(.+)").Matches.Groups[1].Value.Trim()
$pref32 = ($out | Select-String "32BITPREF\s+:\s+(.+)").Matches.Groups[1].Value.Trim()

Write-Host "`n--- Análise de Arquitetura: $(Split-Path $Path -Leaf) ---" -ForegroundColor Cyan

if ($pe -eq "PE32+") {
    Write-Host "Resultado: 64-bit (x64)" -ForegroundColor Green
}
elseif ($pe -eq "PE32") {
    if ($req32 -eq "1") {
        Write-Host "Resultado: 32-bit (x86)" -ForegroundColor Yellow
    }
    elseif ($pref32 -eq "1") {
        Write-Host "Resultado: Any CPU (Prefer 32-bit)" -ForegroundColor Magenta
    }
    else {
        Write-Host "Resultado: Any CPU" -ForegroundColor Green
    }
}
else {
    Write-Host "Resultado: Arquitetura desconhecida ou DLL nativa." -ForegroundColor Gray
}
Write-Host ""