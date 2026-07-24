# Dotfiles setup — no admin required.
# Hard links for files, junction points for directories.
#
# Requirements to install first:
#   winget install wez.wezterm
#   winget install sxyazi.yazi
#   winget install Neovim.Neovim
#   Font: Cascadia Mono (or Cascadia Code NF)

$dotfiles = $PSScriptRoot

function Link-File($target, $source) {
    if (Test-Path $target) { Remove-Item $target -Force }
    New-Item -ItemType HardLink -Path $target -Target $source | Out-Null
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

Write-Host "`nDone. All configs linked from $dotfiles"
