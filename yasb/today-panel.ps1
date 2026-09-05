# A dropdown panel listing today's todos, launched from the yasb todo widget.
# Closes on Escape or when it loses focus. Running it again while open toggles it shut.
$ErrorActionPreference = 'Stop'

$pidFile = Join-Path $env:TEMP 'yasb-today-panel.pid'

# Toggle: if a panel is already open, close it and stop.
if (Test-Path $pidFile) {
    $existing = Get-Content $pidFile -ErrorAction SilentlyContinue
    if ($existing) {
        $proc = Get-Process -Id $existing -ErrorAction SilentlyContinue
        if ($proc -and $proc.ProcessName -match 'powershell|pwsh') {
            Stop-Process -Id $existing -Force -ErrorAction SilentlyContinue
            Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
            exit 0
        }
    }
    Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
}
$PID | Set-Content $pidFile

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Kanagawa palette, matching the bar.
$panelBg = '#16161D'
$fg = '#DCD7BA'
$accent = '#C8C093'
$muted = '#54546D'
$border = '#2A2A37'
$font = 'Segoe UI Variable, Segoe UI'

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Today" WindowStyle="None" ResizeMode="NoResize" ShowInTaskbar="False"
        AllowsTransparency="True" Background="Transparent" Topmost="True"
        Width="294" SizeToContent="Height">
  <Border Background="$panelBg" BorderBrush="$border" BorderThickness="1" CornerRadius="12" Padding="16">
    <StackPanel>
      <TextBlock Text="Today's tasks" Foreground="$accent" FontFamily="$font"
                 FontSize="14" FontWeight="Bold" HorizontalAlignment="Center" Margin="0,0,0,10"/>
      <ItemsControl x:Name="Todos">
        <ItemsControl.ItemTemplate>
          <DataTemplate>
            <TextBlock Text="{Binding}" Foreground="$fg" FontFamily="$font" FontSize="13"
                       TextWrapping="Wrap" TextAlignment="Left" Margin="0,0,0,8"/>
          </DataTemplate>
        </ItemsControl.ItemTemplate>
      </ItemsControl>
      <TextBlock x:Name="Empty" Text="Nothing to do" Foreground="$muted" FontFamily="$font"
                 FontSize="13" HorizontalAlignment="Center"/>
    </StackPanel>
  </Border>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Todo list, parsed by the same script the bar widget uses.
$tasks = @()
$summary = & (Join-Path $PSScriptRoot 'todo-summary.ps1') | ConvertFrom-Json
if ($summary.list -and $summary.list -ne 'Nothing to do') {
    $tasks = $summary.list -split "`n"
}

$todosCtrl = $window.FindName('Todos')
$emptyCtrl = $window.FindName('Empty')
if ($tasks.Count -gt 0) {
    $todosCtrl.ItemsSource = $tasks
    $emptyCtrl.Visibility = 'Collapsed'
} else {
    $todosCtrl.Visibility = 'Collapsed'
}

# Centre it under the cursor, keeping it on screen. Uses the declared Width rather than
# ActualWidth, which is still 0 this early and would leave the panel hanging off to the
# right. Cursor and screen bounds are physical pixels; WPF positions in device-independent
# units, so convert for correctness on a scaled display.
$window.Add_SourceInitialized({
    $source = [System.Windows.PresentationSource]::FromVisual($window)
    $toDip = $source.CompositionTarget.TransformFromDevice

    $cursor = [System.Windows.Forms.Cursor]::Position
    $area = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
    $point = $toDip.Transform([Windows.Point]::new($cursor.X, $cursor.Y))
    $topLeft = $toDip.Transform([Windows.Point]::new($area.Left, $area.Top))
    $bottomRight = $toDip.Transform([Windows.Point]::new($area.Right, $area.Bottom))

    $width = $window.Width
    $left = $point.X - ($width / 2)
    $minLeft = $topLeft.X + 8
    $maxLeft = $bottomRight.X - $width - 8
    if ($left -lt $minLeft) { $left = $minLeft }
    if ($left -gt $maxLeft) { $left = $maxLeft }

    $window.Left = $left
    $window.Top = $topLeft.Y + 4
})

$window.Add_Deactivated({ $window.Close() })
$window.Add_KeyDown({ if ($_.Key -eq 'Escape') { $window.Close() } })
$window.Add_Closed({ Remove-Item $pidFile -Force -ErrorAction SilentlyContinue })

$window.ShowDialog() | Out-Null
