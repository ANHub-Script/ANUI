# 标签页与分区

标签页是菜单的各个页面；侧边栏分区将这些标签页归入带标签的组。本页介绍如何用 `Window:Tab{}` 创建标签页，以及用 `Window:Section{}` 对它们进行分组。

::: info 两种不同的「Section」概念
ANUI 中有两个都叫「Section」的东西 —— 请不要混淆：

1. **`Window:Section({ Title = ... })`** 创建一个**侧边栏分区标题**，用来在侧边栏中对标签页进行分组。之后你调用 `Section:Tab({...})` 在它下面添加标签页。这正是本页所介绍的内容。
2. **`Tab:Section({...})`** 是一个**内容元素** —— 一个放置在标签页*内部*的可折叠容器。那个记录在[Section（元素）](/zh/elements/section)页面。
:::

## 创建标签页

用 `Window:Tab{}` 创建标签页。它返回一个 `Tab` 对象，你可以向其中添加元素。

```lua
local Main = Window:Tab({
    Title = "Main",
    Icon = "house",
    Desc = "Main controls", -- 悬停时显示的提示文字
})
```

### 标签页配置

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Tab"` | 标签页标签文字。 |
| `Desc` | `string` | — | 悬停标签页时显示的提示文字。 |
| `Icon` | `string` | — | 标签页图标（16px）：Lucide 名称或 `rbxassetid://…`。 |
| `Image` | `string` | — | 显示在标签页标题中的横幅图片（100px）。 |
| `IconThemed` | `boolean` | — | 用主题颜色为图标着色。 |
| `Locked` | `boolean` | — | 以锁定状态启动标签页。 |
| `ShowTabTitle` | `boolean` | — | 在内容标题中显示标签页的标题。 |
| `Profile` | `table` | — | 个人资料卡片配置（见下文）。 |
| `SidebarProfile` | `boolean` | — | 将个人资料渲染为侧边栏卡片，而非内容标题。 |

## 个人资料

一个标签页可以显示**个人资料** —— 一张带有头像、横幅、状态指示器和徽章按钮的卡片。传入一个 `Profile` 表：

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | — | 显示名称。 |
| `Desc` | `string` | — | 副标题 / 角色文字。 |
| `Avatar` | `string` | — | 头像图片。 |
| `Banner` | `string` | — | 横幅图片。 |
| `Status` | `boolean` | — | 显示状态指示器。 |
| `Badges` | `array` | — | `{ Icon, Title, Desc, Callback }` 徽章按钮列表。 |
| `Sticky` | `boolean` | `true` | 滚动时保持个人资料固定在顶部。 |

将 `SidebarProfile` 设为 `true` 可将个人资料渲染为侧边栏中的卡片；`false`（或省略）则在标签页内容中以大标题形式显示。

```lua
local Badges = {
    {
        Icon = "geist:logo-discord",
        Title = "Discord",
        Desc = "Join ANHUB Discord",
        Callback = function()
            setclipboard("https://discord.gg/qN47S3mKZA")
            ANUI:Notify({ Title = "Discord", Content = "Invite link copied!", Icon = "geist:logo-discord", Duration = 3 })
        end
    },
    {
        Icon = "youtube",
        Desc = "Subscribe to YouTube",
        Callback = function()
            setclipboard("https://www.youtube.com/@ANHubRoblox")
            ANUI:Notify({ Title = "YouTube", Content = "Channel link copied!", Icon = "youtube", Duration = 3 })
        end
    },
}

-- 侧边栏卡片（装饰性，渲染在侧边栏中）
Window:Tab({
    Profile = {
        Title = "AdityaNugraha",
        Desc = "Admin",
        Avatar = "rbxassetid://84366761557806",
        Banner = "rbxassetid://114772391775993",
        Status = true,
        Badges = Badges,
    },
    SidebarProfile = true,
})

-- 带有大型个人资料标题的普通标签页
local UserTab = Window:Tab({
    Title = "Example Profile Content",
    Icon = "user",
    Profile = {
        Title = "User Settings",
        Desc = "Manage your account details here",
        Avatar = "rbxassetid://84366761557806",
        Banner = "rbxassetid://114772391775993",
        Status = true,
        Badges = Badges,
    },
    SidebarProfile = false,
})

UserTab:Button({ Title = "Change Password", Callback = function() end })
UserTab:Button({ Title = "Log Out", Icon = "log-out", Callback = function() end })
```

## 用侧边栏分区对标签页分组

`Window:Section({ Title = ... })` 在侧边栏中创建一个带标签的标题。在返回的分区上调用 `:Tab{}` 即可在其下方添加标签页。

```lua
local ElementsSection = Window:Section({ Title = "Elements" })

local ToggleTab = ElementsSection:Tab({ Title = "Toggle", Icon = "arrow-left-right" })
local ButtonTab = ElementsSection:Tab({ Title = "Button", Icon = "mouse-pointer-click" })

local OtherSection = Window:Section({ Title = "Other" })
local DiscordTab = OtherSection:Tab({ Title = "Discord" })
```

## 标签页方法

- `Tab:Select()` —— 切换到此标签页。
- `Tab:ScrollToTheElement(index)` —— 将标签页滚动到指定元素。
- `Tab:LockAll()` —— 锁定标签页中的每一个元素。
- `Tab:UnlockAll()` —— 解锁标签页中的每一个元素。
- `Tab:GetLocked()` —— 获取标签页中已锁定的元素。
- `Tab:GetUnlocked()` —— 获取标签页中未锁定的元素。

每个元素创建方法（`Tab:Button`、`Tab:Toggle` 等）也可在标签页上使用 —— 参见[元素概览](/zh/elements/)。

## 通过代码选择标签页

通过窗口或标签页本身均可用代码切换标签页。`Window:SelectTab` 接收一个索引，每个标签页上都可以通过 `Tab.Index` 获取该索引：

```lua
Window:SelectTab(UpgradeTab.Index)
-- 或者，等效写法：
UpgradeTab:Select()
```

## 相关页面

- [元素概览](/zh/elements/) —— 所有可以放入标签页的内容。
- [Section（元素）](/zh/elements/section) —— 标签页内的可折叠容器。
