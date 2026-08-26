---
layout: home
title: ANUI
titleTemplate: 高機能な Roblox UI ライブラリ

hero:
  name: ANUI
  text: 高機能な Roblox UI ライブラリ
  tagline: Roblox のスクリプトエグゼキュータ向けのモダンで多機能な UI ライブラリ。ほんの数行で、美しくモバイル対応のメニューが作れます。
  image:
    src: /logo.svg
    alt: ANUI ロゴ
  actions:
    - theme: brand
      text: はじめる
      link: /ja/guide/introduction
    - theme: alt
      text: インストール
      link: /ja/guide/installation
    - theme: alt
      text: GitHub で見る
      link: https://github.com/ANHub-Script/ANUI

features:
  - icon: 🧩
    title: 15 以上のエレメント
    details: Button、toggle、slider、dropdown、colorpicker、keybind、input、コードブロックなど —— 本格的なメニューを組み立てるのに必要なものがすべて揃っています。
    link: /ja/elements/
    linkText: エレメントを見る
  - icon: 🎨
    title: 26 種の組み込みテーマ
    details: Dark、Light、Dracula、Tokyo Night、Nord、Gruvbox ほか 20 種を標準搭載 —— 独自のパレットも 1 回の呼び出しで登録できます。
    link: /ja/features/themes
    linkText: テーマガイド
  - icon: 💾
    title: 設定と Flag
    details: Flag を 1 つ指定するだけで、どのエレメントの状態もディスクに保存され、次回スクリプト実行時に自動で復元されます。
    link: /ja/features/config-and-flags
    linkText: 設定と Flag
  - icon: 🔑
    title: キーシステム
    details: スクリプトをキーで保護。Luarmor、Platoboost、PandaDevelopment に標準対応 —— 独自の検証ロジックも使えます。
    link: /ja/features/key-system
    linkText: キーシステム
  - icon: 🔔
    title: 通知とダイアログ
    details: 表現力の高いトースト通知、モーダルダイアログ、ポップアップが最初から使えます。アイコン、ボタン、プログレスバーにも対応。
    link: /ja/features/notifications
    linkText: 通知
  - icon: ⏱️
    title: スマートなスケジューラー
    details: ドリフトのないループと、ループごとの多重実行ガード。ウィンドウを閉じると自動でクリーンアップされます。
    link: /ja/features/scheduler
    linkText: スケジューラーとループ
---

## クイックプレビュー

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "マイ Hub",
    Author = "作成者: あなた",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})

local Main = Window:Tab({ Title = "メイン", Icon = "house" })

Main:Toggle({
    Title = "Auto Farm",
    Desc = "コインを自動で集めます",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "通知する",
    Callback = function()
        ANUI:Notify({ Title = "こんにちは！", Content = "ANUI へようこそ", Icon = "bell", Duration = 3 })
    end
})
```

これだけで完全に動くメニューです。[クイックスタート](/ja/guide/getting-started)で、順を追って作ってみましょう。
