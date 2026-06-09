<#
    Parametro options. Um array para informar as opções de atualização:

    web: Para atualizar o Docspider desconsiderando a existência do serviço DocspiderServiceManager.

    services: Para atualizar o Docspider desconciderando a existencia do IIS e interface gráfica.

    Formas de uso:
    .\Docspider_Atualizador_#.#.#-##.ps1
    .\Docspider_Atualizador_#.#.#-##.ps1 web
    .\Docspider_Atualizador_#.#.#-##.ps1 services
#>

#Requires -RunAsAdministrator
param (
    [Parameter(Position = 0)]
    [string[]]$options = 0,
    [System.IO.DirectoryInfo]$localInstalacao
)

$ErrorActionPreference = "Stop"

Write-Host "Script name: $($MyInvocation.MyCommand.Name)"


# Somente para atualizacoes WEB
Import-Module -Name 'IISAdministration'
Import-Module -Name 'WebAdministration'

[System.Reflection.Assembly]::Load("System.EnterpriseServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a") | Out-Null

# Somente para atualizacoes de Servicos
if (!$options.Contains("web") -or ($options.Contains("web") -and $options.Contains("services"))) {
    # Parando o serviço DocspiderServiceManager e aguardando os processos que ele pode ter ativado.
    $service = Get-WmiObject -Class Win32_Service -Filter "Name='DocspiderServiceManager'"
    if ($null -ne $service) {
        Stop-Service -Name "DocspiderServiceManager"
    }
    $DocspiderExtractorProc = Get-Process DocspiderExtractor -ErrorAction SilentlyContinue
    if ($null -ne $DocspiderExtractorProc) {
        Write-Host "Aguardando enceramento do DocspiderExtractor..."
        Wait-Process DocspiderExtractor
    }
    $ExpireDocumentsProc = Get-Process ExpireDocuments -ErrorAction SilentlyContinue
    if ($null -ne $ExpireDocumentsProc) {
        Write-Host "Aguardando enceramento do ExpireDocuments..."
        Wait-Process ExpireDocuments
    }
    $LoadDocumentsProc = Get-Process LoadDocuments -ErrorAction SilentlyContinue
    if ($null -ne $LoadDocumentsProc) {
        Write-Host "Aguardando enceramento do LoadDocuments..."
        Wait-Process LoadDocuments
    }
    $NotificationProc = Get-Process Notification -ErrorAction SilentlyContinue
    if ($null -ne $NotificationProc) {
        Write-Host "Aguardando enceramento do Notification..."
        Wait-Process Notification
    }
    $ServicoIndexacaoProc = Get-Process ServicoIndexacao -ErrorAction SilentlyContinue
    if ($null -ne $ServicoIndexacaoProc) {
        Write-Host "Aguardando enceramento do ServicoIndexacao..."
        Wait-Process ServicoIndexacao
    }
    $SynchronizerProc = Get-Process Synchronizer -ErrorAction SilentlyContinue
    if ($null -ne $SynchronizerProc) {
        Write-Host "Aguardando enceramento do Synchronizer..."
        Wait-Process Synchronizer
    }
    $WorkflowTimeRuleProc = Get-Process WorkflowTimeRule -ErrorAction SilentlyContinue
    if ($null -ne $WorkflowTimeRuleProc) {
        Write-Host "Aguardando enceramento do WorkflowTimeRule..."
        Wait-Process WorkflowTimeRule
    }
    $DocspiderRegistryManagerProc = Get-Process DocspiderRegistryManager -ErrorAction SilentlyContinue
    if ($null -ne $DocspiderRegistryManagerProc) {
        Write-Host "Aguardando enceramento do DocspiderRegistryManager..."
        Wait-Process DocspiderRegistryManager
    }
    $AgrupamentoDeAreasProc = Get-Process AgrupamentoDeAreas -ErrorAction SilentlyContinue
    if ($null -ne $AgrupamentoDeAreasProc) {
        Write-Host "Aguardando enceramento do AgrupamentoDeAreas..."
        Wait-Process AgrupamentoDeAreas
    }
    $CargaDocumentosAtasProc = Get-Process CargaDocumentosAtas -ErrorAction SilentlyContinue
    if ($null -ne $CargaDocumentosAtasProc) {
        Write-Host "Aguardando enceramento do CargaDocumentosAtas..."
        Wait-Process CargaDocumentosAtas
    }
    $ChangesDocumentTypeProc = Get-Process ChangesDocumentType -ErrorAction SilentlyContinue
    if ($null -ne $ChangesDocumentTypeProc) {
        Write-Host "Aguardando enceramento do ChangesDocumentType..."
        Wait-Process ChangesDocumentType
    }
    $GeracaCienciaLeituraProc = Get-Process GeracaCienciaLeitura -ErrorAction SilentlyContinue
    if ($null -ne $GeracaCienciaLeituraProc) {
        Write-Host "Aguardando enceramento do GeracaCienciaLeitura..."
        Wait-Process GeracaCienciaLeitura
    }
    $IntegrationServiceProc = Get-Process IntegrationService -ErrorAction SilentlyContinue
    if ($null -ne $IntegrationServiceProc) {
        Write-Host "Aguardando enceramento do IntegrationService..."
        Wait-Process IntegrationService
    }
    $MetaDocExtratorServiceProc = Get-Process MetaDocExtratorService -ErrorAction SilentlyContinue
    if ($null -ne $MetaDocExtratorServiceProc) {
        Write-Host "Aguardando enceramento do MetaDocExtratorService..."
        Wait-Process MetaDocExtratorService
    }    
    $ReportDailyUpdatesProc = Get-Process ReportDailyUpdates -ErrorAction SilentlyContinue
    if ($null -ne $ReportDailyUpdatesProc) {
        Write-Host "Aguardando enceramento do ReportDailyUpdates..."
        Wait-Process ReportDailyUpdates
    }
}

# Somente para atualizacoes WEB
if (!$options.Contains("services") -or ($options.Contains("web") -and $options.Contains("services"))) {
    # Parando o IIS
    Write-Host "Parando o IIS"
    try {
        Write-Host "Executando iisreset /stop..."
        $iisresetOutput = iisreset /stop 2>&1
        Write-Host "Output do iisreset: $iisresetOutput"
        Write-Host "Exit code do iisreset: $LASTEXITCODE"
    } catch {
        Write-Host "Aviso: Erro ao parar IIS: $_" -ForegroundColor Yellow
        Write-Host "Stack trace: $($_.ScriptStackTrace)" -ForegroundColor Yellow
    }
    
    # APAGA ARQUIVOS E DIRETÓRIOS TEMPORÁRIOS DO DOTNET 
    $temporariosDotNet = [System.IO.Path]::GetFullPath("C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files")
    if (Test-Path $temporariosDotNet) {
        try {
            Get-ChildItem $temporariosDotNet -ErrorAction Stop | Remove-Item -Force -Recurse -ErrorAction Stop
        } catch {
            Write-Host "Aviso: Não foi possível limpar arquivos temporários: $_" -ForegroundColor Yellow
        }
    }
}

# Iniciando o serviço DocspiderServiceManager
if ($null -ne $service) {
    Stop-Service -Name "DocspiderServiceManager"
    Write-Host "Reinicializando serviço DocspiderServiceManager..."
    Start-Service -Name "DocspiderServiceManager"
}