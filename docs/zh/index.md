---
layout: home
title: ANUI
titleTemplate: 高级 Roblox UI 库

hero:
  name: ANUI
  text: 高级 Roblox UI 库
  tagline: 面向 Roblox 脚本执行器的现代化、功能丰富的 UI 库。只需几行代码，就能搭出一个精美且适配移动端的菜单。
  image:
    src: /logo.svg
    alt: ANUI 标志
  actions:
    - theme: brand
      text: 开始使用
      link: /zh/guide/introduction
    - theme: alt
      text: 安装
      link: /zh/guide/installation
    - theme: alt
      text: 在 GitHub 上查看
      link: https://github.com/ANHub-Script/ANUI

features:
  - icon: 🧩
    title: 15+ 元素
    details: Button、toggle、slider、dropdown、colorpicker、keybind、input、代码块等等 —— 构建一个功能完整的菜单所需的一切。
    link: /zh/elements/
    linkText: 浏览元素
  - icon: 🎨
    title: 26 款内置主题
    details: 内置 Dark、Light、Dracula、Tokyo Night、Nord、Gruvbox 以及另外 20 款主题 —— 也可以用一次调用注册你自己的配色。
    link: /zh/features/themes
    linkText: 主题指南
  - icon: 💾
    title: 配置与 Flag
    details: 只用一个 Flag 就能把任意元素的状态保存到磁盘，并在脚本下次运行时自动恢复。
    link: /zh/features/config-and-flags
    linkText: 配置与 Flag
  - icon: 🔑
    title: 密钥系统
    details: 用密钥锁住你的脚本，内置支持 Luarmor、Platoboost 和 PandaDevelopment —— 也可以使用你自己的验证逻辑。
    link: /zh/features/key-system
    linkText: 密钥系统
  - icon: 🔔
    title: 通知与对话框
    details: 精致的 toast 通知、模态对话框和弹窗开箱即用，并支持图标、按钮和进度条。
    link: /zh/features/notifications
    linkText: 通知
  - icon: ⏱️
    title: 智能调度器
    details: 无漂移循环，每个循环都自带防重入保护，并在窗口关闭时自动清理。
    link: /zh/features/scheduler
    linkText: 调度器与循环
---

## 快速预览

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

local Window = ANUI:CreateWindow({
    Title = "我的 Hub",
    Author = "由你制作",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
})

local Main = Window:Tab({ Title = "主页", Icon = "house" })

Main:Toggle({
    Title = "Auto Farm",
    Desc = "自动刷金币",
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

Main:Button({
    Title = "通知我",
    Callback = function()
        ANUI:Notify({ Title = "你好！", Content = "欢迎使用 ANUI", Icon = "bell", Duration = 3 })
    end
})
```

这就是一个完整可用的菜单。前往[快速上手](/zh/guide/getting-started)，一步一步把它搭建出来。
