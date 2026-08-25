# Divider

Pemisah tipis yang membagi elemen secara visual. Pada Tab atau Section ia dirender sebagai garis horizontal; di dalam [Group](/id/elements/group) ia dirender sebagai garis vertikal di antara kolom-kolom group.

## Penggunaan dasar

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Button({ Title = "Save", Callback = function() end })
myTab:Divider()
myTab:Button({ Title = "Load", Callback = function() end })
```

## Konfigurasi

`Divider` tidak menerima konfigurasi apa pun — panggil `Tab:Divider()` tanpa argumen.

::: info Vertikal di dalam Group
Karena [Group](/id/elements/group) menata anak-anaknya secara horizontal, Divider yang ditempatkan di dalamnya digambar sebagai pemisah **vertikal** antar kolom, bukan garis horizontal.
:::

## Contoh

### Memisahkan kelompok kontrol

```lua
myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })

myTab:Divider()

myTab:Button({ Title = "Reset", Callback = function() end })
```

### Divider vertikal antar kolom

```lua
local row = myTab:Group({})
row:Button({ Title = "Accept", Callback = function() end })
row:Divider()
row:Button({ Title = "Decline", Callback = function() end })
```

::: info
Divider murni dekoratif — ia bukan elemen interaktif, sehingga tidak memiliki konfigurasi maupun method.
:::
