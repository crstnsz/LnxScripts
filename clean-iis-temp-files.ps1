#!/usr/bin/env powershell

# 1. Para o IIS e serviços dependentes
Stop-Service -Name "W3SVC" -Force
Stop-Service -Name "WAS" -Force

# 2. Aguarda 2 segundos para garantir a liberação dos arquivos
Start-Sleep -Seconds 2

# 3. Limpa os temporários do .NET Framework (ASP.NET)
Write-Host "Limpando cache do ASP.NET Framework..." -ForegroundColor Cyan
Remove-Item -Path "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files\*" -Recurse -Force -ErrorAction SilentlyContinue

# 4. Limpa o cache de compressão nativa do IIS
Write-Host "Limpando cache de compressão do IIS..." -ForegroundColor Cyan
Remove-Item -Path "C:\inetpub\temp\IIS Temporary Compressed Files\*" -Recurse -Force -ErrorAction SilentlyContinue

# 5. Limpa a pasta temporária geral do inetpub
Remove-Item -Path "C:\inetpub\temp\ASP Compiled Templates\*" -Recurse -Force -ErrorAction SilentlyContinue

# 6. Reinicia os serviços do IIS
Write-Host "Reiniciando o IIS..." -ForegroundColor Green
Start-Service -Name "WAS"
Start-Service -Name "W3SVC"

Write-Host "Limpeza concluída com sucesso!" -ForegroundColor Green