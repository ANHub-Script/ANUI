# Installation

ANUI installs with a single line — no downloads, no dependencies. Paste it at the top of your script and you are ready to build.

## Install

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua"))()
```

### What this does

- `game:HttpGet(url)` downloads the latest ANUI source from GitHub as a string.
- `loadstring(...)` compiles that string into a runnable function.
- The trailing `()` calls it, returning the ANUI library table.
- The result is stored in a local named `ANUI` — every example on this site calls methods on this variable (`ANUI:CreateWindow`, `ANUI:Notify`, and so on).

::: tip Cache-busting during development
Some executors cache `HttpGet` responses, so you may keep getting an old build while iterating. Append a random query string to force a fresh copy:

```lua
local ANUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ANHub-Script/ANUI/refs/heads/main/dist/main.lua?v="..math.random()))()
```

Drop the `?v=`... part for production so the response can be cached normally.
:::

## Verify it loaded

Print the version to confirm the library is available:

```lua
print(ANUI.Version)
```

If you see a version string, ANUI loaded correctly.

::: warning Executor requirements
ANUI needs an executor that supports `loadstring` and `game:HttpGet`.

Config saving and the key system's `SaveKey` option additionally require the file globals `readfile`, `writefile`, `isfile` and `makefolder`. Without them the UI still works — only on-disk persistence is unavailable.
:::

## Troubleshooting

::: details ANUI is `nil` / "attempt to call a nil value"
`loadstring` or `HttpGet` returned nothing. Confirm your executor supports both, and that it is not blocking the `raw.githubusercontent.com` domain. Re-run after adding the cache-busting `?v=` query shown above.
:::

::: details HttpGet is disabled / requests fail
Some executors gate HTTP requests behind a setting. Enable HTTP / HttpGet in your executor, then run the script again.
:::

::: details Nothing appears on screen
Loading the library alone does not render anything. Make sure you actually create a window — see the [Quick Start](/guide/getting-started).
:::

---

Next: [Quick Start](/guide/getting-started)
