#!/bin/powershell

$senha = Read-Host -Prompt "Senha do usuário SYSTEM"
$servidor = Read-Host -Prompt "Servidor"
$porta = Read-Host -Prompt "Porta"
$instancia = Read-Host -Prompt "Instância"
$usuario = Read-Host -Prompt "Usuário a ser exportado"
$arquivo = Read-Host -Prompt "Arquivo de exportação (ex: C:\export.dmp)"
$log = Read-Host -Prompt "Arquivo de log (ex: C:\export.log)"

exp userid=system/$senha@$servidor:$porta/$instancia owner=$usuario file=$arquivo log=$log