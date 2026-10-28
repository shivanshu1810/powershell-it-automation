<#
.SYNOPSIS
    Produces a one-page workstation health check report.
.DESCRIPTION
    Collects the checks a Tier 1 analyst runs on a slow or faulty PC:
    OS version, uptime, disk free space, memory use, and the status of
    common services (Print Spooler, Windows Update). Saves a text report
    and prints a summary. Read-only - it changes nothing.
.PARAMETER OutputPath
    Report file path. Defaults to .\WorkstationHealth.txt
.PARAMETER LowDiskGB
    Warn when a fixed drive has less than this many GB free. Default 10.
.EXAMPLE
    .\Get-WorkstationHealthCheck.ps1 -LowDiskGB 15
.NOTES
    Author: Shivanshu Sharma - portfolio project.
#>
[CmdletBinding()]
param(
    [string]$OutputPath = ".\WorkstationHealth.txt",
    [int]$LowDiskGB = 10
)
$ErrorActionPreference = 'Stop'
try {
    $os = Get-CimInstance Win32_OperatingSystem
    $uptime = (Get-Date) - $os.LastBootUpTime
    $report = [System.Collections.Generic.List[string]]::new()
    $report.Add("WORKSTATION HEALTH CHECK - $env:COMPUTERNAME - $(Get-Date)")
    $report.Add("OS: $($os.Caption) Build $($os.BuildNumber)")
    $report.Add("Uptime: $($uptime.Days) days $($uptime.Hours) hours")
    $report.Add("Memory: $([math]::Round(($os.TotalVisibleMemorySize-$os.FreePhysicalMemory)/1MB,1)) GB used of $([math]::Round($os.TotalVisibleMemorySize/1MB,1)) GB")
    $report.Add("")
    $report.Add("Disks:")
    Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        $free = [math]::Round($_.FreeSpace/1GB,1)
        $flag = if ($free -lt $LowDiskGB) { "  <-- LOW SPACE" } else { "" }
        $report.Add("  $($_.DeviceID) $free GB free$flag")
    }
    $report.Add("")
    $report.Add("Services:")
    'Spooler','wuauserv' | ForEach-Object {
        $svc = Get-Service -Name $_ -ErrorAction SilentlyContinue
        if ($svc) { $report.Add("  $($svc.DisplayName): $($svc.Status)") }
    }
    $report | Set-Content -Path $OutputPath -Encoding UTF8
    $report | ForEach-Object { Write-Host $_ }
    Write-Host "`nReport saved to $OutputPath" -ForegroundColor Green
} catch {
    Write-Error "Health check failed: $($_.Exception.Message)"
    exit 1
}
