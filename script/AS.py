def hitung_nilai_awal(nilai_akhir, persentase_tambah):
    # Mengonversi persentase ke desimal (misal 50% menjadi 0.5)
    desimal_tambah = persentase_tambah / 100
    
    # Menghitung nilai awal
    # Rumus: Nilai Akhir / (1 + desimal_tambah)
    nilai_awal = nilai_akhir / (1 + desimal_tambah)
    
    return nilai_awal

# Data input
nilai_setelah_tambah = 831.95
persentase = 50

# Eksekusi
hasil = hitung_nilai_awal(nilai_setelah_tambah, persentase)

print(f"Nilai setelah tambahan {persentase}%: {nilai_setelah_tambah}")
print(f"Stat sebelum tambahan: {hasil:.2f}")
print(f"Stat kalau pakai pot tambahan: {hasil*2}")