# Syncs Windhawk mod *settings* (not install/version metadata, which Windhawk
# manages itself) between the registry and the .reg files in .\mods.
#
# Usage:
#   .\sync.ps1 -Export   # registry -> mods\<name>.reg   (run as normal user)
#   .\sync.ps1 -Import   # mods\<name>.reg -> registry   (must run as Administrator)
#
# After -Import, toggle the mod off/on in the Windhawk app (or restart Windhawk)
# to pick up the new settings.

param(
    [switch]$Export,
    [switch]$Import
)

$Mods = @(
    "windows-11-taskbar-styler"
)

$ModsDir = Join-Path $PSScriptRoot "mods"

function Export-Mod {
    param($Name)
    $key = "HKLM\SOFTWARE\Windhawk\Engine\Mods\$Name\Settings"
    $file = Join-Path $ModsDir "$Name.reg"
    reg export $key $file /y | Out-Null
    Write-Host "Exported $Name -> $file"
}

function Import-Mod {
    param($Name)
    $file = Join-Path $ModsDir "$Name.reg"
    if (-not (Test-Path $file)) {
        Write-Warning "No .reg file for $Name, skipping"
        return
    }
    reg import $file | Out-Null
    Write-Host "Imported $Name from $file"
}

if ($Import -and -not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Importing writes to HKLM and requires an elevated (Administrator) PowerShell session."
    exit 1
}

if ($Export) {
    foreach ($m in $Mods) { Export-Mod $m }
}
elseif ($Import) {
    foreach ($m in $Mods) { Import-Mod $m }
    Write-Host "Now toggle each mod off/on in Windhawk to apply the imported settings."
}
else {
    Write-Host "Usage: .\sync.ps1 -Export | -Import"
}
