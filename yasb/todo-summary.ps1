# Feeds the yasb todo widget: the bar label (task count) and the hover tooltip (task list).
# Output: {"count": <n>, "list": "<one task per line>"}
$ErrorActionPreference = 'Stop'

$notes = "$env:USERPROFILE\Documents\notes\things-to-do.md"

$tasks = @()
if (Test-Path $notes) {
    # "- [ ] task" is unchecked; "- [x] task" is done.
    $tasks = Get-Content $notes |
        Where-Object { $_ -match '^\s*[-*]\s*\[\s\]\s*(.+)$' } |
        ForEach-Object { $matches[1].Trim() }
}

$payload = [ordered]@{
    count = $tasks.Count
    list  = if ($tasks.Count) { ($tasks | ForEach-Object { "- $_" }) -join "`n" } else { 'Nothing to do' }
}

$payload | ConvertTo-Json -Compress
