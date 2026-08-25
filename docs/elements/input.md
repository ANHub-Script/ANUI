# Input

A text field for capturing string input — single-line (`"Input"`) or multi-line (`"Textarea"`). Its callback receives the current text whenever the field commits.

## Basic usage

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Input({
    Title = "Input",
    InputIcon = "mouse",
    Placeholder = "Enter Text...",
    Callback = function(text)
        print("Text:", text)
    end
})
```

## Configuration

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `Title` | `string` | `"Input"` | Main label. Supports [rich-text tokens](/elements/#rich-text-in-title-desc). |
| `Desc` | `string` | `nil` | Optional description under the title. |
| `Type` | `string` | `"Input"` | `"Input"` (single line) or `"Textarea"` (multi-line). |
| `Locked` | `boolean` | `false` | Renders a lock overlay and blocks interaction. |
| `InputIcon` | `string` \| `boolean` | `false` | Icon shown inside the input box. `false` for none. |
| `Placeholder` | `string` | `"Enter Text..."` | Greyed-out hint shown when the field is empty. |
| `Value` | `string` | `""` | Initial text. |
| `ClearTextOnFocus` | `boolean` | `false` | Clear the field automatically when it gains focus. |
| `Callback` | `function` | `nil` | Runs on commit. **Receives the current text as a string.** |
| `Buttons` | `table` | `nil` | Inline buttons rendered in the row. |
| `TitleGradient` | `table` | `nil` | Gradient applied to the title text. |
| `DescGradient` | `table` | `nil` | Gradient applied to the description text. |
| `Flag` | `string` | `nil` | Config persistence key. See [Config & Flags](/features/config-and-flags). |

::: info Callback signature
The `Callback` receives a single **string** — the field's current text. It fires when the field commits (focus is lost, or Enter is pressed for single-line inputs) and **once at initialization** with the starting `Value`.
:::

Inputs also inherit the [shared base](/elements/#shared-base) config and methods.

## Methods

### `Input:Set(value, isUserInput?)`

Sets the field's text to `value`. The optional `isUserInput` flag marks the change as user-originated.

```lua
myInput:Set("hello")
```

### `Input:SetPlaceholder(value)`

Updates the placeholder hint shown while the field is empty.

```lua
myInput:SetPlaceholder("Type a name...")
```

### `Input:Lock()` / `Input:Unlock()`

Locks or unlocks the input. A locked input shows an overlay and ignores typing.

```lua
myInput:Lock()
myInput:Unlock()
```

### Base methods

Inputs also support `:SetTitle`, `:SetDesc`, `:SetIcon`, `:Highlight`, `:SetButtons` / `:GetButton` / `:GetButtons` and `:Destroy` from the [shared base](/elements/#common-methods).

## Examples

### Basic with an icon

```lua
myTab:Input({
    Title = "Input",
    InputIcon = "mouse"
})
```

### Textarea (multi-line)

```lua
myTab:Input({
    Title = "Input Textarea",
    Type = "Textarea",
    InputIcon = "mouse"
})
```

### With a description

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input example"
})
```

### Locked

```lua
myTab:Input({
    Title = "Input",
    Desc = "Input example",
    Locked = true
})
```

### Persisting with a Flag

```lua
myTab:Input({
    Flag = "InputTest",
    Title = "Input",
    Desc = "Input Description",
    Value = "Default value",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter text...",
    Callback = function(input)
        print("Text entered:", input)
    end
})
```

The value is saved and restored automatically once a config is active — see [Config & Flags](/features/config-and-flags).
