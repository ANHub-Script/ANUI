# 安装

ANUI 只需一行代码即可安装 —— 无需下载，也没有依赖。把它粘贴到脚本顶部，你就可以开始构建了。

## 安装方法

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

### 这一行做了什么

- `game:HttpGet(url)` 从 GitHub 以字符串形式下载最新的 ANUI 源码。
- `loadstring(...)` 把这段字符串编译成一个可运行的函数。
- 结尾的 `()` 调用该函数，并返回 ANUI 库的表。
- 结果被保存在名为 `ANUI` 的 local 变量中 —— 本站的每个示例都在这个变量上调用方法（`ANUI:CreateWindow`、`ANUI:Notify` 等等）。

::: tip 开发期间的 cache-busting
有些执行器会缓存 `HttpGet` 的响应，所以在反复调试时你可能一直拿到旧的构建。追加一个随机查询字符串即可强制获取最新副本：

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v="..math.random()))()
```

发布到生产环境时请去掉 `?v=`... 部分，让响应能够正常被缓存。
:::

## 确认加载成功

打印版本号，确认库已经可用：

```lua
print(ANUI.Version)
```

如果看到一个版本号字符串，说明 ANUI 已正确加载。

::: warning 执行器要求
ANUI 需要一个支持 `loadstring` 和 `game:HttpGet` 的执行器。

保存配置以及密钥系统的 `SaveKey` 选项还需要文件相关的全局函数 `readfile`、`writefile`、`isfile` 和 `makefolder`。没有它们 UI 依然可以工作 —— 只是无法把数据保存到磁盘。
:::

## 疑难排查

::: details ANUI 为 `nil` / "attempt to call a nil value"
`loadstring` 或 `HttpGet` 什么都没有返回。请确认你的执行器同时支持这两者，并且没有屏蔽 `raw.githubusercontent.com` 域名。加上上面演示的 cache-busting `?v=` 查询参数后再运行一次。
:::

::: details HttpGet 被禁用 / 请求失败
有些执行器会用一个开关来控制 HTTP 请求。请在执行器中启用 HTTP / HttpGet，然后重新运行脚本。
:::

::: details 屏幕上什么都没有出现
仅仅加载库并不会渲染任何东西。请确认你确实创建了窗口 —— 参见[快速上手](/zh/guide/getting-started)。
:::

---

下一页：[快速上手](/zh/guide/getting-started)
