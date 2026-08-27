# Sets the default foreground text color for PowerShell console windows (conhost).
# Kanagawa theme cream/yellow, matching yasb, wezterm, and nilesoft-shell.
#
# To change the color in the future: edit $ForegroundHex below, then re-run this script
# (no admin needed, HKCU only). Reopen any already-open console windows to see it.

$ForegroundHex = "DCD7BA"   # <-- change this hex to change PowerShell's default text color

# --- old values, kept for reference / manual revert ---
# Global console default (color table slot 7) was Windows stock light gray:
#   Set-ItemProperty -Path 'HKCU:\Console' -Name ColorTable07 -Value 13421772 -Type DWord
# Legacy "Windows PowerShell" console (slot 6) had no override, i.e. it used the
# built-in OS default swatch for that slot. To revert it to that default:
#   Remove-ItemProperty -Path 'HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe' -Name ColorTable06

function ConvertTo-ConsoleColorValue($hex) {
    $r = [Convert]::ToInt32($hex.Substring(0, 2), 16)
    $g = [Convert]::ToInt32($hex.Substring(2, 2), 16)
    $b = [Convert]::ToInt32($hex.Substring(4, 2), 16)
    ($b -shl 16) -bor ($g -shl 8) -bor $r
}

$value = ConvertTo-ConsoleColorValue $ForegroundHex

# Global console default: used by pwsh.exe (PowerShell 7) and any app with no dedicated console profile
Set-ItemProperty -Path 'HKCU:\Console' -Name 'ColorTable07' -Value $value -Type DWord

# Legacy "Windows PowerShell" (powershell.exe) console profile
Set-ItemProperty -Path 'HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe' -Name 'ColorTable06' -Value $value -Type DWord

Write-Host "Console foreground set to #$ForegroundHex. Reopen any open console windows to see the change."
