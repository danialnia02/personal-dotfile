# Sets the pomodoro widget's work_duration in config.yaml.
# yasb has watch_config enabled, so it picks the change up on save.
# Note: reloading restarts the widget, so this resets a running timer.
param(
    [Parameter(Mandatory)]
    [ValidateRange(1, 240)]
    [int]$Minutes
)

$config = Join-Path $PSScriptRoot 'config.yaml'
if (-not (Test-Path $config)) { exit 1 }

$content = Get-Content $config -Raw
$pattern = '(?m)^(\s*work_duration:[ \t]*)\d+'
if ($content -notmatch $pattern) { exit 1 }

$updated = [regex]::Replace($content, $pattern, { param($m) $m.Groups[1].Value + $Minutes }, 1)
if ($updated -ne $content) {
    Set-Content -Path $config -Value $updated -NoNewline
}
