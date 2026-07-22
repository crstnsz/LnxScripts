$packages = @(
    "Newtonsoft.Json", "Polly", "NEST", "Elasticsearch.Net", 
    "Microsoft.Bcl.AsyncInterfaces", "System.Text.Json", 
    "System.Memory", "System.Buffers", "System.IO.Pipelines", "Tesseract"
)

$dest = "./dlls_pure_x64"
if (!(Test-Path $dest)) { New-Item -ItemType Directory -Path $dest }

foreach ($pkg in $packages) {
    Write-Host "Processando $pkg..." -ForegroundColor Cyan
    $url = "https://www.nuget.org/api/v2/package/$pkg"
    $zipFile = "$dest\$pkg.zip"
    
    Invoke-WebRequest -Uri $url -OutFile $zipFile
    $tempDir = "$dest\temp_$pkg"
    Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force
    
    # LÓGICA DE PRIORIDADE: 
    # Procuramos primeiro por net6, net5, netstandard (que são AnyCPU/x64)
    # Se não houver, pegamos a versão net462 ou superior.
    $dll = Get-ChildItem -Path $tempDir -Filter "$pkg.dll" -Recurse | 
           Where-Object { $_.FullName -like "*lib*" } |
           Sort-Object { 
               if ($_.FullName -like "*net6*") { 1 }
               elseif ($_.FullName -like "*netstandard2*") { 2 }
               elseif ($_.FullName -like "*net46*") { 3 }
               else { 4 }
           } | Select-Object -First 1

    if ($dll) {
        Copy-Item -Path $dll.FullName -Destination "$dest\$($pkg).dll" -Force
        Write-Host "Convertida: $($pkg).dll" -ForegroundColor Green
    }

    Remove-Item $tempDir -Recurse -Force
    Remove-Item $zipFile -Force
}