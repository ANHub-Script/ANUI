# Group

Container yang menata anak-anaknya secara **horizontal** alih-alih menumpuknya vertikal. Elemen interaktif berbagi lebar yang tersedia secara merata, sedangkan [Space](/id/elements/space) atau [Divider](/id/elements/divider) mempertahankan lebar tetapnya. Seperti Tab, Group menyediakan semua method pembuat elemen.

## Penggunaan dasar

Buat group dengan `Tab:Group({})`, lalu tambahkan elemen ke container yang dikembalikan:

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

local row = myTab:Group({})
row:Button({ Title = "Save", Callback = function() end })
row:Button({ Title = "Load", Callback = function() end })
```

Kedua button tampil berdampingan, masing-masing mengisi separuh baris.

## Konfigurasi

`Group` tidak menerima konfigurasi apa pun — panggil `Tab:Group({})` dengan tabel kosong.

## Membuat elemen di dalam group

Group adalah container, jadi setiap method pembuat elemen (`Group:Button`, `Group:Toggle`, `Group:Dropdown`, …) bekerja padanya persis seperti pada Tab — lihat [Ringkasan Elemen](/id/elements/). Setiap anak interaktif mendapat bagian lebar baris yang sama; anak `Space` dan `Divider` mempertahankan lebar tetapnya alih-alih meregang.

::: tip
Group cocok dipadukan dengan label [Paragraph](/id/elements/paragraph) yang ditempatkan tepat di atasnya — gunakan paragraph sebagai judul yang menjelaskan baris kontrol di bawahnya.
:::

## Contoh

### Sebaris button

```lua
local buttons = myTab:Group({})
buttons:Button({
    Title = "Primary",
    Color = Color3.fromHex("#305dff"),
    Icon = "mouse-pointer-click",
    Callback = function() end,
})
buttons:Button({ Title = "Secondary", Icon = "mouse", Callback = function() end })
buttons:Button({ Title = "Locked", Icon = "lock", Locked = true, Callback = function() end })
```

### Dua dropdown berdampingan

```lua
myTab:Paragraph({ Title = "Dropdowns Group", Desc = "Two dropdowns grouped." })

local dropdowns = myTab:Group({})
dropdowns:Dropdown({
    Title = "Dropdown 1",
    Values = { "A", "B", "C" },
    Value = "A",
    Callback = function(v) print("Dropdown 1:", v) end,
})
dropdowns:Dropdown({
    Title = "Dropdown 2",
    Values = { { Title = "X", Desc = "First" }, { Title = "Y" }, { Title = "Z" } },
    SearchBarEnabled = true,
    Value = "Y",
    Callback = function(v) print("Dropdown 2:", v) end,
})
```

### Dua slider berdampingan

```lua
myTab:Paragraph({ Title = "Sliders Group", Desc = "Two sliders grouped." })

local sliders = myTab:Group({})
sliders:Slider({
    Title = "Volume",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(v) print("Volume:", v) end,
})
sliders:Slider({
    Title = "Brightness",
    Step = 0.1,
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(v) print("Brightness:", v) end,
})
```

::: info
Group adalah container tata letak, jadi ia tidak mewarisi perilaku interaktif shared-base — perilaku tersebut milik elemen yang Anda tempatkan di dalamnya.
:::
