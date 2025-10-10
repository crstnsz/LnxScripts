function Is-BusinessDay($date) {
    $dayOfWeek = $date.DayOfWeek.value__
    return ($dayOfWeek -ge 1 -and $dayOfWeek -le 5) # Monday=1, Friday=5
}

function Get-FirstBusinessDay($year, $month) {
    for ($day = 1; $day -le 7; $day++) {
        $date = Get-Date -Year $year -Month $month -Day $day
        if (Is-BusinessDay $date) {
            return $date
        }
    }
    return $null
}

function Get-FirstBusinessDayAfter15($year, $month) {
    $daysInMonth = [DateTime]::DaysInMonth($year, $month)
    for ($day = 16; $day -le $daysInMonth; $day++) {
        $date = Get-Date -Year $year -Month $month -Day $day
        if (Is-BusinessDay $date) {
            return $date
        }
    }
    return $null
}

function Should-NotifyToday {
    $today = Get-Date
    $fbd = Get-FirstBusinessDay $today.Year $today.Month
    $fbdAfter15 = Get-FirstBusinessDayAfter15 $today.Year $today.Month
    return ($today.Date -eq $fbd.Date -or $today.Date -eq $fbdAfter15.Date)
}

if (Should-NotifyToday) {
    Write-Host "Hoje é dia de enviar a nota!"
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show("Enviar a Planilha de controle de horas para o sensr.IT!", "Lembrete", "OK", "Information")
}
