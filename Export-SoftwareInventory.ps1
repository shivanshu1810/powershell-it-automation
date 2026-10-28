<#
.SYNOPSIS
    Exports installed software to CSV for inventory and licence checks.
.DESCRIPTION
    Reads the Windows uninstall registry keys (64-bit and 32-bit) and
    exports name, version, publisher, and install date to a CSV that can
    be opened in Excel. Useful for asset audits and "is X installed?"
    tickets. Read-only.
.PARAMETER OutputPath
    CSV path. Defaults to .\SoftwareInventory.csv
.PARAMETER FilterName
    Optional text filter, e.g. -FilterName "Office" to list only matches.
.EXAMPLE
    .\Export-SoftwareInventory.ps1 -FilterName "Chrome"
.NOTES
    Author: Shivanshu Sharma - portfolio project.
#>
[CmdletBinding()]
param(
    [string]$OutputPath = ".\SoftwareInventory.csv",
    [string]$FilterName = ""
)
$ErrorActionPreference = 'Stop'
try {
    $paths = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    $apps = Get-ItemProperty $paths -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName } |
        Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
        Sort-Object DisplayName -Unique
    if ($FilterName) { $apps = $apps | Where-Object { $_.DisplayName -like "*$FilterName*" } }
    if (-not $apps) { Write-Warning "No matching software found."; exit 0 }
    $apps | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
    Write-Host "Exported $($apps.Count) programs to $OutputPath" -ForegroundColor Green
} catch {
    Write-Error "Software inventory failed: $($_.Exception.Message)"
    exit 1
}
