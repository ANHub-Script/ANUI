---
layout: home
title: ANUI
titleTemplate: Library UI Roblox Tingkat Lanjut

hero:
  name: ANUI
  text: Library UI Roblox Tingkat Lanjut
  tagline: Library UI modern dan kaya fitur untuk executor script Roblox. Bangun menu yang indah dan siap-mobile hanya dalam beberapa baris.
  image:
    src: /logo.svg
    alt: Logo ANUI
  actions:
    - theme: brand
      text: Mulai
      link: /id/guide/introduction
    - theme: alt
      text: Instalasi
      link: /id/guide/installation
    - theme: alt
      text: Lihat di GitHub
      link: https://github.com/ANHub-Script/ANUI

features:
  - icon: 🧩
    title: 15+ Elemen
    details: Button, toggle, slider, dropdown, colorpicker, keybind, input, blok kode, dan banyak lagi — semua yang Anda butuhkan untuk membangun menu lengkap.
    link: /id/elements/
    linkText: Jelajahi elemen
  - icon: 🎨
    title: 26 Tema Bawaan
    details: Tersedia Dark, Light, Dracula, Tokyo Night, Nord, Gruvbox, dan 20 lainnya — atau daftarkan palet Anda sendiri dengan satu panggilan.
    link: /id/features/themes
    linkText: Panduan tema
  - icon: 💾
    title: Konfigurasi & Flag
    details: Simpan state elemen apa pun ke disk hanya dengan satu Flag, dan pulihkan otomatis saat script Anda dijalankan lagi.
    link: /id/features/config-and-flags
    linkText: Konfigurasi & flag
  - icon: 🔑
    title: Sistem Key
    details: Kunci script Anda dengan key, didukung Luarmor, Platoboost, dan PandaDevelopment — atau validator kustom buatan Anda sendiri.
    link: /id/features/key-system
    linkText: Sistem key
  - icon: 🔔
    title: Notifikasi & Dialog
    details: Notifikasi toast, dialog modal, dan popup langsung tersedia — lengkap dengan ikon, tombol, dan progress bar.
    link: /id/features/notifications
    linkText: Notifikasi
  - icon: ⏱️
    title: Scheduler Pintar
    details: Loop bebas-drift dengan pengaman anti-tumpang-tindih yang otomatis berhenti ketika window ditutup.
    link: /id/features/scheduler
    linkText: Scheduler & loop
---

## Pratinjau singkat

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "Hub Saya",
    Author = "oleh kamu",
    Icon = "rbxassetid://84366761557806",
    Folder = "HubSaya",
})

local Main = Window:Tab({ Title = "Utama", Icon = "house" })

Main:Toggle({
    Title = "Auto Farm",
    Desc = "Farming koin otomatis",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "Beri notifikasi",
    Callback = function()
        ANUI:Notify({ Title = "Halo!", Content = "Selamat datang di ANUI", Icon = "bell", Duration = 3 })
    end
})
```

Itu adalah menu lengkap yang berfungsi. Lanjut ke [Mulai Cepat](/id/guide/getting-started) untuk membangunnya langkah demi langkah.
