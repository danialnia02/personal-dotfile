# personal-dotfile

Config files for WezTerm, Yazi, and Neovim — managed from one place via hard links and junction points.

## Structure

```
dotfiles/
  wezterm/          # WezTerm terminal config
  yazi/             # Yazi file manager config
  nvim/             # Neovim config
  setup.ps1         # Setup script for new machines
```

## Setup on a new machine

### 1. Install the apps

```powershell
winget install wez.wezterm
winget install sxyazi.yazi
winget install Neovim.Neovim
```

Also install the **Cascadia Mono** font (or Cascadia Code NF) — required for WezTerm and Yazi icons to display correctly.

### 2. Clone this repo

```powershell
git clone https://github.com/danialnia02/personal-dotfile.git "$env:USERPROFILE\dotfiles"
```

### 3. Run the setup script

```powershell
cd "$env:USERPROFILE\dotfiles"
.\setup.ps1
```

This creates hard links for config files and a junction point for the Neovim folder, pointing each app at the dotfiles directory. No admin required.

### 4. Yazi plugins

Inside Yazi, install the plugins:

```
ya pack -a yazi-rs/plugins#full-border
```

(Add any other plugins you use.)

## Making changes

Edit any file inside `~/dotfiles/` directly — changes take effect immediately since all app config locations point here. Then commit and push as normal:

```powershell
cd "$env:USERPROFILE\dotfiles"
git add -A
git commit -m "your message"
git push
```
