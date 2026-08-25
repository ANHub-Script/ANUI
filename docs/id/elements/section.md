# Section

Container yang bisa diciutkan (collapsible) yang ditempatkan di dalam sebuah tab. Seperti Tab, Section menyediakan semua method pembuat elemen, jadi Anda menambahkan elemen anak ke dalamnya dan elemen-elemen itu tampil terkelompok di bawah sebuah header yang bisa dibuka dan diciutkan.

::: info Dua konsep "Section" yang berbeda
Halaman ini mendokumentasikan **elemen konten** `Tab:Section({...})` — sebuah container collapsible yang ditempatkan *di dalam* tab.

Ini tidak berhubungan dengan `Window:Section({ Title = ... })`, yang membuat **header section di sidebar** untuk mengelompokkan tab. Untuk yang itu, lihat [Tab & Section](/id/guide/tabs-and-sections).
:::

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

local combat = myTab:Section({ Title = "Combat" })

combat:Toggle({ Title = "God Mode", Callback = function(state) end })
combat:Button({ Title = "Kill Aura", Callback = function() end })
```

::: tip
Section baru bisa diciutkan setelah memiliki setidaknya satu elemen anak — Section kosong tidak punya konten untuk diciutkan.
:::

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Title` | `string` | `"Section"` | Label header. Mendukung [token rich-text](/id/elements/#rich-text-di-title-desc), termasuk token `{icon}` inline. |
| `Icon` | `string` | `nil` | Ikon header: nama Lucide atau `rbxassetid://…`. |
| `Image` | `string` | `nil` | Aset gambar header (alternatif dari `Icon`). |
| `IconSize` | `number` | `20` | Ukuran ikon header, dalam piksel. |
| `IconThemed` | `boolean` | `false` | Mewarnai ikon dengan warna tema saat ini. |
| `InlineIcon` | `boolean` | `true` | Merender ikon sebaris dengan teks judul. |
| `TextSize` | `number` | `19` | Ukuran teks judul header. |
| `TextXAlignment` | `string` | `"Left"` | Perataan horizontal judul header. |
| `TextTransparency` | `number` | `0.05` | Transparansi teks judul header. |
| `FontWeight` | `Enum.FontWeight` \| `string` | `SemiBold` | Ketebalan font judul header. |
| `Box` | `boolean` | `false` | Membungkus section dalam kotak berbingkai. |
| `Opened` | `boolean` | `false` | Mulai dalam keadaan terbuka, bukan terciut. |
| `HeaderSize` | `number` | `42` | Tinggi baris header, dalam piksel. |
| `HeaderPadding` | `number` | `8` | Padding dalam baris header. |
| `ChevronSize` | `number` | `20` | Ukuran chevron buka/ciut. |

## Method

Setiap method pembuat elemen (`Section:Button`, `Section:Toggle`, `Section:Slider`, …) tersedia pada Section, persis seperti pada Tab — lihat [Ringkasan Elemen](/id/elements/). Method khusus Section ada di bawah.

### `Section:SetTitle(text)`

Memperbarui label header.

```lua
combat:SetTitle("Combat (active)")
```

### `Section:SetIcon(icon)`

Mengatur ikon header (nama Lucide atau `rbxassetid://…`).

```lua
combat:SetIcon("swords")
```

### `Section:SetIconSize(size)`

Mengatur ukuran ikon header, dalam piksel.

```lua
combat:SetIconSize(24)
```

### `Section:GetIcon()`

Mengembalikan ikon header saat ini.

```lua
print(combat:GetIcon())
```

### `Section:Open()` / `Section:Close()`

Membuka atau menciutkan section.

```lua
combat:Open()
combat:Close()
```

### `Section:Destroy()`

Menghapus section beserta elemen anaknya.

```lua
combat:Destroy()
```

## Contoh

### Ikon, judul dengan token, dan terbuka secara default

```lua
local stats = myTab:Section({
    Title = "{swords} Combat Stats",
    Icon = "swords",
    Opened = true,
})

stats:Slider({ Title = "Damage", Value = { Min = 0, Max = 100, Default = 50 } })
stats:Toggle({ Title = "Auto Attack", Callback = function(state) end })
```

### Buka dan ciutkan lewat kode

```lua
local advanced = myTab:Section({ Title = "Advanced" })
advanced:Toggle({ Title = "Verbose Logging" })

advanced:Open()  -- buka
advanced:Close() -- ciutkan
```

::: info
Karena Section adalah container, ia tidak mewarisi perilaku interaktif shared-base (penguncian, highlight, dan sebagainya) — perilaku tersebut milik elemen yang Anda tempatkan *di dalamnya*.
:::
