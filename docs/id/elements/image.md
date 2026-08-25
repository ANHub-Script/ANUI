# Image

Elemen gambar mandiri dengan kontrol atas rasio aspek, penskalaan, dan radius sudut. Gunakan untuk menampilkan banner, ikon, pratinjau, atau seni dekoratif apa pun di dalam tab.

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "16:9",
})
```

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Image` | `string` | `""` | Aset gambar yang ditampilkan: `rbxassetid://…` (atau URL bila executor mendukung). |
| `AspectRatio` | `string` | `"16:9"` | Rasio lebar-ke-tinggi, mis. `"16:9"` atau `"4:3"`. Set ke `"native"`, `"original"`, atau `"auto"` untuk memakai dimensi asli gambar. |
| `Radius` | `number` | `—` | Radius sudut elemen gambar. |
| `ScaleType` | `string` | `"Fit"` | Cara gambar mengisi frame-nya: `"Fit"` menampilkannya utuh (letterbox); `"Crop"` mengisi penuh lalu memotong. |
| `Crop` | `boolean` | `false` | Pintasan untuk `ScaleType = "Crop"`. |
| `Native` / `KeepAspect` | `boolean` | `false` | Memakai ukuran asli gambar / mempertahankan rasio aspek aslinya. |
| `NativeSize` | `Vector2` | `—` | Ukuran piksel asli eksplisit, dipakai bersama penanganan native/aspek. |
| `Height` | `number` | `—` | Tinggi tetap dalam piksel; lebar mengikuti rasio aspek. |
| `Size` | `UDim2` | `—` | Ukuran eksplisit yang menimpa `AspectRatio` dan `Height`. |

## Method

### `Image:SetSize(size)`

Mengubah ukuran gambar. Berikan `UDim2` untuk ukuran eksplisit, atau sebuah angka untuk mengatur tinggi piksel tetap.

```lua
img:SetSize(UDim2.fromOffset(200, 200))
img:SetSize(120) -- tinggi dalam piksel
```

### `Image:SetScaleType(type)`

Mengatur tipe skala: `"Fit"` atau `"Crop"`.

```lua
img:SetScaleType("Crop")
```

### `Image:SetAspectRatio(ratio)`

Mengatur rasio aspek. Menerima string rasio seperti `"16:9"`, atau `"native"` / `"original"` / `"auto"` untuk rasio asli gambar.

```lua
img:SetAspectRatio("4:3")
img:SetAspectRatio("native")
```

### `Image:GetNativeSize()`

Mengembalikan ukuran piksel asli gambar sebagai `Vector2`.

```lua
local size = img:GetNativeSize()
print(size.X, size.Y)
```

### `Image:Destroy()`

Menghapus elemen gambar.

```lua
img:Destroy()
```

## Contoh

### Gambar 16:9 lewat asset id

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "16:9",
    Radius = 12,
})
```

### Gambar rasio native

Biarkan gambar mempertahankan proporsi aslinya dengan mengatur `AspectRatio = "native"`.

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "native",
})
```

### Persegi yang dipotong lewat Size

Beri gambar `Size` persegi eksplisit lalu potong agar mengisi penuh frame.

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    Size = UDim2.fromOffset(120, 120),
    ScaleType = "Crop", -- atau Crop = true
})
```
