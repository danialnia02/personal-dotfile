# personal-dotfile

Config files for WezTerm, Yazi, Neovim, YASB, Komorebi, Flow Launcher, Spicetify, Fastfetch, and Oh My Posh — managed from one place via symlinks and junction points. Also tracks Windhawk mod settings (registry-based, synced separately since Windhawk doesn't store config as files) and a Nilesoft Shell config backup (plain copy, not linked).

## Structure

```
dotfiles/
  wezterm/          # WezTerm terminal config
  yazi/             # Yazi file manager config
  nvim/             # Neovim config
  yasb/             # YASB status bar config (config.yaml, styles.css)
  komorebi/         # Komorebi tiling window manager config (komorebi.json, whkdrc)
  flowlauncher/     # Flow Launcher config (Settings.json, Themes/gold.xaml)
  spicetify/        # Spicetify config (config-xpui.ini, Themes/tui, Extensions)
  windhawk/         # Windhawk mod settings, synced via registry export/import (see below)
  fastfetch/        # Fastfetch config (config.jsonc, ASCII logo .txt files) - not symlinked, see below
  ohmyposh/         # Oh My Posh theme (sonicboom_light.omp.json) - not symlinked, see below
  nilesoft-shell/   # Nilesoft Shell context menu config - plain copy, not linked, see below
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
winget install Flow-Launcher.Flow-Launcher
winget install RamenSoftware.Windhawk
winget install Fastfetch-cli.Fastfetch
winget install JanDeDobbeleer.OhMyPosh
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

**Layered windows (Electron/Store apps like Claude):** komorebi silently skips any window with the `WS_EX_LAYERED` style unless its exe is whitelisted, so `layered_applications` in `komorebi.json` holds a rule for `claude.exe` (plus `tray_and_multi_window_applications`, since it minimises to the tray). Rule matching is **case-sensitive** — the Claude MSIX binary is lowercase `claude.exe`, so the rules use a case-insensitive regex (`(?i)^claude[.]exe$`) rather than `Equals`. To debug a window komorebi refuses to tile, compare its exe/class/styles against `komorebic global-state` and `komorebic visible-windows`.

### 8. whkd (keybindings)

whkd reads `komorebi/whkdrc`, symlinked to `%USERPROFILE%\.config\whkdrc` by `setup.ps1`. It's a separate process from komorebi — install it with:

```powershell
winget install LGUG2Z.whkd
```

Start it manually with `Start-Process whkd -WindowStyle Hidden`, or reload its bindings after an edit with `alt + o` (bound in `whkdrc` itself). To autostart both komorebi and whkd on login (one-time, applies from the next login onward — no reboot needed for the current session):

```powershell
komorebic enable-autostart --whkd
```

### 9. Flow Launcher

`setup.ps1` symlinks `Settings.json` and `Themes/gold.xaml` into `%APPDATA%\FlowLauncher\`. Not tracked: `History.json`, `UserSelectedRecord.json`, `MultipleTopMostRecord.json` (and their `.bak` files) — those are usage state, not settings, so they're left as machine-local. Add more custom themes the same way: drop the `.xaml` in `flowlauncher/Themes/` and add a matching `Link-File` line in `setup.ps1`.

### 10. Spicetify

Install spicetify (and add it to PATH) per its own install docs, then run `spicetify` once so it creates `%APPDATA%\spicetify\config-xpui.ini`. `setup.ps1` then symlinks that to `spicetify/config-xpui.ini` in this repo.

Tracked: `config-xpui.ini`, `Themes/tui` (a hand-authored theme, junctioned in), and the whole `Extensions` folder (junctioned wholesale, since — unlike `Themes` — Marketplace doesn't put anything of its own in there). Not tracked: `Themes/marketplace`, `CustomApps/marketplace`, `Backup`, and `Extracted` under `%APPDATA%\spicetify` — those are auto-managed by spicetify/Marketplace or are machine-specific backups, not hand-authored config. Add more of your own themes the same way: create `spicetify/Themes/<name>` in this repo and a matching `Link-Dir` line in `setup.ps1`.

After editing the config (or picking a new theme), apply it with:

```powershell
spicetify apply
```

### 11. Fastfetch and Oh My Posh

Unlike the other apps, these aren't symlinked by `setup.ps1` — they're referenced directly from the PowerShell profile by their path in this repo:

```powershell
oh-my-posh init pwsh --config "C:\Users\<you>\dotfiles\ohmyposh\sonicboom_light.omp.json" | Invoke-Expression
$env:FASTFETCH_EAGLE_ROOT = 'C:\Users\<you>\dotfiles\fastfetch'
```

Add both lines to your `$PROFILE` (`Documents\PowerShell\Microsoft.PowerShell_profile.ps1`) — that file itself lives outside this repo and isn't tracked here, so it has to be set up by hand on a new machine. `fastfetch/config.jsonc` references the logo `.txt` files and `$env:FASTFETCH_EAGLE_ROOT` via relative/env paths, so no further linking is needed once the env var is set.

### 12. PowerShell typed-input color

The line you're actively typing at the prompt is colored via PSReadLine, in `$PROFILE` (`Documents\PowerShell\Microsoft.PowerShell_profile.ps1`) — that file lives outside this repo (see section 11), so this snippet has to be added by hand on a new machine:

```powershell
$typingColor = $PSStyle.Foreground.FromRgb(0xDC, 0xD7, 0xBA)
Set-PSReadLineOption -Colors @{
    Default   = $typingColor
    Command   = $typingColor
    Parameter = $typingColor
    Operator  = $typingColor
    Variable  = $typingColor
    String    = $typingColor
    Number    = $typingColor
    Type      = $typingColor
    Member    = $typingColor
}
```

Command *output* is left at the console's normal default (white) — only the input line is recolored. To change the color, edit the RGB values in `$typingColor` and open a new terminal.

### 13. Nilesoft Shell (right-click menu)

`nilesoft-shell/` is a plain copy of `shell.nss` and `imports/*.nss` from `C:\Program Files\Nilesoft Shell\` — **not symlinked**, since that's an admin-protected path and a normal (non-elevated) process can't create a symlink there. Treat this folder as a backup/reference, not a live config:

- After editing the live files in `C:\Program Files\Nilesoft Shell\`, copy them back here to keep the backup current (needs an elevated terminal to read them, since Program Files is admin-protected for some operations):
  ```powershell
  Copy-Item "C:\Program Files\Nilesoft Shell\shell.nss" ".\nilesoft-shell\shell.nss"
  Copy-Item "C:\Program Files\Nilesoft Shell\imports\*.nss" ".\nilesoft-shell\imports\"
  ```
- To restore onto a new machine, copy the other direction (elevated), then restart Explorer to pick up theme/border changes:
  ```powershell
  Copy-Item ".\nilesoft-shell\shell.nss" "C:\Program Files\Nilesoft Shell\shell.nss"
  Copy-Item ".\nilesoft-shell\imports\*.nss" "C:\Program Files\Nilesoft Shell\imports\"
  Stop-Process -Name explorer -Force
  ```

Theme colors follow Kanagawa (matches yasb): background `#1F1F28`, text `#DCD7BA`, border `#D19C36`.

### 14. Syncthing (start at logon)

Not a tracked config — just a startup step. The Windows installer (`%LOCALAPPDATA%\Programs\Syncthing`) ships a helper that registers a Task Scheduler logon task running `stctl.exe --start`, which launches Syncthing hidden (no console window). Prefer this over a `Run` key entry or a Startup-folder shortcut.

```powershell
wscript.exe "$env:LOCALAPPDATA\Programs\Syncthing\SyncthingLogonTask.js" /create /silent
```

Drop `/silent` for a confirmation dialog, or add `/startonacpoweronly` to skip starting on battery. To undo:

```powershell
wscript.exe "$env:LOCALAPPDATA\Programs\Syncthing\SyncthingLogonTask.js" /remove /silent
```

The task is named `Start Syncthing at logon (<user>@<host>)`; check it with `Get-ScheduledTask -TaskName '*Syncthing*'`.

## Making changes

Edit any file inside `~/dotfiles/` directly — changes take effect immediately since all app config locations point here. Then commit and push as normal:

```powershell
cd "$env:USERPROFILE\dotfiles"
git add -A
git commit -m "your message"
git push
```
