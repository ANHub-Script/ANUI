# Category Pages

`Category` Element를 사용하면 하나의 Tab 안에서 여러 콘텐츠 페이지를 전환할 수 있습니다.

```lua
local Main = Window:Tab({
    Title = "Main",
    Icon = "layout-dashboard",
})

local Category = Main:Category({
    Options = { "Combat", "Visual", "Settings" },
    Default = "Combat",
    Callback = function(option)
        print("Selected:", option)
    end,
})
```

Category를 사용하면 별도의 Tab을 계속 늘리지 않고 관련 기능을 하나의 화면에 묶을 수 있습니다.

자세한 `Category` 옵션은 [영문 Category 문서](../../elements/category)를 참고하세요.
