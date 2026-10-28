<#
.SYNOPSIS
    Creates a new-hire onboarding checklist and a local folder structure.
.DESCRIPTION
    Tier 1 onboarding helper. Given a new starter's name and department, it
    builds a checklist of the tasks a service desk analyst works through
    (account, mailbox, groups, hardware, software) and saves it as a text
    file. It does NOT create real Active Directory or Microsoft 365 accounts
    - it prepares the checklist so nothing gets missed.
.PARAMETER FullName
    Full name of the new starter, e.g. "Alex Example".
.PARAMETER Department
    Department name, e.g. "Finance".
.PARAMETER StartDate
    First day in yyyy-MM-dd format. Defaults to next Monday.
.PARAMETER OutputFolder
    Where to save the checklist. Defaults to .\Onboarding
.EXAMPLE
    .\New-UserOnboardingChecklist.ps1 -FullName "Alex Example" -Department "Finance"
.NOTES
    Author: Shivanshu Sharma - portfolio project for IT support automation practice.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$FullName,
    [Parameter(Mandatory)][string]$Department,
    [datetime]$StartDate = (Get-Date).AddDays(1),
    [string]$OutputFolder = ".\Onboarding"
)
$ErrorActionPreference = 'Stop'
try {
    if (-not (Test-Path $OutputFolder)) { New-Item -ItemType Directory -Path $OutputFolder | Out-Null }
    $safeName = ($FullName -replace '[^a-zA-Z0-9]','_')
    $file = Join-Path $OutputFolder "Onboarding-$safeName.txt"
    $lines = @(
        "NEW HIRE ONBOARDING CHECKLIST",
        "Name: $FullName",
        "Department: $Department",
        "Start date: $($StartDate.ToString('yyyy-MM-dd'))",
        "",
        "[ ] Active Directory account created and password set",
        "[ ] Microsoft 365 licence assigned and mailbox checked",
        "[ ] Added to department security groups",
        "[ ] Multi-factor authentication enrolment confirmed",
        "[ ] Laptop imaged, encrypted, and asset tag recorded",
        "[ ] Standard software installed and tested with user sign-in",
        "[ ] Printer mapping and shared drives tested",
        "[ ] Welcome email sent with IT contact details"
    )
    $lines | Set-Content -Path $file -Encoding UTF8
    Write-Host "Checklist saved to $file" -ForegroundColor Green
    $lines | ForEach-Object { Write-Host $_ }
} catch {
    Write-Error "Failed to create onboarding checklist: $($_.Exception.Message)"
    exit 1
}
