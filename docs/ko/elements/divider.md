# Divider

요소를 시각적으로 나누는 얇은 구분선입니다. Tab 또는 Section에서는 가로선으로 표시되며, [Group](/ko/elements/group) 안에서는 열 사이의 세로선으로 표시됩니다.

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Button({ Title = "Save", Callback = function() end })
myTab:Divider()
myTab:Button({ Title = "Load", Callback = function() end })
```

## 구성

`Divider`에는 구성이 필요 없습니다. 인수 없이 `Tab:Divider()`를 호출하세요.

::: info Group 안의 세로 구분선
[Group](/ko/elements/group)은 자식 요소를 가로로 배치하므로, 그 안에 둔 Divider는 가로선이 아니라 열 사이의 **세로** 구분선으로 그려집니다.
:::

## 예제

### 컨트롤 그룹 나누기

```lua
myTab:Toggle({ Title = "Auto Farm", Callback = function(state) end })
myTab:Toggle({ Title = "Auto Sell", Callback = function(state) end })

myTab:Divider()

myTab:Button({ Title = "Reset", Callback = function() end })
```

### 열 사이의 세로 구분선

```lua
local row = myTab:Group({})
row:Button({ Title = "Accept", Callback = function() end })
row:Divider()
row:Button({ Title = "Decline", Callback = function() end })
```

::: info
Divider는 순수하게 장식용이며 대화형 요소가 아닙니다. 따라서 구성이나 메서드를 제공하지 않습니다.
:::
