# Mulai Cepat

Bangun menu ANUI pertama Anda langkah demi langkah. Di akhir Anda akan punya window dengan satu tab berisi toggle, button, dan slider, plus sebuah notifikasi — sebuah script lengkap yang berfungsi.

## 1. Muat ANUI

Setiap script diawali dengan memuat library ke dalam local bernama `ANUI`.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## 2. Buat window

`ANUI:CreateWindow` mengembalikan objek `Window` sebagai tempat Anda menambahkan segalanya. `Folder` adalah lokasi penyimpanan konfigurasi dan key di disk.

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})
```

Lihat [Konfigurasi Window](/id/guide/window-configuration) untuk semua opsi.

## 3. Tambahkan tab

Tab menampung elemen Anda. Buat satu dengan `Window:Tab`.

```lua
local Main = Window:Tab({ Title = "Main", Icon = "house" })
```

## 4. Tambahkan elemen

Tambahkan elemen dengan memanggil method pada tab. Perhatikan argumen yang diterima setiap callback:

- **Toggle** — callback menerima `boolean` (state on/off yang baru).
- **Button** — callback **tidak menerima argumen**.
- **Slider** — callback menerima **string terformat** (nilai yang diformat sesuai step-nya).

```lua
Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Callback = function(state) -- state: boolean
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "Do something",
    Callback = function() -- tanpa argumen
        print("Button clicked")
    end
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) -- value: string terformat
        print("Walk Speed:", value)
    end
})
```

## 5. Tampilkan notifikasi

`ANUI:Notify` memunculkan toast. Field ikonnya adalah `Icon`; field teks isinya adalah `Content`.

```lua
ANUI:Notify({
    Title = "Hello!",
    Content = "Welcome to ANUI",
    Icon = "bell",
    Duration = 3,
})
```

## Script lengkap

Menggabungkan semuanya:

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})

local Main = Window:Tab({ Title = "Main", Icon = "house" })

Main:Toggle({
    Title = "Auto Farm",
    Desc = "Automatically farm coins",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "Do something",
    Callback = function()
        print("Button clicked")
    end
})

Main:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value)
        print("Walk Speed:", value)
    end
})

ANUI:Notify({
    Title = "Hello!",
    Content = "Welcome to ANUI",
    Icon = "bell",
    Duration = 3,
})
```

## Langkah berikutnya

- Konfigurasikan window sepenuhnya di [Konfigurasi Window](/id/guide/window-configuration).
- Jelajahi setiap elemen di [Ikhtisar Elemen](/id/elements/).
