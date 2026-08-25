# Notifications

Toast 风格的通知，会从侧边滑入、显示标题与正文，并在倒计时结束后自动关闭。用 `ANUI:Notify{}` 创建一条 —— 无论窗口是否已打开，它都能在任何地方调用。

## 基本用法

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()

ANUI:Notify({
    Title = "Welcome",
    Content = "Thanks for using ANUI!",
    Icon = "bell",
    Duration = 5,
})
```

::: info 正文字段是 `Content`，不是 `Desc`
通知的正文文字用 `Content` 设置。`Notify` 没有 `Desc` 字段 —— 传入 `Desc` 不会显示任何正文。同样地，图像用 `Icon` 设置（Lucide 图标名称**或** `rbxassetid://…`），而不是 `Image`。
:::

## 配置

| Field | Type | Default | 描述 |
| --- | --- | --- | --- |
| `Title` | `string` | `"Notification"` | Toast 的标题文字。 |
| `Content` | `string` | `nil` | 显示在标题下方的正文文字。 |
| `Icon` | `string` | `nil` | 前置图标：Lucide 图标名称或 `rbxassetid://…`。（字段名是 `Icon`，不是 `Image`。） |
| `IconThemed` | `boolean` | `nil` | 用主题的图标颜色为图标着色。 |
| `Background` | `string` | `nil` | Toast 的背景图像 id。 |
| `BackgroundImageTransparency` | `number` | `nil` | 背景图像的透明度（`0` = 不透明）。 |
| `Duration` | `number` \| `false` | `5` | 自动关闭前的秒数；同时驱动进度条。falsy 值（`false`/`nil`/`0`）表示永不自动关闭。 |
| `Buttons` | `table` | `{}` | 会保存在对象上，但**不会渲染** —— 见下方的警告。 |

::: warning `Buttons` 会被保存但不会渲染
`Buttons` 字段会被接受并保存在通知对象上，但当前版本**不会**把它们绘制出来。如果需要交互式选项，请改用[对话框或弹窗](/zh/features/dialogs-and-popups)。
:::

关闭（X）按钮始终存在，因此即使 `Duration` 为 falsy，用户也可以手动关闭 toast。

## 返回的对象

`ANUI:Notify{}` 返回一个通知对象，它只有一个方法：

### `Notification:Close()`

立即关闭通知。适用于你想通过代码关闭的常驻 toast（`Duration = false`）。

```lua
local note = ANUI:Notify({
    Title = "Working…",
    Content = "This stays open until you close it.",
    Icon = "loader",
    Duration = false, -- falsy → 永不自动关闭
})

task.delay(3, function()
    note:Close()
end)
```

## `ANUI:SetNotificationLower(bool)`

当传入 `true` 时把通知堆栈移到屏幕下方，传入 `false` 时恢复默认位置。在初始化时调用一次即可。

```lua
ANUI:SetNotificationLower(true)
```

## 示例

### 一条简单的通知

```lua
ANUI:Notify({
    Title = "Saved",
    Content = "Your settings have been saved.",
})
```

### 带图标与自定义时长

```lua
ANUI:Notify({
    Title = "Discord",
    Content = "Invite link copied to clipboard!",
    Icon = "geist:logo-discord",
    Duration = 3,
})

ANUI:Notify({
    Title = "YouTube",
    Content = "Channel link copied!",
    Icon = "youtube",
    Duration = 3,
})
```

### 通过代码关闭的常驻通知

设置 `Duration = false` 让 toast 永不超时，保存返回的对象，完成后再调用 `:Close()`。

```lua
local loading = ANUI:Notify({
    Title = "Loading…",
    Content = "Fetching data from the server.",
    Icon = "loader",
    Duration = false,
})

-- 稍后，工作完成之后
loading:Close()
ANUI:Notify({
    Title = "Done",
    Content = "Data loaded successfully.",
    Icon = "check",
    Duration = 4,
})
```

::: details 带背景图像
```lua
ANUI:Notify({
    Title = "Event started",
    Content = "A limited-time event is now live.",
    Icon = "party-popper",
    Background = "rbxassetid://84366761557806",
    BackgroundImageTransparency = 0.4,
    Duration = 6,
})
```
:::
