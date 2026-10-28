# PowerShell IT Automation Scripts

Practical PowerShell scripts for everyday Tier 1 IT support tasks: onboarding, workstation checks, software inventory, network troubleshooting, and account hygiene reporting.

Built as a self-directed portfolio project to practise automating the repetitive checks a service desk analyst runs every day.

## Scripts

| Script | What it does |
|---|---|
| `New-UserOnboardingChecklist.ps1` | Creates a new-hire checklist file (account, mailbox, groups, hardware, software) so no onboarding step is missed. Does not create real AD/Microsoft 365 accounts. |
| `Get-WorkstationHealthCheck.ps1` | One-page health report: OS, uptime, memory, low-disk warnings, and key service status. Read-only. |
| `Export-SoftwareInventory.ps1` | Exports installed programs (name, version, publisher) to CSV for audits and licence checks. Read-only. |
| `Get-NetworkDiagnosticsBundle.ps1` | Collects IP config, gateway, internet, and DNS results into one file to attach to a ticket. Read-only. |
| `Get-StaleADAccountReport.ps1` | Reports enabled AD accounts inactive for 90+ days to CSV. Report only — never disables accounts. Needs RSAT and domain access. |

> Looking for basic one-off fixes (print spooler, temp files, disk space)? Those live in my separate [powershell-toolkit](https://github.com/shivanshu1810/powershell-toolkit) repo. This repo focuses on repeatable checks, reports, and bundles.

## How to run

```powershell
# Allow local scripts for this session only
Set-ExecutionPolicy -Scope Process -Bypass

# Examples
.\New-UserOnboardingChecklist.ps1 -FullName "Alex Example" -Department "Finance"
.\Get-WorkstationHealthCheck.ps1
.\Export-SoftwareInventory.ps1 -FilterName "Chrome"
.\Get-NetworkDiagnosticsBundle.ps1
.\Get-StaleADAccountReport.ps1 -DaysInactive 60
```

Every script has comment-based help — run `Get-Help .\<script>.ps1 -Full` for parameters and examples. Scripts use parameters, `try/catch` error handling, and clear console output, and the read-only scripts change nothing on the machine.

## Skills demonstrated

- PowerShell scripting with parameters, comment-based help, and error handling
- Windows administration basics: services, disks, registry-based software inventory, `ipconfig` / `Test-NetConnection`
- Active Directory reporting concepts (with a safe, report-only approach)
- Tier 1 troubleshooting workflow: collect evidence first, then attach it to the ticket

## Requirements

- Windows 10/11, PowerShell 5.1 or PowerShell 7
- `Get-StaleADAccountReport.ps1` also needs the RSAT Active Directory module and domain connectivity; the other four run on a standalone PC

## About

Recent Computer Systems Technician – Networking graduate (Georgian College, 2026) with Tier 1 Service Desk Analyst co-op experience at Royal Victoria Regional Health Centre, supporting Windows 11, Microsoft 365, Active Directory, and Halo ITSM. Building small, honest tools that reflect real helpdesk work.
