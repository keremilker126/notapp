Add-Type -AssemblyName System.Drawing

# Create image
$bitmap = New-Object System.Drawing.Bitmap 512, 512
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.Clear([System.Drawing.Color]::White)

# Fill with gradient background
for ($i = 0; $i -lt 512; $i++) {
    $progress = $i / 512.0
    $r = [int](225 - 120 * $progress)
    $g = [int](190 - 100 * $progress)
    $b = [int](231 - 50 * $progress)
    $color = [System.Drawing.Color]::FromArgb(255, $r, $g, $b)
    $pen = New-Object System.Drawing.Pen($color, 1)
    $graphics.DrawLine($pen, 0, $i, 512, $i)
    $pen.Dispose()
}

# Draw shadow ellipse
$shadowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(40, 0, 0, 0))
$graphics.FillEllipse($shadowBrush, 160, 460, 192, 30)

# Draw back page (shadow) - light purple
$backPageBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(209, 196, 233))
$graphics.FillRectangle($backPageBrush, 100, 160, 312, 280)

# Draw front page - white with purple border
$whiteBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
$graphics.FillRectangle($whiteBrush, 80, 140, 352, 300)

$purplePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(123, 31, 162), 8)
$graphics.DrawRectangle($purplePen, 80, 140, 352, 300)

# Draw lines on page
$linePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(186, 104, 200), 6)
$graphics.DrawLine($linePen, 120, 200, 400, 200)
$graphics.DrawLine($linePen, 120, 260, 400, 260)
$graphics.DrawLine($linePen, 120, 320, 400, 320)
$graphics.DrawLine($linePen, 120, 380, 380, 380)

# Draw cover (dark purple) with gradient effect
$coverBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(123, 31, 162))
$graphics.FillRectangle($coverBrush, 60, 80, 392, 90)

$darkPurplePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(74, 20, 140), 6)
$graphics.DrawRectangle($darkPurplePen, 60, 80, 392, 90)

# Draw decorative circles on cover
$lightPurpleBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(206, 147, 216))
$graphics.FillEllipse($lightPurpleBrush, 120, 113, 24, 24)
$graphics.FillEllipse($lightPurpleBrush, 160, 113, 24, 24)
$graphics.FillEllipse($lightPurpleBrush, 200, 113, 24, 24)

# Draw ribbon/bookmark effect
$ribbonBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(206, 147, 216))
$graphics.FillRectangle($ribbonBrush, 230, 70, 52, 180)

# Draw left edge shadow for open book effect
$shadowPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(150, 94, 181), 8)
$graphics.DrawLine($shadowPen, 70, 150, 70, 360)

# Save the bitmap
$bitmap.Save('icon.png', [System.Drawing.Imaging.ImageFormat]::Png)

# Cleanup
$graphics.Dispose()
$bitmap.Dispose()
$purplePen.Dispose()
$darkPurplePen.Dispose()
$linePen.Dispose()
$coverBrush.Dispose()
$whiteBrush.Dispose()
$backPageBrush.Dispose()
$shadowBrush.Dispose()
$lightPurpleBrush.Dispose()
$ribbonBrush.Dispose()
$shadowPen.Dispose()

Write-Host "Icon created successfully!" -ForegroundColor Green
