# Code

A syntax-styled code block with a built-in copy button. Perfect for showing snippets, commands or install lines that users can copy in one click.

## Basic usage

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Code({
    Title = "Lua",
    Code = "print('Hello, world!')"
})
```

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `nil` | Label shown above the code block. |
| `Code` | `string` | `nil` | The code text to display. |
| `OnCopy` | `function` | `nil` | Runs after the code is copied to the clipboard. |

::: info Copying
The copy button writes to the **executor clipboard**. If copying fails, a notification is shown instead.
:::

## Methods

### `Code:SetCode(code)`

Replaces the displayed code with a new string.

```lua
mySnippet:SetCode("print('updated!')")
```

### `Code:Destroy()`

Removes the code block from its container.

```lua
mySnippet:Destroy()
```

## Examples

### A Lua snippet block

```lua
myTab:Code({
    Title = "Lua",
    Code = "print('Hello from Group 1')"
})
```

### Running a callback after copy

```lua
myTab:Code({
    Title = "Install",
    Code = 'loadstring(game:HttpGet("https://example.com/script.lua"))()',
    OnCopy = function()
        print("Copied!")
    end
})
```

### Updating the code with `SetCode`

Keep the returned module and swap its contents later.

```lua
local snippet = myTab:Code({
    Title = "Example",
    Code = "print('initial')"
})

myTab:Button({
    Title = "Update code",
    Callback = function()
        snippet:SetCode("print('updated!')")
    end
})
```
