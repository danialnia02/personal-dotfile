# Dotfiles setup — no admin required (Developer Mode must be on for symlinks).
# Symlinks for files, junction points for directories.
#
# Requirements to install first:
#   winget install wez.wezterm
#   winget install sxyazi.yazi
#   winget install Neovim.Neovim
#   winget install Fastfetch-cli.Fastfetch
#   winget install JanDeDobbeleer.OhMyPosh
#   Font: Cascadia Mono (or Cascadia Code NF)
#   Settings > Privacy & Security > For developers > Developer Mode: On
#
# Fastfetch and Oh My Posh are not symlinked here - they're referenced directly
# by path from the PowerShell profile ($PROFILE). See README.md section 11.

$dotfiles = $PSScriptRoot

function Link-File($target, $source) {
    if (Test-Path $target) { Remove-Item $target -Force }
    New-Item -ItemType SymbolicLink -Path $target -Target $source | Out-Null
    Write-Host "  linked: $target"
}

function Link-Dir($target, $source) {
    if (Test-Path $target) { Remove-Item $target -Recurse -Force }
    New-Item -ItemType Junction -Path $target -Target $source | Out-Null
    Write-Host "  linked: $target"
}

Write-Host "`nWezTerm"
Link-File "$env:USERPROFILE\.wezterm.lua" "$dotfiles\wezterm\.wezterm.lua"

Write-Host "`nYazi"
Link-Dir "$env:APPDATA\yazi\config" "$dotfiles\yazi"

Write-Host "`nNeovim"
Link-Dir "$env:LOCALAPPDATA\nvim" "$dotfiles\nvim"

Write-Host "`nYASB"
New-Item -ItemType Directory -Path "$env:USERPROFILE\.config\yasb" -Force | Out-Null
Link-File "$env:USERPROFILE\.config\yasb\config.yaml" "$dotfiles\yasb\config.yaml"
Link-File "$env:USERPROFILE\.config\yasb\styles.css" "$dotfiles\yasb\styles.css"

Write-Host "`nKomorebi"
Link-File "$env:USERPROFILE\komorebi.json" "$dotfiles\komorebi\komorebi.json"
Link-File "$env:USERPROFILE\.config\whkdrc" "$dotfiles\komorebi\whkdrc"

Write-Host "`nFlow Launcher"
New-Item -ItemType Directory -Path "$env:APPDATA\FlowLauncher\Settings" -Force | Out-Null
Link-File "$env:APPDATA\FlowLauncher\Settings\Settings.json" "$dotfiles\flowlauncher\Settings.json"
New-Item -ItemType Directory -Path "$env:APPDATA\FlowLauncher\Themes" -Force | Out-Null
Link-File "$env:APPDATA\FlowLauncher\Themes\gold.xaml" "$dotfiles\flowlauncher\Themes\gold.xaml"

Write-Host "`nSpicetify"
New-Item -ItemType Directory -Path "$env:APPDATA\spicetify" -Force | Out-Null
Link-File "$env:APPDATA\spicetify\config-xpui.ini" "$dotfiles\spicetify\config-xpui.ini"
New-Item -ItemType Directory -Path "$env:APPDATA\spicetify\Themes" -Force | Out-Null
Link-Dir "$env:APPDATA\spicetify\Themes\tui" "$dotfiles\spicetify\Themes\tui"
Link-Dir "$env:APPDATA\spicetify\Themes\Kanagawa" "$dotfiles\spicetify\Themes\Kanagawa"
Link-Dir "$env:APPDATA\spicetify\Extensions" "$dotfiles\spicetify\Extensions"

Write-Host "`nSpicetify auto-repair task"
# Spotify updates wipe the injected theme; this re-applies it at logon.
$taskName = "SpicetifyApply"
$taskScript = "$dotfiles\spicetify\apply-on-startup.ps1"
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$taskScript`""
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 10)
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings `
    -Description "Re-apply spicetify theme if a Spotify update wiped it" -Force | Out-Null
Write-Host "  registered: $taskName (at logon)"

Write-Host "`nGit filters"
# Flow Launcher bumps ActivateTimes on every launch; keep that churn out of git.
# See .gitattributes - git config is per-clone, so it has to be set here.
git -C $dotfiles config filter.flowsettings.clean 'sed -E "s/\"ActivateTimes\": [0-9]+/\"ActivateTimes\": 0/"'
Write-Host "  configured: flowsettings clean filter"

Write-Host "`nDone. All configs linked from $dotfiles"
