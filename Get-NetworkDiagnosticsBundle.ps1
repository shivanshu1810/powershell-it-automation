<#
.SYNOPSIS
    Collects a network diagnostics bundle for a "no internet" ticket.
.DESCRIPTION
    Runs the standard Tier 1 checks in order - IP configuration, default
    gateway ping, internet ping, and DNS lookup - and saves all output to
    one text file you can attach to a ticket. Read-only.
.PARAMETER OutputPath
    Bundle file path. Defaults to .\NetworkDiagnostics.txt
.PARAMETER TestHost
    Hostname used for the DNS/internet test. Default www.microsoft.com
.EXAMPLE
    .\Get-NetworkDiagnosticsBundle.ps1
.NOTES
    Author: Shivanshu Sharma - portfolio project.
#>
[CmdletBinding()]
param(
    [string]$OutputPath = ".\NetworkDiagnostics.txt",
    [string]$TestHost = "www.microsoft.com"
)
$ErrorActionPreference = 'Continue'
try {
    $out = [System.Collections.Generic.List[string]]::new()
    $out.Add("NETWORK DIAGNOSTICS - $env:COMPUTERNAME - $(Get-Date)")
    $out.Add("`n== IP Configuration =="); $out.Add((ipconfig /all | Out-String))
    $gw = (Get-NetIPConfiguration | Select-Object -First 1).IPv4DefaultGateway.NextHop
    $out.Add("== Gateway ($gw) ==")
    $out.Add($(if ($gw) { (Test-Connection -ComputerName $gw -Count 2 -ErrorAction SilentlyContinue | Out-String) } else { "No default gateway found." }))
    $out.Add("== Internet / DNS ($TestHost) ==")
    $out.Add((Test-NetConnection -ComputerName $TestHost -Port 443 -ErrorAction SilentlyContinue | Out-String))
    $out | Set-Content -Path $OutputPath -Encoding UTF8
    Write-Host "Diagnostics saved to $OutputPath" -ForegroundColor Green
    $out | ForEach-Object { Write-Host $_ }
} catch {
    Write-Error "Diagnostics failed: $($_.Exception.Message)"
    exit 1
}
