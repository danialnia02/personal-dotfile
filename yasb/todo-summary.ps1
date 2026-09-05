# Feeds the yasb todo widget: the bar label (task count) and the hover tooltip (task list).
# Output: {"count": <n>, "list": "<numbered tasks from ## Today, plus an 'elsewhere' count>"}
$ErrorActionPreference = 'Stop'

$notes = "$env:USERPROFILE\Documents\notes\inbox\tasks.md"

$todayTasks = @()
$elsewhereCount = 0
if (Test-Path $notes) {
    $inToday = $false
    foreach ($line in Get-Content $notes) {
        $trimmed = $line.Trim()
        if ($trimmed -match '^#{1,6}\s+Today\s*$') {
            $inToday = $true
            continue
        }
        if ($inToday -and ($trimmed -match '^#{1,6}\s' -or $trimmed -match '^-{3,}$')) {
            $inToday = $false
        }
        # "- [ ] task" is unchecked; "- [x] task" is done.
        if ($line -match '^\s*[-*]\s*\[\s\]\s*(.+)$') {
            if ($inToday) { $todayTasks += $matches[1].Trim() } else { $elsewhereCount++ }
        }
    }
}

$listLines = @()
for ($i = 0; $i -lt $todayTasks.Count; $i++) { $listLines += "$($i + 1). $($todayTasks[$i])" }
if ($elsewhereCount -gt 0) {
    $listLines += ''
    $listLines += "$elsewhereCount more task(s) elsewhere."
}

$payload = [ordered]@{
    count = $todayTasks.Count
    list  = if ($listLines.Count) { $listLines -join "`n" } else { 'Nothing to do' }
}

$payload | ConvertTo-Json -Compress
