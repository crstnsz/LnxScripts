#!/usr/bin/env powershell
Get-NetAdapter | Select-Object Name, InterfaceDescription, LinkSpeed