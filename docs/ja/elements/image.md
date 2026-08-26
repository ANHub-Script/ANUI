# Image

アスペクト比、スケーリング、角の丸みを制御できる単独の画像エレメント。タブ内にバナー、アイコン、プレビュー、装飾用のアートなどを表示するのに使います。

## 基本的な使い方

```lua
local myTab = Window:Tab({ Title = "メイン", Icon = "house" })

myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "16:9",
})
```

## 設定

| フィールド | 型 | デフォルト | 説明 |
| --- | --- | --- | --- |
| `Image` | `string` | `""` | 表示する画像アセット: `rbxassetid://…`（エグゼキュータが対応していれば URL も可）。 |
| `AspectRatio` | `string` | `"16:9"` | 幅と高さの比率（例: `"16:9"`、`"4:3"`）。`"native"`、`"original"`、`"auto"` を指定すると画像の実寸を使います。 |
| `Radius` | `number` | `—` | 画像エレメントの角の丸み。 |
| `ScaleType` | `string` | `"Fit"` | 画像がフレームを埋める方法: `"Fit"` は内側にレターボックス表示、`"Crop"` は埋めて切り取ります。 |
| `Crop` | `boolean` | `false` | `ScaleType = "Crop"` のショートカット。 |
| `Native` / `KeepAspect` | `boolean` | `false` | 画像の実寸を使う / 本来のアスペクト比を保ちます。 |
| `NativeSize` | `Vector2` | `—` | 実寸のピクセルサイズを明示的に指定します。native / アスペクト比の処理と併用します。 |
| `Height` | `number` | `—` | 高さをピクセルで固定します。幅はアスペクト比に従います。 |
| `Size` | `UDim2` | `—` | 明示的なサイズ。`AspectRatio` と `Height` を上書きします。 |

## メソッド

### `Image:SetSize(size)`

画像をリサイズします。明示的なサイズには `UDim2` を、高さをピクセルで固定するには数値を渡します。

```lua
img:SetSize(UDim2.fromOffset(200, 200))
img:SetSize(120) -- 高さ（ピクセル）
```

### `Image:SetScaleType(type)`

スケールタイプを設定します: `"Fit"` または `"Crop"`。

```lua
img:SetScaleType("Crop")
```

### `Image:SetAspectRatio(ratio)`

アスペクト比を設定します。`"16:9"` のような比率の文字列、または画像本来の比率を使う `"native"` / `"original"` / `"auto"` を受け付けます。

```lua
img:SetAspectRatio("4:3")
img:SetAspectRatio("native")
```

### `Image:GetNativeSize()`

画像の実寸ピクセルサイズを `Vector2` で返します。

```lua
local size = img:GetNativeSize()
print(size.X, size.Y)
```

### `Image:Destroy()`

画像エレメントを削除します。

```lua
img:Destroy()
```

## 例

### アセット ID による 16:9 の画像

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "16:9",
    Radius = 12,
})
```

### 実寸比の画像

`AspectRatio = "native"` にすると、画像本来の比率を保てます。

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    AspectRatio = "native",
})
```

### Size による正方形の切り抜き

画像に正方形の `Size` を明示的に与え、フレームを埋めるように切り抜きます。

```lua
myTab:Image({
    Image = "rbxassetid://84366761557806",
    Size = UDim2.fromOffset(120, 120),
    ScaleType = "Crop", -- または Crop = true
})
```
