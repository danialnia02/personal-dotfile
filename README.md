# personal-dotfile

Config files for WezTerm, Yazi, Neovim, and YASB — managed from one place via symlinks and junction points. Also tracks Windhawk mod settings (registry-based, synced separately since Windhawk doesn't store config as files).

## Structure

```
dotfiles/
  wezterm/          # WezTerm terminal config
  yazi/             # Yazi file manager config
  nvim/             # Neovim config
  yasb/             # YASB status bar config (config.yaml, styles.css)
  windhawk/         # Windhawk mod settings, synced via registry export/import (see below)
  setup.ps1         # Setup script for new machines
```

## Setup on a new machine

### 1. Turn on Developer Mode

Settings → Privacy & Security → For developers → Developer Mode: On

Required so `setup.ps1` can create symlinks without running as admin.

### 2. Install the apps

```powershell
winget install wez.wezterm
winget install sxyazi.yazi
winget install Neovim.Neovim
winget install AmN.yasb
winget install RamenSoftware.Windhawk
```

Also install the **Cascadia Mono** font (or Cascadia Code NF) — required for WezTerm and Yazi icons to display correctly.

### 3. Clone this repo

```powershell
git clone https://github.com/danialnia02/personal-dotfile.git "$env:USERPROFILE\dotfiles"
```

### 4. Run the setup script

```powershell
cd "$env:USERPROFILE\dotfiles"
.\setup.ps1
```

This creates symlinks for config files and junction points for the Neovim/Yazi folders, pointing each app at the dotfiles directory.

### 5. Yazi plugins

Inside Yazi, install the plugins:

```
ya pack -a yazi-rs/plugins#full-border
```

(Add any other plugins you use.)

### 6. Windhawk mods

Windhawk stores mod settings in the registry, not as files, so they aren't picked up by `setup.ps1`. After installing a mod (e.g. `windows-11-taskbar-styler`) through the Windhawk app:

```powershell
cd "$env:USERPROFILE\dotfiles\windhawk"
.\sync.ps1 -Import   # from an elevated PowerShell — writes to HKLM
```

Then toggle the mod off/on in Windhawk to apply. See `windhawk/sync.ps1` for the export side (used when you change settings and want to save them back to this repo).

## Making changes

Edit any file inside `~/dotfiles/` directly — changes take effect immediately since all app config locations point here. Then commit and push as normal:

```powershell
cd "$env:USERPROFILE\dotfiles"
git add -A
git commit -m "your message"
git push
```
