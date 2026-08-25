# personal-dotfile

Config files for WezTerm, Yazi, Neovim, YASB, Komorebi, Tacky Borders, and Spicetify — managed from one place via symlinks and junction points. Also tracks Windhawk mod settings (registry-based, synced separately since Windhawk doesn't store config as files).

## Structure

```
dotfiles/
  wezterm/          # WezTerm terminal config
  yazi/             # Yazi file manager config
  nvim/             # Neovim config
  yasb/             # YASB status bar config (config.yaml, styles.css)
  komorebi/         # Komorebi tiling window manager config (komorebi.json, whkdrc)
  tacky-borders/    # Tacky Borders config (config.yaml)
  spicetify/        # Spicetify config (config-xpui.ini, Themes/tui, Extensions)
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
winget install LGUG2Z.komorebi
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

### 7. Komorebi config

Despite what the docs imply, komorebi looks for `komorebi.json` directly in `%USERPROFILE%` (`C:\Users\<you>\komorebi.json`) — not under `.config`. `setup.ps1` symlinks it there from `komorebi/komorebi.json`.

Editing the file does **not** auto-apply while komorebi is running — it's a static config, not hot-reloaded. After editing, run:

```powershell
komorebic replace-configuration "$env:USERPROFILE\komorebi.json"
```

### 8. whkd (keybindings)

whkd reads `komorebi/whkdrc`, symlinked to `%USERPROFILE%\.config\whkdrc` by `setup.ps1`. It's a separate process from komorebi — install it with:

```powershell
winget install LGUG2Z.whkd
```

Start it manually with `Start-Process whkd -WindowStyle Hidden`, or reload its bindings after an edit with `alt + o` (bound in `whkdrc` itself). To autostart both komorebi and whkd on login (one-time, applies from the next login onward — no reboot needed for the current session):

```powershell
komorebic enable-autostart --whkd
```

### 9. Tacky Borders

Not on winget — download the release binary and run it once so it creates `%USERPROFILE%\.config\tacky-borders\config.yaml`. `setup.ps1` then symlinks that to `tacky-borders/config.yaml` in this repo.

After editing the config, apply it without restarting with:

```powershell
tacky-borders reload
```

### 10. Spicetify

Install spicetify (and add it to PATH) per its own install docs, then run `spicetify` once so it creates `%APPDATA%\spicetify\config-xpui.ini`. `setup.ps1` then symlinks that to `spicetify/config-xpui.ini` in this repo.

Tracked: `config-xpui.ini`, `Themes/tui` (a hand-authored theme, junctioned in), and the whole `Extensions` folder (junctioned wholesale, since — unlike `Themes` — Marketplace doesn't put anything of its own in there). Not tracked: `Themes/marketplace`, `CustomApps/marketplace`, `Backup`, and `Extracted` under `%APPDATA%\spicetify` — those are auto-managed by spicetify/Marketplace or are machine-specific backups, not hand-authored config. Add more of your own themes the same way: create `spicetify/Themes/<name>` in this repo and a matching `Link-Dir` line in `setup.ps1`.

After editing the config (or picking a new theme), apply it with:

```powershell
spicetify apply
```

## Making changes

Edit any file inside `~/dotfiles/` directly — changes take effect immediately since all app config locations point here. Then commit and push as normal:

```powershell
cd "$env:USERPROFILE\dotfiles"
git add -A
git commit -m "your message"
git push
```
