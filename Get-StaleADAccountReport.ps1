<#
.SYNOPSIS
    Reports Active Directory accounts that have not signed in recently.
.DESCRIPTION
    Finds enabled AD user accounts with no sign-in for a given number of
    days and exports them to CSV for review. This is a report only - it
    never disables or deletes accounts. If the Active Directory module or
    a domain connection is not available, it explains that clearly instead
    of failing silently.
.PARAMETER DaysInactive
    Days since last sign-in. Default 90.
.PARAMETER OutputPath
    CSV path. Defaults to .\StaleADAccounts.csv
.EXAMPLE
    .\Get-StaleADAccountReport.ps1 -DaysInactive 60
.NOTES
    Author: Shivanshu Sharma - portfolio project.
    Requires: RSAT Active Directory module and domain connectivity.
#>
[CmdletBinding()]
param(
    [int]$DaysInactive = 90,
    [string]$OutputPath = ".\StaleADAccounts.csv"
)
$ErrorActionPreference = 'Stop'
try {
    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        Write-Warning "Active Directory module not found. Install RSAT (Settings > Optional Features > RSAT: Active Directory) and run this on a domain-joined PC."
        exit 0
    }
    Import-Module ActiveDirectory
    $cutoff = (Get-Date).AddDays(-$DaysInactive)
    $users = Get-ADUser -Filter { Enabled -eq $true } -Properties LastLogonDate, Department |
        Where-Object { $_.LastLogonDate -and $_.LastLogonDate -lt $cutoff } |
        Select-Object Name, SamAccountName, Department, LastLogonDate |
        Sort-Object LastLogonDate
    if (-not $users) { Write-Host "No stale accounts found."; exit 0 }
    $users | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
    Write-Host "Found $($users.Count) accounts inactive for $DaysInactive+ days. Saved to $OutputPath" -ForegroundColor Yellow
    Write-Host "Review before taking any action - this script does not disable accounts."
} catch {
    Write-Error "Stale account report failed: $($_.Exception.Message)"
    exit 1
}
