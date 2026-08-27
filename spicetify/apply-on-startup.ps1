# Repairs spicetify at logon.
#
# Spotify updates itself and replaces its xpui folder, which wipes the injected
# theme. The injected user.css is the marker: if it's there, the patches survived
# and this exits immediately, so this is a no-op on a normal logon.
$ErrorActionPreference = 'Continue'

$spicetify = "$env:LOCALAPPDATA\spicetify\spicetify.exe"
$spotifyExe = "$env:APPDATA\Spotify\Spotify.exe"
$marker = "$env:APPDATA\Spotify\Apps\xpui\user.css"

if (-not (Test-Path $spicetify)) { exit 0 }
if (Test-Path $marker) { exit 0 }

# Patches are gone. Spotify must be closed while its files are re-patched.
$wasRunning = $null -ne (Get-Process -Name Spotify -ErrorAction SilentlyContinue)
if ($wasRunning) {
    Stop-Process -Name Spotify -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
}

# "backup apply" (not plain "apply") because the Spotify version has changed.
& $spicetify backup apply 2>&1 | Out-Null

if ($wasRunning -and (Test-Path $spotifyExe)) {
    Start-Process $spotifyExe
}
