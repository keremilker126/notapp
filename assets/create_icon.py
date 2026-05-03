from PIL import Image, ImageDraw
import os

# Yeni bir 512x512 resim oluştur
img = Image.new('RGB', (512, 512), color=(186, 104, 200))  # Mor arka plan

draw = ImageDraw.Draw(img)

# Gradyan etkisi için farklı tonda morlar kullanalım
for y in range(256):
    color = (186 - int(20 * y/256), 104 - int(10 * y/256), 200 - int(10 * y/256))
    draw.line([(0, y), (512, y)], fill=color)

# Sayfaları gösterelim (açık not defteri efekti)
# Ön sayfa - beyaz
draw.rectangle([80, 140, 432, 420], fill=(255, 255, 255), outline=(150, 80, 180), width=8)

# Sayfa arka kısmı - açık mor
draw.rectangle([100, 160, 380, 400], fill=(240, 220, 250), outline=(150, 80, 180), width=4)

# Kapak - koyu mor
draw.rectangle([60, 100, 420, 160], fill=(123, 31, 162), outline=(80, 20, 120), width=8)

# Kapak metnesi (dekoratif çizgiler)
draw.text((150, 120), "NOTES", fill=(255, 200, 240), font=None)

# Sayfalardaki çizgiler
for i in range(5):
    y_pos = 180 + i * 45
    draw.line([(120, y_pos), (380, y_pos)], fill=(200, 150, 220), width=3)

# Açılmış sayfa efekti - gölge
draw.arc([70, 130, 100, 430], 0, 180, fill=(150, 80, 180), width=6)

# Ikon kaydet
img.save('icon.png')
print("✓ icon.png başarıyla oluşturuldu!")
