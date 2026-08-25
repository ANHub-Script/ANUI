# 🎨 ANUI - Advanced Roblox UI Library

<div align="center">

**A modern, feature-rich UI library for Roblox with premium design and complete documentation**

[![Beta](https://img.shields.io/badge/Status-Beta-yellow)](https://github.com/ANHub-Script/ANUI)
[![Documentation](https://img.shields.io/badge/Docs-Complete-green)](https://ANHub-Script.github.io/ANUI/)
[![Discord](https://img.shields.io/badge/Discord-Join-7289da)](https://discord.gg/bUkCZvmrpH)

</div>

---

> [!WARNING] 
> **ANUI is currently in Beta**
> 
> This project is still under active development. Bugs, issues, and unstable features may occur. We're constantly working on improvements, so please be patient and report any problems you encounter.

---

## ✨ Features

### 🎯 **19 Premium Components**
Complete set of UI components for building professional Roblox interfaces:
- **Containers:** Window, Tab, Section, Group
- **Inputs:** Input, Textarea, Slider, Keybind, ColorPicker, Dropdown
- **Interactive:** Button, Toggle, Checkbox
- **Display:** Code, Image, Video, Paragraph, Divider, Space
- **Feedback:** Notify, Dialog

### 🎨 **Premium Visual Design**
- ✨ Gradient animations & glow effects
- 🌊 Smooth transitions & micro-animations
- 💎 Glassmorphism & modern aesthetics
- 🎭 3D transforms & hover effects
- 🌈 Dynamic particle backgrounds
- 📱 Fully responsive design

### 📚 **Complete Documentation**
- 📖 **Comprehensive API Reference** - All 19 components fully documented
- 🎓 **Step-by-step Tutorial** - From beginner to advanced
- 🗂️ **File Structure Overview** - Understanding the codebase
- ✅ **Testing Checklist** - Quality assurance guide
- 🎨 **Interactive Examples** - Live code demonstrations
- 📱 **Mobile-friendly** - Responsive documentation design

---

## 🚀 Quick Start

### Installation
```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/main_example.lua'))()
```

### Basic Example
```lua
local ANUI = loadstring(game:HttpGet("YOUR_ANUI_URL"))()

local Window = ANUI:CreateWindow({
    Title = "ANUI Example",
    Author = "Your Name",
    Icon = "rbxassetid://YOUR_ICON_ID"
})

local Tab = Window:Tab({
    Title = "Main",
    Icon = "home"
})

Tab:Button({
    Title = "Click Me!",
    Callback = function()
        print("Button clicked!")
    end
})
```

---

## 📖 Documentation

### 🌐 **Online Documentation**
- **[Official Docs Website](https://ANHub-Script.github.io/ANUI/)** - Live documentation
- **[Installation Guide](https://ANHub-Script.github.io/ANUI/guide/installation)** - Get started quickly

---

## 🧩 Component List

| Component | Description | Documentation |
|-----------|-------------|---------------|
| **Window** | Main container | [Docs](#) |
| **Tab** | Navigation tabs | [Docs](#) |
| **Toggle** | Switch/Checkbox | [Docs](#) |
| **Button** | Clickable button | [Docs](#) |
| **Dropdown** | Selection menu | [Docs](#) |
| **Input** | Text input field | [Docs](#) |
| **Slider** | Value slider | [Docs](#) |
| **Keybind** | Key binding | [Docs](#) |
| **ColorPicker** | Color selection | [Docs](#) |
| **Section** | Collapsible group | [Docs](#) |
| **Group** | Horizontal layout | [Docs](#) |
| **Code** | Code display | [Docs](#) |
| **Image** | Image display | [Docs](#) |
| **Video** | Video player | [Docs](#) |
| **Paragraph** | Text content | [Docs](#) |
| **Divider** | Visual separator | [Docs](#) |
| **Space** | Spacing control | [Docs](#) |
| **Notify** | Notifications | [Docs](#) |
| **Dialog** | Modal dialogs | [Docs](#) |

---

## 🔗 Links

- 💬 **[Discord Server](https://discord.gg/bUkCZvmrpH)** - Community support
- 📚 **[Example Script](/main_example.lua)** - Live demo (WIP)
- 🐛 **[Report Issues](https://github.com/ANHub-Script/ANUI/issues)** - Bug reports
- 💡 **[Feature Requests](https://github.com/ANHub-Script/ANUI/issues)** - Suggest improvements

---

## 🙏 Credits

- **[Dawid-Scripts](https://github.com/dawid-scripts)** - Original inspiration
- **[Lucide Icons](https://github.com/lucide-icons/lucide)** - Icon library
- **[Footagesus WindUI](https://github.com/Footagesus/WindUI)** - Base framework

---

## 📄 License

This project is in **Beta** and actively maintained. Feel free to use, modify, and contribute!

---

<div align="center">

**Made with ❤️ by the ANUI Team**

[Documentation](https://ANHub-Script.github.io/ANUI/) • [Discord](https://discord.gg/bUkCZvmrpH) • [GitHub](https://github.com/ANHub-Script/ANUI)

</div>