def hitung_total_material_linear(price_awal, increase_rate, max_lv):
    """
    Menghitung total material dengan kenaikan linear (Aritmatika).
    Sesuai logika: Level 4 = 154
    """
    # Kenaikan tetap setiap level (18 perak jika base 100)
    increment = price_awal * increase_rate
    
    total_akumulasi = 0
    print(f"{'Level':<10} | {'Harga':<15} | {'Total Akumulasi':<15}")
    print("-" * 45)

    for lv in range(1, max_lv + 1):
        # Rumus: Harga = Harga_Awal + (Level-1) * Increment
        harga_saat_ini = price_awal + (lv - 1) * increment
        total_akumulasi += harga_saat_ini
        
        # Cetak sampel untuk level 1-5 dan level kelipatan 10
        if lv >= 5 :
            print(f"Level {lv:<4} | {harga_saat_ini:<15.0f} | {total_akumulasi:<15.0f}")
            if lv == 5: print("...")

    return total_akumulasi

# Data Input
config = {
    "Price": 10,
    "Price_Increase": 0.126,
    "Price_Maximum_Lv": 50
}

# Eksekusi
print("SIMULASI PERHITUNGAN MATERIAL (LINEAR)")
total = hitung_total_material_linear(
    config["Price"], 
    config["Price_Increase"], 
    config["Price_Maximum_Lv"]
)

print("-" * 45)
print(f"TOTAL AKHIR UNTUK LEVEL {config['Price_Maximum_Lv']}: {total:,.0f}")