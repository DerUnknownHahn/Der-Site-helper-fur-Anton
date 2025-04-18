Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object Windows.Forms.Form
$form.FormBorderStyle = 'None'
$form.TopMost = $true
$form.Bounds = [Windows.Forms.Screen]::PrimaryScreen.Bounds
$form.BackColor = 'Magenta'
$form.TransparencyKey = 'Magenta'
$form.AllowTransparency = $true
$form.DoubleBuffered = $true
$form.KeyPreview = $true

$blocks = @()
$rand = New-Object Random
$close = $false
$lastSpawn = [DateTime]::Now

$form.Add_KeyDown({
    if ($_.KeyCode -eq 'D0') {
        $global:close = $true
        $form.Close()
    }
})

$form.Add_Paint({
    param($sender, $e)
    foreach ($block in $blocks) {
        $brush = New-Object Drawing.SolidBrush ($block.Color)
        $e.Graphics.FillRectangle($brush, $block.X, $block.Y, $block.Size, $block.Size)
        $brush.Dispose()
    }
})

$form.Show()

while (-not $close) {
    $now = [DateTime]::Now
    $delta = ($now - $lastSpawn).TotalMilliseconds

    if ($delta -ge 60) {
        $color = if ($rand.NextDouble() -lt 0.5) { [Drawing.Color]::White } else { [Drawing.Color]::Red }
        $block = New-Object PSObject -Property @{
            X = $rand.Next(0, $form.Width)
            Y = 0
            Size = $rand.Next(10, 30)
            Speed = $rand.Next(4, 10)
            Color = $color
        }
        $blocks += $block
        $lastSpawn = $now
    }

    foreach ($block in $blocks) {
        $block.Y += $block.Speed
    }

    $blocks = $blocks | Where-Object { $_.Y -lt ($form.Height + 50) }

    $form.Invalidate()
    Start-Sleep -Milliseconds 30
    [Windows.Forms.Application]::DoEvents()
}
