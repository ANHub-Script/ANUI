# Space

Spacer vertikal tak terlihat yang dipakai untuk memberi ruang antar elemen. Ia tidak merender apa pun — hanya menyediakan tinggi.

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Space()
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })
```

## Konfigurasi

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Columns` | `number` | `1` | Pengali tinggi. Tinggi spacer adalah `7 × Columns` piksel. |

::: info Tinggi
Tinggi dihitung sebagai `7 * Columns` piksel — default `Columns = 1` menyediakan 7px, `Columns = 2` menyediakan 14px, dan seterusnya.
:::

## Contoh

### Jarak lebih besar

```lua
myTab:Space({ Columns = 2 }) -- ruang vertikal 14px
```

### Memberi jarak pada tumpukan elemen

`Space()` di antara setiap kontrol adalah cara umum agar daftar yang panjang tidak terasa sempit.

```lua
myTab:Toggle({ Title = "Basic Toggle", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "Toggle with Description", Desc = "Extra detail", Callback = function(v) end })
myTab:Space()
myTab:Toggle({ Title = "Checkbox", Type = "Checkbox", Callback = function(v) end })
```

::: info
Space bukan elemen interaktif, sehingga tidak memiliki method — atur ukurannya lewat field `Columns` saat Anda membuatnya.
:::
