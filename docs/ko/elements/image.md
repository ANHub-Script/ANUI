# Image

가로세로 비율, 크기 조절, 모서리 반경을 제어할 수 있는 독립 이미지 요소입니다. 탭 안에 배너, 아이콘, 미리보기 또는 장식 이미지를 표시할 때 사용합니다.

## 기본 사용법

```lua
local myTab = Window:Tab({ Title = "Main", Icon = "house" })

myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "16:9",
})
```

## 구성

| 필드 | 형식 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `Image` | `string` | `""` | 표시할 이미지 에셋입니다. `rbxassetid://…` 또는 실행기가 지원하는 URL을 사용합니다. |
| `AspectRatio` | `string` | `"16:9"` | 너비 대 높이 비율입니다(예: `"16:9"`, `"4:3"`). 실제 이미지 크기는 `"native"`, `"original"`, `"auto"`를 사용합니다. |
| `Radius` | `number` | `—` | 이미지 요소의 모서리 반경입니다. |
| `ScaleType` | `string` | `"Fit"` | 프레임을 채우는 방식입니다. `"Fit"`은 여백을 남겨 맞추고 `"Crop"`은 채운 뒤 잘라냅니다. |
| `Crop` | `boolean` | `false` | `ScaleType = "Crop"`의 단축 설정입니다. |
| `Native` / `KeepAspect` | `boolean` | `false` | 이미지의 원래 크기를 사용하거나 실제 비율을 유지합니다. |
| `NativeSize` | `Vector2` | `—` | 원본/비율 처리와 함께 사용할 명시적 원본 픽셀 크기입니다. |
| `Height` | `number` | `—` | 픽셀 단위 고정 높이입니다. 너비는 가로세로 비율을 따릅니다. |
| `Size` | `UDim2` | `—` | `AspectRatio`와 `Height`보다 우선하는 명시적 크기입니다. |

## 메서드

### `Image:SetSize(size)`

이미지 크기를 변경합니다. 명시적 크기에는 `UDim2`를, 고정 픽셀 높이에는 숫자를 전달하세요.

```lua
img:SetSize(UDim2.fromOffset(200, 200))
img:SetSize(120) -- height in pixels
```

### `Image:SetScaleType(type)`

크기 조절 방식을 `"Fit"` 또는 `"Crop"`으로 설정합니다.

```lua
img:SetScaleType("Crop")
```

### `Image:SetAspectRatio(ratio)`

가로세로 비율을 설정합니다. `"16:9"` 같은 비율 문자열이나, 실제 이미지 비율을 뜻하는 `"native"` / `"original"` / `"auto"`를 받습니다.

```lua
img:SetAspectRatio("4:3")
img:SetAspectRatio("native")
```

### `Image:GetNativeSize()`

이미지의 원본 픽셀 크기를 `Vector2`로 반환합니다.

```lua
local size = img:GetNativeSize()
print(size.X, size.Y)
```

### `Image:Destroy()`

이미지 요소를 제거합니다.

```lua
img:Destroy()
```

## 예제

### 에셋 ID로 16:9 이미지 표시

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "16:9",
    Radius = 12,
})
```

### 원본 비율 이미지

`AspectRatio = "native"`를 설정하면 이미지의 실제 비율을 유지합니다.

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "native",
})
```

### Size를 사용한 정사각형 자르기

이미지에 정사각형 `Size`를 명시하고 프레임을 채우도록 잘라냅니다.

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    Size = UDim2.fromOffset(120, 120),
    ScaleType = "Crop", -- or Crop = true
})
```
