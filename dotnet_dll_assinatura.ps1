param (
    [Parameter(Mandatory=$true)]
    [string]$CaminhoDll
)

try {
    # Armazenamos o objeto em uma variável para não precisar ler o arquivo duas vezes
    $assemblyName = [System.Reflection.AssemblyName]::GetAssemblyName($CaminhoDll)

    Write-Host "FullName: $($assemblyName.FullName)" -ForegroundColor Cyan
    Write-Host "Architecture: $($assemblyName.ProcessorArchitecture)" -ForegroundColor Yellow
}
catch {
    Write-Error "Não foi possível ler a DLL '$CaminhoDll'. Erro: $($_.Exception.Message)"
}