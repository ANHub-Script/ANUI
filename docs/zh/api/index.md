# API 速查表

所有内容都在一页里。这是覆盖整个 ANUI 接口面的密集快速参考 —— 顶层调用、Window 与 Tab 的方法、每个元素，以及各项功能的入口。想看完整细节请点开对应链接。

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

## `ANUI`（顶层）

库对象本身上的方法与字段。

| Call | 用途 |
| --- | --- |
| `ANUI:CreateWindow(config)` → `Window` | 创建窗口（只能存在一个）。 |
| `ANUI:Notify(config)` → notification | 显示一条 toast 通知。 |
| `ANUI:SetNotificationLower(bool)` | 把通知移到屏幕下方。 |
| `ANUI:SetFont(fontId)` | 设置全局 UI 字体。 |
| `ANUI:OnThemeChange(fn)` | 每当主题改变时运行 `fn`。 |
| `ANUI:AddTheme(theme)` → theme | 注册自定义主题（以它的 `.Name` 作为键）。 |
| `ANUI:SetTheme(name)` → theme \| `nil` | 按名称切换主题。 |
| `ANUI:GetThemes()` | 返回所有已注册的主题。 |
| `ANUI:GetCurrentTheme()` | 返回当前激活的主题。 |
| `ANUI:GetTransparency()` | 返回当前的透明度数值。 |
| `ANUI:GetWindowSize()` | 返回当前的窗口尺寸。 |
| `ANUI:Localization(config)` | 配置翻译。 |
| `ANUI:SetLanguage(lang)` | 切换语言（需要已启用本地化）。 |
| `ANUI:ToggleAcrylic(bool)` | 开启或关闭 acrylic 模糊效果。 |
| `ANUI:Gradient(stops, props)` → gradient | 构建一个渐变数据表（stops 以 `"0"`..`"100"` 为键）。 |
| `ANUI:Popup(config)` → `Popup` | 打开一个模态弹窗。 |
| `ANUI:Scheduler(config)` → `Scheduler` | 创建一个独立的循环调度器。 |
| `ANUI.Version` | 库的版本字符串（字段，不是方法）。 |

## Window 方法

由 `ANUI:CreateWindow` 返回。按用途分组；signature 写在反引号里。

**标签页与容器**

| Method | 用途 |
| --- | --- |
| `Window:Tab(config)` | 添加一个标签页（容纳元素的侧边栏页面）。 |
| `Window:Section(config)` | 添加一个用于给标签页分组的侧边栏分区。 |
| `Window:SelectTab(index)` | 按索引切换到某个标签页。 |
| `Window:Divider()` | 在侧边栏中添加一条分隔线。 |
| `Window:Tag(config)` | 给窗口添加一个小标签/徽章（例如版本号）。 |

**对话框**

| Method | 用途 |
| --- | --- |
| `Window:Dialog({ Title, Content, Icon, Width, Buttons })` | 打开一个模态对话框。每个按钮的形式是 `{ Title, Icon, Callback, Variant }`（`Width` 默认为 `320`）。 |

**生命周期与回调**

| Method | 用途 |
| --- | --- |
| `Window:Open()` / `Window:Close()` / `Window:Toggle()` | 显示、隐藏或切换窗口。 |
| `Window:Destroy()` | 销毁窗口并清理。 |
| `Window:OnOpen(fn)` / `Window:OnClose(fn)` / `Window:OnDestroy(fn)` | 在对应事件发生时运行 `fn`。 |

**外观**

| Method | 用途 |
| --- | --- |
| `Window:SetTitle(t)` / `Window:SetAuthor(t)` | 更新标题 / 副标题。 |
| `Window:SetIconSize(n \| UDim2)` | 调整顶栏图标的大小。 |
| `Window:SetBackgroundImage(id)` / `Window:SetBackgroundImageTransparency(v)` | 设置背景图片及其透明度。 |
| `Window:SetBackgroundTransparency(v)` / `Window:ToggleTransparency(bool)` | 调整或切换窗口透明度。 |
| `Window:SetToTheCenter()` | 把窗口重新居中到屏幕中间。 |
| `Window:GetUIScale()` / `Window:SetUIScale(v)` | 读取或设置 UI 缩放。 |
| `Window:IsResizable(bool)` | 启用或禁用缩放尺寸。 |

**侧边栏**

| Method | 用途 |
| --- | --- |
| `Window:CollapseSidebar()` / `Window:ExpandSidebar()` / `Window:ToggleSidebar(state?)` | 折叠、展开或切换侧边栏。 |

**切换按键**

| Method | 用途 |
| --- | --- |
| `Window:SetToggleKey(keycode)` | 设置显示/隐藏的热键（一个 `Enum.KeyCode`）。 |

**锁定**

| Method | 用途 |
| --- | --- |
| `Window:LockAll()` / `Window:UnlockAll()` | 锁定或解锁所有元素。 |
| `Window:GetLocked()` / `Window:GetUnlocked()` | 列出已锁定 / 未锁定的元素。 |

**顶栏**

| Method | 用途 |
| --- | --- |
| `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` | 添加一个自定义顶栏按钮。 |
| `Window:DisableTopbarButtons({ names })` | 按名称隐藏内置的顶栏按钮。 |

**打开按钮**

| Method | 用途 |
| --- | --- |
| `Window:EditOpenButton(config)` | 编辑悬浮的打开按钮。 |

**循环与调度器**

| Method | 用途 |
| --- | --- |
| `Window:Loop(key, interval, fn, opts?)` | 每隔 `interval` 秒运行 `fn`。 |
| `Window:StatusLoop(key, interval, fn)` | 专门用于更新状态文本的循环。 |
| `Window:ManagedLoop(key, interval, predicate, fn)` | 仅在 `predicate` 返回 true 时才运行的循环。 |
| `Window:StopLoop(key)` / `Window:StopAllLoops()` | 停止某一个循环，或停止全部循环。 |
| `Window:IsLoopRunning(key)` / `Window:GetActiveLoopCount()` | 查询循环状态。 |
| `Window:AddConnection(conn)` / `Window:DisconnectAll()` | 跟踪并清理连接。 |
| `Window:IsReady()` | 窗口是否已完成初始化。 |

## Tab 方法

| Method | 用途 |
| --- | --- |
| `Tab:Select()` | 把这个标签页设为当前激活的标签页。 |
| `Tab:ScrollToTheElement(index)` | 按索引滚动到某个元素。 |
| `Tab:LockAll()` / `Tab:UnlockAll()` | 锁定或解锁该标签页中的所有元素。 |
| `Tab:GetLocked()` / `Tab:GetUnlocked()` | 列出该标签页中已锁定 / 未锁定的元素。 |
| `Tab:ReserveHeader(height, config)` | 在标签页顶部预留一块固定的头部区域。 |

::: info
Tab 同样暴露**每一个元素创建方法** —— `Tab:Button{}`、`Tab:Toggle{}`、`Tab:Slider{}` 等等。`Section` 和 `Group` 是拥有相同元素方法的容器。
:::

## 元素快速参考

每个元素一行。回调参数就是你的 `Callback` 函数会收到的内容。

| 元素 | Signature | 主要配置 | 回调参数 |
| --- | --- | --- | --- |
| [Button](/zh/elements/button) | `Tab:Button{}` | `Callback`、`Icon` | 无 |
| [Toggle](/zh/elements/toggle) | `Tab:Toggle{}` | `Value`、`Type` | `boolean` |
| [Slider](/zh/elements/slider) | `Tab:Slider{}` | `Value { Min, Max, Default }`、`Step` | 格式化后的 `string` |
| [Dropdown](/zh/elements/dropdown) | `Tab:Dropdown{}` | `Values`、`Multi` | 被选中的值（单选）/ 数组（多选） |
| [Input](/zh/elements/input) | `Tab:Input{}` | `Placeholder`、`Type` | `string` |
| [Keybind](/zh/elements/keybind) | `Tab:Keybind{}` | `Value`（按键名称） | 按键名称 `string` |
| [Colorpicker](/zh/elements/colorpicker) | `Tab:Colorpicker{}` | `Default`、`Transparency` | `(Color3, transparency)` |
| [Paragraph](/zh/elements/paragraph) | `Tab:Paragraph{}` | `Title`、`Desc`、`Images` | — |
| [Code](/zh/elements/code) | `Tab:Code{}` | `Code`、`OnCopy` | — |
| [Section](/zh/elements/section) | `Tab:Section{}` | `Title`、`Opened` | — |
| [Divider](/zh/elements/divider) | `Tab:Divider()` | — | — |
| [Space](/zh/elements/space) | `Tab:Space{}` | `Columns` | — |
| [Image](/zh/elements/image) | `Tab:Image{}` | `Image`、`AspectRatio` | — |
| [Group](/zh/elements/group) | `Tab:Group{}` | ——（容器） | — |
| [Category](/zh/elements/category) | `Tab:Category{}` | `Options`、`Default` | 被选中的选项名称（`string`） |

## 功能快速参考

| 功能 | 入口调用 | 文档 |
| --- | --- | --- |
| 通知 | `ANUI:Notify{}` | [通知](/zh/features/notifications) |
| 对话框与弹窗 | `Window:Dialog{}` · `ANUI:Popup{}` | [对话框与弹窗](/zh/features/dialogs-and-popups) |
| 配置与 Flag | `Window.ConfigManager` · `Flag = "..."` | [配置与 Flag](/zh/features/config-and-flags) |
| 密钥系统 | `ANUI:CreateWindow{ KeySystem = {...} }` | [密钥系统](/zh/features/key-system) |
| 主题 | `ANUI:SetTheme(name)` · `ANUI:AddTheme{}` | [主题与外观](/zh/features/themes) |
| 本地化 | `ANUI:Localization{}` · `ANUI:SetLanguage(lang)` | [本地化](/zh/features/localization) |
| 调度器与循环 | `ANUI:Scheduler{}` · `Window:Loop(...)` | [调度器与循环](/zh/features/scheduler) |
