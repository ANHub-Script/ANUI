# 窗口配置

窗口是每个 ANUI 菜单的根。你只需用 `ANUI:CreateWindow{}` 创建它一次，并传入一个配置表。本页记录了所有字段，以及返回的 `Window` 对象上可用的方法。

::: info 只能有一个窗口
同一时间只能存在一个窗口。第二次调用 `ANUI:CreateWindow` 会发出警告并返回 `nil`。
:::

## 基本示例

```lua
local Window = ANUI:CreateWindow({
    Title = "My Hub",
    Author = "by you",
    Icon = "rbxassetid://84366761557806",
    Folder = "MyHub",
    Theme = "Dark",
})
```

## 配置

### Identity

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | — | 窗口标题文本。 |
| `Author` | `string` | — | 显示在标题下方的副标题。 |
| `Icon` | `string` | — | 窗口图标：Lucide 图标名或 `rbxassetid://…`。 |
| `IconSize` | `number` \| `UDim2` | `22` | 图标尺寸，单位为像素。 |
| `IconThemed` | `boolean` | — | 用主题的图标颜色为图标着色。 |

### Storage

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Folder` | `string` | — | 磁盘上的存储文件夹。设置它会启用[配置系统](/zh/features/config-and-flags)以及[密钥系统](/zh/features/key-system)的 `SaveKey` 选项。配置会写入 `ANUI/<Folder>/config/<name>.json`。 |

### Size & scaling

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Size` | `UDim2` | `580 × 460`（有上下限） | 窗口的初始尺寸。 |
| `MinSize` | `Vector2` | `850 × 560` | 调整大小时的最小尺寸。 |
| `MaxSize` | `Vector2` | `1050 × 560` | 调整大小时的最大尺寸。 |
| `Resizable` | `boolean` | `true` | 允许用户调整窗口大小。 |
| `AutoScale` | `boolean` | `true` | 自动缩放 UI（对移动端友好）。 |

### Appearance

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Theme` | `string` | `"Dark"` | 主题名称 —— 参见[主题](/zh/features/themes)。 |
| `Transparent` | `boolean` | `false` | 使用透明的窗口背景。 |
| `Acrylic` | `boolean` | `false` | 窗口后方的 acrylic 模糊。 |
| `Background` | `Color3` \| image id \| `"https://…"` \| `"video:…"` \| 渐变表 | — | 自定义窗口背景。 |
| `BackgroundImageTransparency` | `number` | `0` | 背景图片的透明度。 |
| `ShadowTransparency` | `number` | `0.7` | 窗口投影的透明度。 |
| `Radius` | `number` | `16` | 窗口圆角半径。 |
| `ElementsRadius` | `number` | — | 应用到元素上的圆角半径。 |
| `SideBarWidth` | `number` | `200` | 侧边栏宽度，单位为像素。 |
| `HidePanelBackground` | `boolean` | `false` | 隐藏内容面板的背景。 |
| `ScrollBarEnabled` | `boolean` | `false` | 显示内容区滚动条。 |

### Behavior

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `ToggleKey` | `Enum.KeyCode` | — | 用于显示 / 隐藏窗口的按键。 |
| `HideSearchBar` | `boolean` | `true` | 隐藏元素搜索栏。设为 `false` 可显示它。 |
| `NewElements` | `boolean` | `false` | 启用较新的元素样式。 |
| `IgnoreAlerts` | `boolean` | `false` | 屏蔽内置的 alert 弹窗。 |

### 子配置

以下字段接收各自的配置表，并在专门的页面中说明。

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `OpenButton` | `table` | — | 用于重新打开窗口的浮动按钮。参见[打开按钮](/zh/features/open-button)。 |
| `KeySystem` | `table` | — | 用密钥锁住菜单。参见[密钥系统](/zh/features/key-system)。 |
| `User` | `table` | — | 用户展示区块：`{ Enabled, Anonymous, Callback }`。 |

## 窗口方法

拿到 `Window` 之后，可以用这些方法在运行时控制它。

### Lifecycle

- `Window:Open()` —— 显示窗口。
- `Window:Close()` —— 隐藏窗口；返回一个带 `:Destroy()` 的对象。
- `Window:Destroy()` —— 永久移除窗口。
- `Window:Toggle()` —— 在打开与关闭之间切换。
- `Window:OnOpen(fn)` —— 每次窗口打开时运行 `fn`。
- `Window:OnClose(fn)` —— 每次窗口关闭时运行 `fn`。
- `Window:OnDestroy(fn)` —— 窗口被销毁时运行 `fn`。

### Appearance

- `Window:SetTitle(text)` —— 修改标题。
- `Window:SetAuthor(text)` —— 修改副标题。
- `Window:SetIconSize(n | UDim2)` —— 调整窗口图标的尺寸。
- `Window:SetBackgroundImage(id)` —— 更换背景图片。
- `Window:ToggleTransparency(bool)` —— 切换透明背景。
- `Window:SetUIScale(v)` —— 设置 UI 缩放比例（可用 `Window:GetUIScale()` 读回）。

### Sidebar

- `Window:CollapseSidebar()` —— 折叠侧边栏。
- `Window:ExpandSidebar()` —— 展开侧边栏。
- `Window:ToggleSidebar(state?)` —— 切换状态，或在给出 `state` 时强制设为该状态。

```lua
task.delay(1.0, function() Window:CollapseSidebar() end)
task.delay(3.0, function() Window:ExpandSidebar() end)
```

### Toggle key

- `Window:SetToggleKey(keycode)` —— 在运行时修改显示 / 隐藏所用的按键。

```lua
Window:SetToggleKey(Enum.KeyCode.G)
```

### Locks

- `Window:LockAll()` —— 锁定窗口中的每一个元素。
- `Window:UnlockAll()` —— 解锁窗口中的每一个元素。

### Topbar

- `Window:CreateTopbarButton(name, icon, callback, layoutOrder, iconThemed)` —— 向窗口顶栏添加一个按钮。
- `Window:DisableTopbarButtons({names})` —— 按名称禁用指定的顶栏按钮。

### Tag

`Window:Tag(cfg)` 会在窗口上添加一个带文字的小标签 —— 用来显示版本徽章很方便。

```lua
Window:Tag({ Title = "v" .. ANUI.Version, Icon = "github" })
```

### 对话框

`Window:Dialog{}` 会打开一个模态对话框。参见[对话框与弹窗](/zh/features/dialogs-and-popups)。

### 循环

`Window:Loop`、`Window:StatusLoop`、`Window:ManagedLoop` 及其同类方法会运行受托管的循环，窗口关闭或被销毁时它们会自动停止。参见[调度器与循环](/zh/features/scheduler)。

## 后续步骤

- 添加[标签页与分区](/zh/guide/tabs-and-sections)来整理你的菜单。
- 用[主题](/zh/features/themes)改变整体外观。
