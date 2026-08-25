# Slider

Slider numerik yang bisa diseret dengan stepping opsional dan input teks manual. Nilainya bisa dibatasi, di-step, dan diformat sebagai integer atau float.

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        print("Volume:", value)
    end
})
```

## Konfigurasi

Anda bisa mendefinisikan rentang dengan tabel `Value`, atau dengan field datar `Min` / `Max` / `Default`.

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `"Slider"` | Label utama. Mendukung [token rich-text](/id/elements/#rich-text-di-title-desc). |
| `Desc` | `string` | `nil` | Deskripsi opsional di bawah judul. |
| `Value` | `table` | `nil` | Tabel rentang `{ Min, Max, Default }`. Alternatif dari field di bawah. |
| `Min` | `number` | `0` | Batas bawah (jika tidak memakai `Value`). |
| `Max` | `number` | `100` | Batas atas (jika tidak memakai `Value`). |
| `Default` | `number` | `0` | Nilai awal (jika tidak memakai `Value`). |
| `Step` | `number` | `1` | Kelipatan antar titik. Step **pecahan** (mis. `0.1`) mengalihkan slider ke mode float. |
| `Locked` | `boolean` | `false` | Menampilkan overlay kunci dan memblokir interaksi. |
| `Callback` | `function` | `nil` | Dijalankan saat berubah. **Menerima string terformat** (lihat di bawah). |
| `Flag` | `string` | `nil` | Key persistensi konfigurasi. Lihat [Konfigurasi & Flag](/id/features/config-and-flags). |
| `Buttons` | `table` | `nil` | Tombol inline yang dirender di baris. |
| `TitleGradient` | `table` | `nil` | Gradient yang diterapkan pada teks judul. |
| `DescGradient` | `table` | `nil` | Gradient yang diterapkan pada teks deskripsi. |

::: warning Argumen callback berupa string
Nilai yang diteruskan ke `Callback` adalah **string terformat**, bukan angka. Slider integer menerima bilangan bulat yang di-floor (`"50"`); slider float (`Step` pecahan) menerima string `"%.2f"` (`"0.50"`). Konversikan dengan `tonumber(value)` sebelum melakukan operasi matematika.
:::

Slider juga mewarisi konfigurasi dan method [base bersama](/id/elements/#base-bersama).

## Format nilai & snapping

- **Snapping** — posisi mentah menempel ke step terdekat: `floor(raw / Step + 0.5) * Step`.
- **Integer vs float** — `Step` integer mem-floor nilai menjadi bilangan bulat; `Step` pecahan memformatnya dengan `"%.2f"`.
- **Input manual** — nilainya juga berupa field teks. Klik, ketik angka, lalu tekan **Enter** untuk menerapkannya.
- **Persistensi** — ketika `Flag` diatur, konfigurasi menyimpan `Value.Default` sebagai string terformat.

## Method

### `Slider:Set(value, input?)`

Mengatur nilai slider lewat kode. `value` adalah angka di dalam rentang; `input?` adalah flag opsional yang dipakai ketika perubahan berasal dari field teks manual.

```lua
mySlider:Set(75)
```

### `Slider:SetMin(n)`

Memperbarui batas bawah slider.

```lua
mySlider:SetMin(10)
```

### `Slider:SetMax(n)`

Memperbarui batas atas slider.

```lua
mySlider:SetMax(200)
```

### `Slider:Lock()` / `Slider:Unlock()`

Mengunci atau membuka kunci slider.

```lua
mySlider:Lock()
mySlider:Unlock()
```

## Contoh

### Slider integer (Volume 0–100)

Ingat untuk mengonversi argumen string sebelum memakainya sebagai angka.

```lua
myTab:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        local n = tonumber(value) -- value berupa string seperti "50"
        print("Volume:", n)
    end
})
```

### Slider float (Step pecahan)

`Step` `0.1` membuat slider masuk ke mode float, sehingga callback menerima nilai seperti `"0.50"`.

```lua
myTab:Slider({
    Title = "Brightness",
    Step = 0.1,
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(value)
        print("Brightness:", value) -- "0.50"
    end
})
```

### Persistensi dengan Flag

```lua
myTab:Slider({
    Title = "Slider",
    Flag = "SliderTest",
    Step = 1,
    Value = { Min = 20, Max = 120, Default = 70 },
    Callback = function(value)
        print(value)
    end
})
```

### Kontrol lewat kode

```lua
local speed = myTab:Slider({
    Title = "Speed",
    Value = { Min = 0, Max = 100, Default = 20 },
    Callback = function(value) print(value) end
})

speed:Set(60)     -- pindahkan handle ke 60
speed:SetMax(150) -- lebarkan rentang
```
