# Tema

ANUI hadir dengan 26 tema bawaan dan juga memungkinkan Anda mendaftarkan tema sendiri. Anda memilih tema saat window dibuat, menggantinya saat runtime, membaca tema yang aktif, serta bereaksi terhadap perubahan — semuanya lewat method tingkat atas pada `ANUI`.

## Menetapkan tema saat pembuatan

Berikan key tema ke `CreateWindow` melalui field `Theme`. Nilai defaultnya adalah `"Dark"`.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Theme = "Midnight", -- key bawaan apa pun, atau nama tema kustom
})
```

Lihat [Konfigurasi Window](/id/guide/window-configuration) untuk opsi window selengkapnya.

## Mengganti tema saat runtime

### `ANUI:SetTheme(name)`

Menerapkan tema berdasarkan key-nya dan mengembalikan tabel tema, atau `nil` bila key tidak dikenal.

```lua
if not ANUI:SetTheme("Emerald") then
    warn("Key tema tidak dikenal")
end
```

## Membaca tema aktif

### `ANUI:GetCurrentTheme()`

Mengembalikan **nama tampilan** tema yang aktif (misalnya `"Monokai Pro"`, bukan key `MonokaiPro`).

```lua
print(ANUI:GetCurrentTheme()) --> "Midnight"
```

### `ANUI:GetThemes()`

Mengembalikan tabel berisi semua tema terdaftar, dengan key berupa key tema — termasuk tema yang Anda tambahkan lewat `AddTheme`.

```lua
for key, theme in pairs(ANUI:GetThemes()) do
    print(key, "->", theme.Name)
end
```

## Bereaksi terhadap perubahan tema

### `ANUI:OnThemeChange(callback)`

Mendaftarkan handler yang berjalan setiap kali `SetTheme` menerapkan sebuah tema. Callback menerima **satu argumen: key tema** yang diterapkan — string yang sama dengan yang Anda berikan ke `SetTheme` (mis. `"Dark"`).

```lua
ANUI:OnThemeChange(function(themeKey)
    print("Tema berubah ke:", themeKey)
end)
```

::: info Hanya satu handler
`OnThemeChange` menyimpan satu handler saja — memanggilnya lagi akan mengganti handler sebelumnya. Daftarkan satu fungsi dan lakukan percabangan di dalamnya jika beberapa bagian skrip Anda perlu ikut bereaksi.
:::

## Tema bawaan

Berikan **key** ke `Theme` / `SetTheme`. Nama tampilan (yang dikembalikan `GetCurrentTheme`) hanya berbeda dari key pada segelintir tema.

| Key | Nama tampilan |
| --- | --- |
| `Dark` | Dark *(default)* |
| `Light` | Light |
| `Rose` | Rose |
| `Plant` | Plant |
| `Red` | Red |
| `Indigo` | Indigo |
| `Sky` | Sky |
| `Violet` | Violet |
| `Amber` | Amber |
| `Emerald` | Emerald |
| `Midnight` | Midnight |
| `Crimson` | Crimson |
| `MonokaiPro` | Monokai Pro |
| `CottonCandy` | Cotton Candy |
| `Rainbow` | Rainbow |
| `NordTheme` | Nord |
| `DraculaTheme` | Dracula |
| `TokyoNight` | Tokyo Night |
| `OneDark` | One Dark |
| `Gruvbox` | Gruvbox |
| `SolarizedDark` | Solarized Dark |
| `MaterialDark` | Material Dark |
| `CyberpunkPink` | Cyberpunk Pink |
| `OceanBlue` | Ocean Blue |
| `NeonGreen` | Neon Green |
| `SoftPastel` | Soft Pastel |

## Tema kustom

### `ANUI:AddTheme(theme)`

Mendaftarkan sebuah tema, dengan key berupa `Name`-nya, lalu mengembalikannya. Setelah ditambahkan, terapkan dengan `SetTheme(name)`.

Sebuah tema adalah tabel berisi key warna. Sembilan di antaranya wajib; `Toggle` dan `Checkbox` bersifat opsional. Setiap warna adalah `Color3` — biasanya dibuat dengan `Color3.fromHex("#…")`.

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `Name` | `string` | — | Nama tema yang unik. Inilah key yang Anda berikan ke `SetTheme`. |
| `Accent` | `Color3` | — | Warna aksen / panel utama. |
| `Dialog` | `Color3` | — | Background dialog dan popup. |
| `Outline` | `Color3` | — | Warna garis tepi / stroke. |
| `Text` | `Color3` | — | Warna teks utama. |
| `Placeholder` | `Color3` | — | Warna teks placeholder / redup. |
| `Background` | `Color3` | — | Warna background window. |
| `Button` | `Color3` | — | Warna background button. |
| `Icon` | `Color3` | — | Warna pewarnaan ikon. |
| `Toggle` | `Color3` | *(opsional)* | Warna toggle saat "on". |
| `Checkbox` | `Color3` | *(opsional)* | Warna checkbox saat "checked". |

```lua
ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
    Toggle      = Color3.fromHex("#22d3ee"),
    Checkbox    = Color3.fromHex("#0ea5e9"),
})

ANUI:SetTheme("Oceanic")
```

::: tip
Tema yang Anda tambahkan dengan `AddTheme` langsung muncul di `GetThemes()` dan bisa dipilih seperti tema bawaan lainnya.
:::

## Gradient

### `ANUI:Gradient(stops, props)`

Membangun tabel data gradient dari sekumpulan color stop. `stops` menggunakan key berupa **string posisi** dari `"0"` sampai `"100"` (persen sepanjang gradient); setiap stop berbentuk `{ Color = Color3, Transparency = number }` — `Transparency` bersifat opsional dan defaultnya `0`. `props` adalah tabel opsional yang digabungkan ke hasil, misalnya `{ Rotation = 45 }`.

```lua
local sunset = ANUI:Gradient({
    ["0"]   = { Color = Color3.fromHex("#40c9ff") },
    ["50"]  = { Color = Color3.fromHex("#8b5cf6") },
    ["100"] = { Color = Color3.fromHex("#e81cff") },
}, {
    Rotation = 45,
})
```

::: warning Minimal dua stop
Sebuah gradient memerlukan **dua atau lebih** stop. Memberikan kurang dari itu akan memunculkan error.
:::

Gradient bisa dipakai di mana pun library menerima data gradient — paling sering pada field `TitleGradient` dan `DescGradient` milik elemen:

```lua
myTab:Button({
    Title = "Gradient Title",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Callback = function() end,
})
```

Gradient bahkan bisa menggerakkan warna tema — tema bawaan `Rainbow` didefinisikan dengan gradient alih-alih nilai `Color3` datar.

## Blur acrylic

### `ANUI:ToggleAcrylic(enabled)`

Menyalakan atau mematikan blur acrylic di belakang window. Ini hanya berpengaruh bila window dibuat dengan `Acrylic = true`; jika tidak, method ini tidak melakukan apa pun.

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Acrylic = true,
})

ANUI:ToggleAcrylic(true)  -- aktifkan blur
ANUI:ToggleAcrylic(false) -- matikan blur
```

## Font

### `ANUI:SetFont(fontId)`

Mengatur font global yang dipakai di seluruh UI.

```lua
ANUI:SetFont("rbxassetid://12898095208")
```

## Contoh lengkap

Mendaftarkan tema kustom, menerapkannya, menyediakan pemilih tema, dan mencatat setiap perubahan.

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:AddTheme({
    Name        = "Oceanic",
    Accent      = Color3.fromHex("#0e2a3b"),
    Dialog      = Color3.fromHex("#0b2231"),
    Outline     = Color3.fromHex("#7dd3fc"),
    Text        = Color3.fromHex("#f0f9ff"),
    Placeholder = Color3.fromHex("#5a8aa8"),
    Background  = Color3.fromHex("#071722"),
    Button      = Color3.fromHex("#0284c7"),
    Icon        = Color3.fromHex("#38bdf8"),
})

local Window = ANUI:CreateWindow({
    Title = "Theme Demo",
    Theme = "Oceanic",
    Acrylic = true,
})

local Tab = Window:Tab({ Title = "Appearance", Icon = "palette" })

Tab:Paragraph({
    Title = "Theme switcher",
    TitleGradient = ANUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#40c9ff") },
        ["100"] = { Color = Color3.fromHex("#e81cff") },
    }),
    Desc = "Pilih tema di bawah ini.",
})

Tab:Dropdown({
    Title = "Theme",
    Values = { "Dark", "Light", "Midnight", "Oceanic" },
    Value = "Oceanic",
    Callback = function(name)
        ANUI:SetTheme(name)
    end,
})

ANUI:OnThemeChange(function(themeKey)
    print("Key tema aktif:", themeKey)
    print("Nama tampilan:", ANUI:GetCurrentTheme())
end)
```
