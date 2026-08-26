# 简介

ANUI（Advanced Roblox UI Library）是一个面向 Roblox 脚本执行器的现代化、功能丰富的 UI 库。它让你只用几行 Lua 就能搭建出干净、适配移动端的菜单 —— 窗口、标签页、toggle、slider、dropdown 等等。

## 什么是 ANUI？

ANUI 会在任意 Roblox 体验之上渲染一个可拖动、可调整大小的浮动窗口。你只需声明式地描述菜单 —— 创建窗口、添加标签页、往里面放入元素 —— 布局、主题、输入、动画和持久化都由 ANUI 替你处理。

因为它通过一行 `loadstring` 从 HTTP 加载，所以无需安装、也无需打包：粘贴一行代码，菜单立即可用。

## 你可以构建什么

- 带有整齐标签页和侧边栏分区的功能中心与作弊菜单
- 通过[配置与 Flag](/zh/features/config-and-flags) 让状态跨会话保留的设置面板
- 使用内置[密钥系统](/zh/features/key-system)进行加锁的脚本
- 包含个人资料、徽章、通知和对话框的丰富仪表盘

## 功能亮点

- 15+ 个[元素](/zh/elements/) —— button、toggle、slider、dropdown、colorpicker、keybind、input、代码块等等
- [26 款内置主题](/zh/features/themes)，还可使用你自己的自定义配色
- [配置与 Flag](/zh/features/config-and-flags)，可将任意元素的状态保存到磁盘
- 支持 Luarmor、Platoboost 和 PandaDevelopment 提供方的[密钥系统](/zh/features/key-system)
- [通知](/zh/features/notifications)以及[对话框与弹窗](/zh/features/dialogs-and-popups)
- 面向多语言菜单的[本地化](/zh/features/localization)
- 用于托管循环的无漂移[调度器](/zh/features/scheduler)
- [适配移动端的缩放与 acrylic 模糊](/zh/guide/window-configuration)

## 环境要求

ANUI 运行在 Roblox 脚本执行器内部。你的执行器必须支持：

- `loadstring` 和 `game:HttpGet` —— 加载库所必需
- `readfile`、`writefile`、`isfile`、`makefolder` —— 仅在保存配置和密钥时需要

::: info 只能有一个窗口
同一时间只能存在一个窗口。第二次调用 `ANUI:CreateWindow` 会发出警告并返回 `nil`。
:::

## 致谢

- 基于 **Footagesus 的 WindUI**
- 图标来自 [Lucide](https://lucide.dev)
- 感谢 Dawid-Scripts

## 链接

- GitHub：[github.com/ANHub-Script/ANUI](https://github.com/ANHub-Script/ANUI)
- Discord：[discord.gg/bUkCZvmrpH](https://discord.gg/qN47S3mKZA)
- YouTube：[@ANHubRoblox](https://www.youtube.com/@ANHubRoblox)

---

下一页：[安装](/zh/guide/installation)
