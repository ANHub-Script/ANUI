# Scheduler & Loop

ANUI menyertakan scheduler loop terpusat: satu thread runner menggerakkan semua loop, bukan satu `task.spawn` per loop. Loop bersifat bebas-drift dan terjaga dari tumpang-tindih, dan pembungkus (wrapper) yang terikat window akan berhenti sendiri secara otomatis saat window ditutup atau dihancurkan.

## Loop window (disarankan)

Untuk hampir semua kebutuhan, gunakan method loop pada `Window`. Method ini berjalan di scheduler milik window, sehingga **berhenti otomatis saat window ditutup atau dihancurkan** — tanpa perlu pembersihan manual.

### `Window:Loop(key, interval, callback, options?)`

Menjalankan `callback` setiap `interval` detik. `key` memberi nama loop; menggunakan ulang key yang sama akan mengganti loop lama. Callback **tidak menerima argumen**.

```lua
Window:Loop("heartbeat", 1, function()
    print("tick")
end)
```

`options` adalah tabel opsional:

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `requireReady` | `boolean` | `false` | Hanya jalankan callback selama window "siap" (terbuka dan belum dihancurkan). |
| `predicate` | `function` | `nil` | Gerbang tambahan — callback hanya berjalan ketika ini mengembalikan `true`. |

### `Window:StatusLoop(key, interval, callback)`

Sebuah `Loop` dengan `requireReady` sudah aktif — ideal untuk menyegarkan teks di layar, karena akan berhenti sementara saat window disembunyikan. Callback **tidak menerima argumen**.

```lua
Window:StatusLoop("clock", 1, function()
    -- `clock` adalah Paragraph yang dibuat sebelumnya
    clock:SetDesc(os.date("%X"))
end)
```

### `Window:ManagedLoop(key, interval, predicate, callback)`

Loop mentah dengan `predicate` milik Anda sendiri dan tanpa gerbang window-ready. Setiap kali loop jatuh tempo, `predicate` dipanggil; `callback` hanya berjalan jika ia mengembalikan `true`. Keduanya **tidak menerima argumen**.

```lua
Window:ManagedLoop("guarded", 0.5, function()
    return workspace:FindFirstChild("Boss") ~= nil
end, function()
    -- hanya berjalan selama Boss ada
end)
```

### Mengendalikan loop

- `Window:StopLoop(key)` — hentikan satu loop berdasarkan key.
- `Window:StopAllLoops()` — hentikan semua loop pada window.
- `Window:IsLoopRunning(key)` — `true` jika ada loop dengan key tersebut terdaftar.
- `Window:GetActiveLoopCount()` — jumlah loop yang terdaftar.

### Koneksi & kesiapan

- `Window:AddConnection(connection)` — titipkan sebuah `RBXScriptConnection` ke window agar otomatis diputus saat destroy.
- `Window:DisconnectAll()` — putus semua koneksi yang Anda titipkan.
- `Window:IsReady()` — `true` selama window terbuka dan belum dihancurkan.

```lua
Window:AddConnection(
    game:GetService("RunService").Heartbeat:Connect(function()
        -- ...
    end)
)
```

## Scheduler mandiri

Butuh loop yang tidak terikat window? Buat scheduler Anda sendiri dengan `ANUI:Scheduler`. Anda mengendalikan kapan ia berhenti lewat `ShouldStop`, dan menggerbangi loop "ready" lewat `IsReady`.

### `ANUI:Scheduler(config)`

| Field | Type | Default | Deskripsi |
| --- | --- | --- | --- |
| `ShouldStop` | `function → boolean` | `nil` | Kembalikan `true` untuk mematikan runner dan membuang semua loop. |
| `IsReady` | `function → boolean` | `nil` | Gerbang untuk loop yang dibuat dengan `requireReady`. Default-nya selalu-siap. |
| `MinWait` | `number` | `0.01` | Interval / tick terkecil yang diizinkan. |
| `IdleWait` | `number` | `0.05` | Tidur terlama ketika tidak ada yang jatuh tempo. |

```lua
local sched = ANUI:Scheduler({
    ShouldStop = function() return not _G.MyScriptRunning end,
    IsReady = function() return game:IsLoaded() end,
})
```

Method scheduler:

### `sched:Start(key, interval, predicate, callback)`

Loop mentah. Saat jatuh tempo, `predicate` dijalankan; `callback` hanya berjalan jika ia mengembalikan `true`.

### `sched:Loop(key, interval, callback, options?)`

Sama seperti `Window:Loop`. `options` menerima `requireReady` dan `predicate`.

### `sched:StatusLoop(key, interval, callback)`

Sebuah `Loop` dengan `requireReady` aktif.

### Method lain

- `sched:Stop(key)` — hentikan satu loop.
- `sched:StopAll()` — hentikan semua loop.
- `sched:IsRunning(key)` — apakah ada loop terdaftar di bawah key ini?
- `sched:GetActiveCount()` — jumlah loop yang aktif.
- `sched:AddConnection(connection)` — lacak sebuah koneksi untuk dibersihkan nanti.
- `sched:DisconnectAll()` — putus semua koneksi yang dilacak.
- `sched:Destroy()` — hentikan runner, buang semua loop, dan putus semua koneksi.

::: tip Bebas-drift & aman dari tumpang-tindih
Setiap loop menjadwalkan jalannya berikutnya dari waktu target, bukan dari saat callback selesai — jadi loop 1 detik tetap berirama stabil 1 detik seberapa lama pun pekerjaannya. Selain itu, penjaga `busy` per-loop mencegah callback yang lambat menumpuk dengan dirinya sendiri: jika satu proses masih berjalan saat jadwal berikutnya tiba, tick tersebut dilewati.
:::

## Contoh: toggle auto-farm

Sebuah toggle menyalakan dan mematikan `Window:Loop` yang mengerjakan tugasnya, plus `Window:StatusLoop` yang menjaga sebuah Paragraph tetap terbarui. Keduanya berhenti dengan rapi saat window ditutup atau dihancurkan.

```lua
local Window = ANUI:CreateWindow({ Title = "Farm Hub" })
local Tab = Window:Tab({ Title = "Farm", Icon = "sword" })

local status = Tab:Paragraph({
    Title = "Auto Farm",
    Desc = "Status: idle",
})

local farming = false
local kills = 0

Tab:Toggle({
    Title = "Auto Farm",
    Value = false,
    Callback = function(on)
        farming = on

        if on then
            -- kerjakan tugasnya ~2x per detik
            Window:Loop("autofarm", 0.5, function()
                kills += 1
                -- ... aksi farming Anda di sini ...
            end)

            -- segarkan paragraph 4x per detik, hanya selama UI terbuka
            Window:StatusLoop("autofarm-status", 0.25, function()
                status:SetDesc(("Status: running · %d kills"):format(kills))
            end)
        else
            Window:StopLoop("autofarm")
            Window:StopLoop("autofarm-status")
            status:SetDesc("Status: idle")
        end
    end,
})
```

Lihat [Konfigurasi Window](/id/guide/window-configuration) untuk selengkapnya soal siklus hidup window.
