# PowerShell Checks and Reports

More of my PowerShell practice. These scripts run checks and make simple reports, the kind of thing a service desk person runs again and again.

## Scripts

- New-UserOnboardingChecklist.ps1 - makes a checklist file for a new user: account, email, laptop, software
- Get-WorkstationHealthCheck.ps1 - one page report on a PC: Windows version, uptime, memory, disk space
- Export-SoftwareInventory.ps1 - saves a list of installed programs to a CSV file
- Get-NetworkDiagnosticsBundle.ps1 - saves IP, gateway, internet and DNS test results into one file to attach to a ticket
- Get-StaleADAccountReport.ps1 - lists Active Directory accounts not used in 90 days. It only makes a report, it does not change anything. Needs domain access

## How to run

    Set-ExecutionPolicy -Scope Process -Bypass

Then run the script you want from PowerShell.
