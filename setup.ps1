# Dotfiles setup — no admin required (Developer Mode must be on for symlinks).
# Symlinks for files, junction points for directories.
#
# Requirements to install first:
#   winget install wez.wezterm
#   winget install sxyazi.yazi
#   winget install Neovim.Neovim
#   Font: Cascadia Mono (or Cascadia Code NF)
#   Settings > Privacy & Security > For developers > Developer Mode: On

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

Write-Host "`nSpicetify"
New-Item -ItemType Directory -Path "$env:APPDATA\spicetify" -Force | Out-Null
Link-File "$env:APPDATA\spicetify\config-xpui.ini" "$dotfiles\spicetify\config-xpui.ini"
New-Item -ItemType Directory -Path "$env:APPDATA\spicetify\Themes" -Force | Out-Null
Link-Dir "$env:APPDATA\spicetify\Themes\tui" "$dotfiles\spicetify\Themes\tui"
Link-Dir "$env:APPDATA\spicetify\Extensions" "$dotfiles\spicetify\Extensions"

Write-Host "`nDone. All configs linked from $dotfiles"
