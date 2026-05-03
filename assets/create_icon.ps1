Add-Type -AssemblyName System.Drawing
$bitmap = New-Object System.Drawing.Bitmap 512,512
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.Clear([System.Drawing.Color]::FromArgb(255, 186, 104, 200))  # Mor arka plan
$pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::White, 10)
$brush = [System.Drawing.Brushes]::White
# Basit not defteri çizimi
$graphics.FillRectangle($brush, 100, 100, 312, 312)  # Sayfa
$graphics.DrawRectangle($pen, 100, 100, 312, 312)
$purpleBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 123, 31, 162))
$graphics.FillRectangle($purpleBrush, 100, 100, 312, 50)  # Kapak
$graphics.DrawLine($pen, 150, 150, 350, 150)  # Çizgi
$graphics.DrawLine($pen, 150, 200, 350, 200)
$graphics.DrawLine($pen, 150, 250, 350, 250)
$bitmap.Save('icon.png', [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose()
$bitmap.Dispose()