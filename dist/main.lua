--[[
     _      ___         ____  ______
    | | /| / (_)__  ___/ / / / /  _/
    | |/ |/ / / _ \/ _  / /_/ // /  
    |__/|__/_/_//_/\_,_/\____/___/
    
    v1.0.200  |  2025-12-24  |  Roblox UI Library for scripts
    
    To view the source code, see the `src/` folder on the official GitHub repository.
    
    Author: ANHub-Script (Footages, .ftgs, oftgs)
    Github: https://github.com/ANHub-Script/ANUI
    Discord: https://discord.gg/cy6uMRmeZ
    License: MIT
]]


local a a={cache={}, load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}end return a.cache[b].c end}do function a.a()return{


White=Color3.new(1,1,1),
Black=Color3.new(0,0,0),

Dialog="Accent",

Background="Accent",
BackgroundTransparency=0,
Hover="Text",

WindowBackground="Background",

WindowShadow="Black",


WindowTopbarTitle="Text",
WindowTopbarAuthor="Text",
WindowTopbarIcon="Icon",
WindowTopbarButtonIcon="Icon",

TabBackground="Hover",
TabTitle="Text",
TabIcon="Icon",

ElementBackground="Text",
ElementTitle="Text",
ElementDesc="Text",
ElementIcon="Icon",

PopupBackground="Background",
PopupBackgroundTransparency="BackgroundTransparency",
PopupTitle="Text",
PopupContent="Text",
PopupIcon="Icon",

DialogBackground="Background",
DialogBackgroundTransparency="BackgroundTransparency",
DialogTitle="Text",
DialogContent="Text",
DialogIcon="Icon",

Toggle="Button",
ToggleBar="White",

Checkbox="Button",
CheckboxIcon="White",
}end function a.b()

local b=(cloneref or clonereference or function(b)return b end)

local d=b(game:GetService"RunService")
local e=b(game:GetService"UserInputService")
local f=b(game:GetService"TweenService")
local g=b(game:GetService"LocalizationService")
local h=b(game:GetService"HttpService")local i=

d.Heartbeat

local j="https://raw.githubusercontent.com/ANHub-Script/Icons/main/Main-v2.lua"

local l=loadstring(
game.HttpGetAsync and game:HttpGetAsync(j)
or h:GetAsync(j)
)()
l.SetIconsType"lucide"

local m

local p={
Font="rbxassetid://12187365364",
Localization=nil,
CanDraggable=true,
Theme=nil,
Themes=nil,
Icons=l,
Signals={},
Objects={},
LocalizationObjects={},
FontObjects={},
Language=string.match(g.SystemLocaleId,"^[a-z]+"),
Request=http_request or(syn and syn.request)or request,
DefaultProperties={
ScreenGui={
ResetOnSpawn=false,
ZIndexBehavior="Sibling",
},
CanvasGroup={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
Frame={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
TextLabel={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
RichText=true,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},TextButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
AutoButtonColor=false,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},
TextBox={
BackgroundColor3=Color3.new(1,1,1),
BorderColor3=Color3.new(0,0,0),
ClearTextOnFocus=false,
Text="",
TextColor3=Color3.new(0,0,0),
TextSize=14,
},
ImageLabel={
BackgroundTransparency=1,
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
},
ImageButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
AutoButtonColor=false,
},
UIListLayout={
SortOrder="LayoutOrder",
},
ScrollingFrame={
ScrollBarImageTransparency=1,
BorderSizePixel=0,
},
VideoFrame={
BorderSizePixel=0,
}
},
Colors={
Red="#e53935",
Orange="#f57c00",
Green="#43a047",
Blue="#039be5",
White="#ffffff",
Grey="#484848",
},
ThemeFallbacks=a.load'a',
Shapes={
Square="rbxassetid://82909646051652",
["Square-Outline"]="rbxassetid://72946211851948",

Squircle="rbxassetid://80999662900595",
SquircleOutline="rbxassetid://117788349049947",
["Squircle-Outline"]="rbxassetid://117817408534198",

SquircleOutline2="rbxassetid://117817408534198",

["Shadow-sm"]="rbxassetid://84825982946844",

["Squircle-TL-TR"]="rbxassetid://73569156276236",
["Squircle-BL-BR"]="rbxassetid://93853842912264",
["Squircle-TL-TR-Outline"]="rbxassetid://136702870075563",
["Squircle-BL-BR-Outline"]="rbxassetid://75035847706564",
}
}

function p.Init(r)
m=r
end

function p.AddSignal(r,u)
local v=r:Connect(u)
table.insert(p.Signals,v)
return v
end

function p.DisconnectAll()
for r,u in next,p.Signals do
local v=table.remove(p.Signals,r)
v:Disconnect()
end
end

function p.SafeCallback(r,...)
if not r then
return
end

local u,v=pcall(r,...)
if not u then
if m and m.Window and m.Window.Debug then local
x, z=v:find":%d+: "

warn("[ ANUI: DEBUG Mode ] "..v)

return m:Notify{
Title="DEBUG Mode: Error",
Content=not z and v or v:sub(z+1),
Duration=8,
}
end
end
end

function p.Gradient(r,u)
if m and m.Gradient then
return m:Gradient(r,u)
end

local v={}
local x={}

for z,A in next,r do
local B=tonumber(z)
if B then
B=math.clamp(B/100,0,1)
table.insert(v,ColorSequenceKeypoint.new(B,A.Color))
table.insert(x,NumberSequenceKeypoint.new(B,A.Transparency or 0))
end
end

table.sort(v,function(z,A)return z.Time<A.Time end)
table.sort(x,function(z,A)return z.Time<A.Time end)

if#v<2 then
error"ColorSequence requires at least 2 keypoints"
end

local z={
Color=ColorSequence.new(v),
Transparency=NumberSequence.new(x),
}

if u then
for A,B in pairs(u)do
z[A]=B
end
end

return z
end

function p.SetTheme(r)
p.Theme=r
p.UpdateTheme(nil,false)
end

function p.AddFontObject(r)
table.insert(p.FontObjects,r)
p.UpdateFont(p.Font)
end

function p.UpdateFont(r)
p.Font=r
for u,v in next,p.FontObjects do
v.FontFace=Font.new(r,v.FontFace.Weight,v.FontFace.Style)
end
end

function p.GetThemeProperty(r,u)
local function getValue(v,x)
local z=x[v]

if z==nil then return nil end

if typeof(z)=="string"and string.sub(z,1,1)=="#"then
return Color3.fromHex(z)
end

if typeof(z)=="Color3"then
return z
end

if typeof(z)=="number"then
return z
end

if typeof(z)=="table"and z.Color and z.Transparency then
return z
end

if typeof(z)=="function"then
return z()
end

return z
end

local v=getValue(r,u)
if v~=nil then
if typeof(v)=="string"and string.sub(v,1,1)~="#"then
local x=p.GetThemeProperty(v,u)
if x~=nil then
return x
end
else
return v
end
end

local x=p.ThemeFallbacks[r]
if x~=nil then
if typeof(x)=="string"and string.sub(x,1,1)~="#"then
return p.GetThemeProperty(x,u)
else
return getValue(r,{[r]=x})
end
end

v=getValue(r,p.Themes.Dark)
if v~=nil then
if typeof(v)=="string"and string.sub(v,1,1)~="#"then
local z=p.GetThemeProperty(v,p.Themes.Dark)
if z~=nil then
return z
end
else
return v
end
end

if x~=nil then
if typeof(x)=="string"and string.sub(x,1,1)~="#"then
return p.GetThemeProperty(x,p.Themes.Dark)
else
return getValue(r,{[r]=x})
end
end

return nil
end

function p.AddThemeObject(r,u)
p.Objects[r]={Object=r,Properties=u}
p.UpdateTheme(r,false)
return r
end

function p.AddLangObject(r)
local u=p.LocalizationObjects[r]
local v=u.Object
local x=currentObjTranslationId
p.UpdateLang(v,x)
return v
end

function p.UpdateTheme(r,u)
local function ApplyTheme(v)
for x,z in pairs(v.Properties or{})do
local A=p.GetThemeProperty(z,p.Theme)
if A~=nil then
if typeof(A)=="Color3"then
local B=v.Object:FindFirstChild"WindUIGradient"
if B then
B:Destroy()
end

if not u then
v.Object[x]=A
else
p.Tween(v.Object,0.08,{[x]=A}):Play()
end
elseif typeof(A)=="table"and A.Color and A.Transparency then
v.Object[x]=Color3.new(1,1,1)

local B=v.Object:FindFirstChild"WindUIGradient"
if not B then
B=Instance.new"UIGradient"
B.Name="WindUIGradient"
B.Parent=v.Object
end

B.Color=A.Color
B.Transparency=A.Transparency

for C,F in pairs(A)do
if C~="Color"and C~="Transparency"and B[C]~=nil then
B[C]=F
end
end
elseif typeof(A)=="number"then
if not u then
v.Object[x]=A
else
p.Tween(v.Object,0.08,{[x]=A}):Play()
end
end
else

local B=v.Object:FindFirstChild"WindUIGradient"
if B then
B:Destroy()
end
end
end
end

if r then
local v=p.Objects[r]
if v then
ApplyTheme(v)
end
else
for v,x in pairs(p.Objects)do
ApplyTheme(x)
end
end
end

function p.SetLangForObject(r)
if p.Localization and p.Localization.Enabled then
local u=p.LocalizationObjects[r]
if not u then return end

local v=u.Object
local x=u.TranslationId

local z=p.Localization.Translations[p.Language]
if z and z[x]then
v.Text=z[x]
else
local A=p.Localization and p.Localization.Translations and p.Localization.Translations.en or nil
if A and A[x]then
v.Text=A[x]
else
v.Text="["..x.."]"
end
end
end
end

function p.ChangeTranslationKey(r,u,v)
if p.Localization and p.Localization.Enabled then
local x=string.match(v,"^"..p.Localization.Prefix.."(.+)")
if x then
for z,A in ipairs(p.LocalizationObjects)do
if A.Object==u then
A.TranslationId=x
p.SetLangForObject(z)
return
end
end

table.insert(p.LocalizationObjects,{
TranslationId=x,
Object=u
})
p.SetLangForObject(#p.LocalizationObjects)
end
end
end

function p.UpdateLang(r)
if r then
p.Language=r
end

for u=1,#p.LocalizationObjects do
local v=p.LocalizationObjects[u]
if v.Object and v.Object.Parent~=nil then
p.SetLangForObject(u)
else
p.LocalizationObjects[u]=nil
end
end
end

function p.SetLanguage(r)
p.Language=r
p.UpdateLang()
end

function p.Icon(r,u)
return l.Icon(r,nil,u~=false)
end

function p.AddIcons(r,u)
return l.AddIcons(r,u)
end

function p.New(r,u,v)
local x=Instance.new(r)

for z,A in next,p.DefaultProperties[r]or{}do
x[z]=A
end

for z,A in next,u or{}do
if z~="ThemeTag"then
x[z]=A
end
if p.Localization and p.Localization.Enabled and z=="Text"then
local B=string.match(A,"^"..p.Localization.Prefix.."(.+)")
if B then
local C=#p.LocalizationObjects+1
p.LocalizationObjects[C]={TranslationId=B,Object=x}

p.SetLangForObject(C)
end
end
end

for z,A in next,v or{}do
A.Parent=x
end

if u and u.ThemeTag then
p.AddThemeObject(x,u.ThemeTag)
end
if u and u.FontFace then
p.AddFontObject(x)
end
return x
end

function p.Tween(r,u,v,...)
return f:Create(r,TweenInfo.new(u,...),v)
end

function p.NewRoundFrame(r,u,v,x,z,A)
local function getImageForType(B)
return p.Shapes[B]
end

local function getSliceCenterForType(B)
return B~="Shadow-sm"and Rect.new(256
,256
,256
,256

)or Rect.new(512,512,512,512)
end

local B=p.New(z and"ImageButton"or"ImageLabel",{
Image=getImageForType(u),
ScaleType="Slice",
SliceCenter=getSliceCenterForType(u),
SliceScale=1,
BackgroundTransparency=1,
ThemeTag=v.ThemeTag and v.ThemeTag
},x)

for C,F in pairs(v or{})do
if C~="ThemeTag"then
B[C]=F
end
end

local function UpdateSliceScale(C)
local F=u~="Shadow-sm"and(C/(256))or(C/512)
B.SliceScale=math.max(F,0.0001)
end

local C={}

function C.SetRadius(F,G)
UpdateSliceScale(G)
end

function C.SetType(F,G)
u=G
B.Image=getImageForType(G)
B.SliceCenter=getSliceCenterForType(G)
UpdateSliceScale(r)
end

function C.UpdateShape(F,G,H)
if H then
u=H
B.Image=getImageForType(H)
B.SliceCenter=getSliceCenterForType(H)
end
if G then
r=G
end
UpdateSliceScale(r)
end

function C.GetRadius(F)
return r
end

function C.GetType(F)
return u
end

UpdateSliceScale(r)

return B,A and C or nil
end

local r=p.New local u=
p.Tween

function p.SetDraggable(v)
p.CanDraggable=v
end



function p.Drag(v,x,z)
local A
local B,C,F
local G={
CanDraggable=true
}

if not x or typeof(x)~="table"then
x={v}
end

local function update(H)
if not B or not G.CanDraggable then return end

local J=H.Position-C
p.Tween(v,0.02,{Position=UDim2.new(
F.X.Scale,F.X.Offset+J.X,
F.Y.Scale,F.Y.Offset+J.Y
)}):Play()
end

for H,J in pairs(x)do
J.InputBegan:Connect(function(L)
if(L.UserInputType==Enum.UserInputType.MouseButton1 or L.UserInputType==Enum.UserInputType.Touch)and G.CanDraggable then
if A==nil then
A=J
B=true
C=L.Position
F=v.Position

if z and typeof(z)=="function"then
z(true,A)
end

L.Changed:Connect(function()
if L.UserInputState==Enum.UserInputState.End then
B=false
A=nil

if z and typeof(z)=="function"then
z(false,nil)
end
end
end)
end
end
end)

J.InputChanged:Connect(function(L)
if B and A==J then
if L.UserInputType==Enum.UserInputType.MouseMovement or L.UserInputType==Enum.UserInputType.Touch then
update(L)
end
end
end)
end

e.InputChanged:Connect(function(H)
if B and A~=nil then
if H.UserInputType==Enum.UserInputType.MouseMovement or H.UserInputType==Enum.UserInputType.Touch then
update(H)
end
end
end)

function G.Set(H,J)
G.CanDraggable=J
end

return G
end


l.Init(r,"Icon")


function p.SanitizeFilename(v)
local x=v:match"([^/]+)$"or v

x=x:gsub("%.[^%.]+$","")

x=x:gsub("[^%w%-_]","_")

if#x>50 then
x=x:sub(1,50)
end

return x
end












local function DownloadFile(v,x)
local z=p.Request{Url=v,Method="GET"}
local A=z and(z.Body or z)or""
writefile(x,A)
local B,C=pcall(getcustomasset,x)
if B then return C end
return nil
end

function p.ConvertGifToMp4(v,x,z,A)
local B="eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDIxODQ5ZGVjMzc5NTc4N2NhMGMyNzgwMGE5ZDEzNzVmNjk0YzRmNzRiZWUzODYzYzAzOWQwNGYwMWMyYmJlOWM1ZjFhZjBmNzhiOWRiYTMiLCJpYXQiOjE3NjM5MTUzMzAuNjYxODg1LCJuYmYiOjE3NjM5MTUzMzAuNjYxODg2LCJleHAiOjQ5MTk1ODg5MzAuNjU2OTQ3LCJzdWIiOiI3MzU0OTc2MyIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.G6d420ydHlzvLFHIYUMfpgm1KgNctMeoSea484Xv8p0T7iyxqBN-6eLHzHA9H4olIneel01H_jLeEh4XOxNiCZI0P06mRaGZW41Ix2zjiCtsVxYJItOAjnmhdvWsbaYr69Kq_XzFUKYTuiXZbi7M9mqHpevCGDG6INVBhlZ4Wa87RIA0ILdAraYqu7733Ek9FI23oB8zyou5fJRsLyc7uO7Hpisy-jSSq_vBfR9tZwCu6ey3754FvFxBTHfu9t6J2yUP-UFb85UiOHl9IZ8b_M0iyASM7v1v0Z6EIEuq0PrgF2WDBjPbBUwG5N_fZC-sEFCh5NgdVArOInudIhsP6bAEwjHa_cC2c6bGQY1Nh3MVNnh2VHsz6-ArnJH8zjMlV-OqO6k92YYETgUco13xq6lm8VD2IluUtI9EGmdlkveQ3q_D8Kwn3tFQR-CbDVgsb9b1v4Ygjv_vgTUs-AYq-MPLE4tPpnh75jOArYA28hHddqqBQhQbpmBX2dx1MKeuqiz6U8hj2zmJ7WTSPBLl48lU0L_ekZpqwipJ3wTd22wauGPk1pp91KBVUFJ-C7aQKZ6tudyH-joxt5z_GBZAMUnmLFn9hytbLlbsoYHwomJn0srq8suDqWMHcV7mWhebxl8VqpYguoM-_D6EzxOn0_BmMss8oZL2RwmELX0UKZ8"
local C=x.."/"..z.."-"..A..".mp4"
if not B then return nil end
local F=h:JSONEncode{
tasks={
["import-1"]={operation="import/url",url=v},
["convert-1"]={operation="convert",input="import-1",input_format="gif",output_format="mp4"},
["export-1"]={operation="export/url",input="convert-1"}
}
}
local G,H=pcall(function()
return p.Request{
Url="https://api.cloudconvert.com/v2/jobs",
Method="POST",
Headers={Authorization=
"Bearer "..B,
["Content-Type"]="application/json",Accept=
"application/json",
},
Body=F,
}
end)
if not G or not H or not H.Body then return nil end
local J,L=pcall(function()return h:JSONDecode(H.Body)end)
if not J or not L or not L.data or not L.data.id then return nil end
local M=L.data.id
local N
for O=1,60 do
task.wait(0.5)
local P,Q=pcall(function()
return p.Request{
Url="https://api.cloudconvert.com/v2/jobs/"..M,
Method="GET",
Headers={Authorization=
"Bearer "..B,Accept=
"application/json",
}
}
end)
if P and Q and Q.Body then
local R,S=pcall(function()return h:JSONDecode(Q.Body)end)
if R and S and S.data and S.data.tasks then
for T,U in pairs(S.data.tasks)do
if U.operation=="export/url"and U.status=="finished"and U.result and U.result.files and U.result.files[1]and U.result.files[1].url then
N=U.result.files[1].url
break
end
end
end
end
if N then break end
end
if not N then return nil end
local O=DownloadFile(N,C)
return O
end

function p.ConvertGifToWebm(v,x,z,A)
local B="eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDIxODQ5ZGVjMzc5NTc4N2NhMGMyNzgwMGE5ZDEzNzVmNjk0YzRmNzRiZWUzODYzYzAzOWQwNGYwMWMyYmJlOWM1ZjFhZjBmNzhiOWRiYTMiLCJpYXQiOjE3NjM5MTUzMzAuNjYxODg1LCJuYmYiOjE3NjM5MTUzMzAuNjYxODg2LCJleHAiOjQ5MTk1ODg5MzAuNjU2OTQ3LCJzdWIiOiI3MzU0OTc2MyIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.G6d420ydHlzvLFHIYUMfpgm1KgNctMeoSea484Xv8p0T7iyxqBN-6eLHzHA9H4olIneel01H_jLeEh4XOxNiCZI0P06mRaGZW41Ix2zjiCtsVxYJItOAjnmhdvWsbaYr69Kq_XzFUKYTuiXZbi7M9mqHpevCGDG6INVBhlZ4Wa87RIA0ILdAraYqu7733Ek9FI23oB8zyou5fJRsLyc7uO7Hpisy-jSSq_vBfR9tZwCu6ey3754FvFxBTHfu9t6J2yUP-UFb85UiOHl9IZ8b_M0iyASM7v1v0Z6EIEuq0PrgF2WDBjPbBUwG5N_fZC-sEFCh5NgdVArOInudIhsP6bAEwjHa_cC2c6bGQY1Nh3MVNnh2VHsz6-ArnJH8zjMlV-OqO6k92YYETgUco13xq6lm8VD2IluUtI9EGmdlkveQ3q_D8Kwn3tFQR-CbDVgsb9b1v4Ygjv_vgTUs-AYq-MPLE4tPpnh75jOArYA28hHddqqBQhQbpmBX2dx1MKeuqiz6U8hj2zmJ7WTSPBLl48lU0L_ekZpqwipJ3wTd22wauGPk1pp91KBVUFJ-C7aQKZ6tudyH-joxt5z_GBZAMUnmLFn9hytbLlbsoYHwomJn0srq8suDqWMHcV7mWhebxl8VqpYguoM-_D6EzxOn0_BmMss8oZL2RwmELX0UKZ8"
local C=x.."/"..z.."-"..A..".webm"
if not B then return nil end
local F=h:JSONEncode{
tasks={
["import-1"]={operation="import/url",url=v},
["convert-1"]={operation="convert",input="import-1",input_format="gif",output_format="webm",video_codec="vp9"},
["export-1"]={operation="export/url",input="convert-1"}
}
}
local G,H=pcall(function()
return p.Request{
Url="https://api.cloudconvert.com/v2/jobs",
Method="POST",
Headers={Authorization=
"Bearer "..B,
["Content-Type"]="application/json",Accept=
"application/json",
},
Body=F,
}
end)
if not G or not H or not H.Body then return nil end
local J,L=pcall(function()return h:JSONDecode(H.Body)end)
if not J or not L or not L.data or not L.data.id then return nil end
local M=L.data.id
local N
for O=1,60 do
task.wait(0.5)
local P,Q=pcall(function()
return p.Request{
Url="https://api.cloudconvert.com/v2/jobs/"..M,
Method="GET",
Headers={Authorization=
"Bearer "..B,Accept=
"application/json",
}
}
end)
if P and Q and Q.Body then
local R,S=pcall(function()return h:JSONDecode(Q.Body)end)
if R and S and S.data and S.data.tasks then
for T,U in pairs(S.data.tasks)do
if U.operation=="export/url"and U.status=="finished"and U.result and U.result.files and U.result.files[1]and U.result.files[1].url then
N=U.result.files[1].url
break
end
end
end
end
if N then break end
end
if not N then return nil end
local O=DownloadFile(N,C)
return O
end

local function GetBaseUrl(v)
return v:match"^[^%?]+"or v
end

local function LoadUrlMap(v)
local x=v.."/urlmap.json"
if isfile and isfile(x)then
local z,A=pcall(function()return h:JSONDecode(readfile(x))end)
if z and typeof(A)=="table"then return A end
end
return{}
end

local function SaveUrlMap(v,x)
local z=v.."/urlmap.json"
writefile(z,h:JSONEncode(x))
end

function p.Image(v,x,z,A,B,C,F,G)
A=A or"Temp"
x=p.SanitizeFilename(x)

local H=r("Frame",{
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
},{
r("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScaleType="Crop",
ThemeTag=(p.Icon(v)or F)and{
ImageColor3=C and(G or"Icon")or nil
}or nil,
},{
r("UICorner",{
CornerRadius=UDim.new(0,z)
})
})
})
local J=H:FindFirstChildOfClass"ImageLabel"
local L=(type(v)=="table"and v.url)or v
local M=(type(v)=="table"and(v.gif or v.file))or nil
local N=(type(v)=="table"and v.mp4)or nil
local O=(type(v)=="table"and v.webm)or nil
if type(L)=="string"and p.Icon(L)then
local P=p.Icon(L)
if not J then
J=r("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScaleType="Crop",
})
J.Parent=H
end
J.Image=P[1]
J.ImageRectOffset=P[2].ImageRectPosition
J.ImageRectSize=P[2].ImageRectSize
elseif type(L)=="string"and string.find(L,"http")then
local P="ANUI/"..A.."/assets"
if isfolder and makefolder then
if not isfolder"ANUI"then makefolder"ANUI"end
if not isfolder("ANUI/"..A)then makefolder("ANUI/"..A)end
if not isfolder(P)then makefolder(P)end
end
local aa,ab=pcall(function()
task.spawn(function()
local Q=GetBaseUrl(L)
local R=LoadUrlMap(P)
local S=R[Q]
if O and isfile and isfile(P.."/"..O)then
local T,U=pcall(getcustomasset,P.."/"..O)
if T then
local V=r("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=U,
Looped=true,
Volume=0,
},{
r("UICorner",{CornerRadius=UDim.new(0,z)})
})
V.Parent=H
J.Visible=false
V:Play()
R[Q]=R[Q]or{}
R[Q].webm=O
SaveUrlMap(P,R)
return
end
end
if N and isfile and isfile(P.."/"..N)then
local T,U=pcall(getcustomasset,P.."/"..N)
if T then
local V=r("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=U,
Looped=true,
Volume=0,
},{
r("UICorner",{CornerRadius=UDim.new(0,z)})
})
V.Parent=H
J.Visible=false
V:Play()
R[Q]=R[Q]or{}
R[Q].mp4=N
SaveUrlMap(P,R)
return
end
end
if M and isfile and isfile(P.."/"..M)then
local T,U=pcall(getcustomasset,P.."/"..M)
if T and J then
J.Image=U
J.ScaleType="Fit"
end
end
if S and S.mp4 and isfile and isfile(P.."/"..S.mp4)then
local T,U=pcall(getcustomasset,P.."/"..S.mp4)
if T then
local V=r("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=U,
Looped=true,
Volume=0,
},{
r("UICorner",{CornerRadius=UDim.new(0,z)})
})
V.Parent=H
J.Visible=false
V:Play()
return
end
end
if S and S.webm and isfile and isfile(P.."/"..S.webm)then
local T,U=pcall(getcustomasset,P.."/"..S.webm)
if T then
local V=r("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=U,
Looped=true,
Volume=0,
},{
r("UICorner",{CornerRadius=UDim.new(0,z)})
})
V.Parent=H
J.Visible=false
V:Play()
return
end
end
if S and S.gif and isfile and isfile(P.."/"..S.gif)then
local T,U=pcall(getcustomasset,P.."/"..S.gif)
if T and J then
J.Image=U
J.ScaleType="Fit"
end
local V=p.ConvertGifToWebm(L,P,B,x)
if V then
S.webm=B.."-"..x..".webm"
SaveUrlMap(P,R)
local W=r("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=V,
Looped=true,
Volume=0,
},{
r("UICorner",{CornerRadius=UDim.new(0,z)})
})
W.Parent=H
J.Visible=false
W:Play()
return
end
end
local T=p.Request{Url=L,Method="GET"}
local U=T and(T.Body or T)or""
local V=GetBaseUrl(L)
local W=string.lower((V:match"%.([%w]+)$"or""))
local X
if T and T.Headers then
X=T.Headers["Content-Type"]or T.Headers["content-type"]or T.Headers["Content-type"]
end
if not W or W==""then
if X then
if string.find(X,"gif")then W="gif"
elseif string.find(X,"jpeg")or string.find(X,"jpg")then W="jpg"
elseif string.find(X,"png")then W="png"else W="png"end
else
W="png"
end
end
local Y=B.."-"..x.."."..W
local _=P.."/"..Y
writefile(_,U)
R[V]=R[V]or{}
if W=="gif"then
R[V].gif=Y
SaveUrlMap(P,R)
if J then J.ScaleType="Fit"end
local aa=p.ConvertGifToWebm(L,P,B,x)
if aa then
R[V].webm=B.."-"..x..".webm"
SaveUrlMap(P,R)
local ab=r("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=aa,
Looped=true,
Volume=0,
},{
r("UICorner",{CornerRadius=UDim.new(0,z)})
})
ab.Parent=H
J.Visible=false
ab:Play()
return
end
end
local aa,ab=pcall(getcustomasset,_)
if aa then
if J then J.Image=ab end
else
warn(string.format("[ ANUI.Creator ] Failed to load custom asset '%s': %s",_,tostring(ab)))
H:Destroy()
return
end
end)
end)
if not aa then
warn("[ ANUI.Creator ]  '"..tostring(identifyexecutor and identifyexecutor()or"unknown").."' doesnt support the URL Images. Error: "..tostring(ab))
H:Destroy()
end
elseif L==""then
H.Visible=false
else
if J then J.Image=L end
end

return H
end


return p end function a.c()

local aa={}







function aa.New(ab,b,d)
local e={
Enabled=b.Enabled or false,
Translations=b.Translations or{},
Prefix=b.Prefix or"loc:",
DefaultLanguage=b.DefaultLanguage or"en"
}

d.Localization=e

return e
end



return aa end function a.d()
local aa=a.load'b'
local ab=aa.New
local b=aa.Tween

local d={
Size=UDim2.new(0,300,1,-156),
SizeLower=UDim2.new(0,300,1,-56),
UICorner=13,
UIPadding=14,

Holder=nil,
NotificationIndex=0,
Notifications={}
}

function d.Init(e)
local f={
Lower=false
}

function f.SetLower(g)
f.Lower=g
f.Frame.Size=g and d.SizeLower or d.Size
end

f.Frame=ab("Frame",{
Position=UDim2.new(1,-29,0,56),
AnchorPoint=Vector2.new(1,0),
Size=d.Size,
Parent=e,
BackgroundTransparency=1,




},{
ab("UIListLayout",{
HorizontalAlignment="Center",
SortOrder="LayoutOrder",
VerticalAlignment="Bottom",
Padding=UDim.new(0,8),
}),
ab("UIPadding",{
PaddingBottom=UDim.new(0,29)
})
})
return f
end

function d.New(e)
local f={
Title=e.Title or"Notification",
Content=e.Content or nil,
Icon=e.Icon or nil,
IconThemed=e.IconThemed,
Background=e.Background,
BackgroundImageTransparency=e.BackgroundImageTransparency,
Duration=e.Duration or 5,
Buttons=e.Buttons or{},
CanClose=true,
UIElements={},
Closed=false,
}
if f.CanClose==nil then
f.CanClose=true
end
d.NotificationIndex=d.NotificationIndex+1
d.Notifications[d.NotificationIndex]=f









local g

if f.Icon then





















g=aa.Image(
f.Icon,
f.Title..":"..f.Icon,
0,
e.Window,
"Notification",
f.IconThemed
)
g.Size=UDim2.new(0,26,0,26)
g.Position=UDim2.new(0,d.UIPadding,0,d.UIPadding)

end

local h
if f.CanClose then
h=ab("ImageButton",{
Image=aa.Icon"x"[1],
ImageRectSize=aa.Icon"x"[2].ImageRectSize,
ImageRectOffset=aa.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
Size=UDim2.new(0,16,0,16),
Position=UDim2.new(1,-d.UIPadding,0,d.UIPadding),
AnchorPoint=Vector2.new(1,0),
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=.4,
},{
ab("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
})
})
end

local j=ab("Frame",{
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=.95,
ThemeTag={
BackgroundColor3="Text",
},

})

local l=ab("Frame",{
Size=UDim2.new(1,
f.Icon and-28-d.UIPadding or 0,
1,0),
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
AutomaticSize="Y",
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,d.UIPadding),
PaddingLeft=UDim.new(0,d.UIPadding),
PaddingRight=UDim.new(0,d.UIPadding),
PaddingBottom=UDim.new(0,d.UIPadding),
}),
ab("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,-30-d.UIPadding,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,
TextSize=16,
ThemeTag={
TextColor3="Text"
},
Text=f.Title,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium)
}),
ab("UIListLayout",{
Padding=UDim.new(0,d.UIPadding/3)
})
})

if f.Content then
ab("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,
TextTransparency=.4,
TextSize=15,
ThemeTag={
TextColor3="Text"
},
Text=f.Content,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
Parent=l
})
end


local m=aa.NewRoundFrame(d.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(2,0,1,0),
AnchorPoint=Vector2.new(0,1),
AutomaticSize="Y",
ImageTransparency=.05,
ThemeTag={
ImageColor3="Background"
},

},{
ab("CanvasGroup",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
j,
ab("UICorner",{
CornerRadius=UDim.new(0,d.UICorner),
})

}),
ab("ImageLabel",{
Name="Background",
Image=f.Background,
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
ScaleType="Crop",
ImageTransparency=f.BackgroundImageTransparency

},{
ab("UICorner",{
CornerRadius=UDim.new(0,d.UICorner),
})
}),

l,
g,h,
})

local p=ab("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
Parent=e.Holder
},{
m
})

function f.Close(r)
if not f.Closed then
f.Closed=true
b(p,0.45,{Size=UDim2.new(1,0,0,-8)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
b(m,0.55,{Position=UDim2.new(2,0,1,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
task.wait(.45)
p:Destroy()
end
end

task.spawn(function()
task.wait()
b(p,0.45,{Size=UDim2.new(
1,
0,
0,
m.AbsoluteSize.Y
)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
b(m,0.45,{Position=UDim2.new(0,0,1,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if f.Duration then
b(j,f.Duration,{Size=UDim2.new(1,0,1,0)},Enum.EasingStyle.Linear,Enum.EasingDirection.InOut):Play()
task.wait(f.Duration)
f:Close()
end
end)

if h then
aa.AddSignal(h.TextButton.MouseButton1Click,function()
f:Close()
end)
end


return f
end

return d end function a.e()











local aa=4294967296;local ab=aa-1;local function c(b,d)local e,f=0,1;while b~=0 or d~=0 do local g,h=b%2,d%2;local j=(g+h)%2;e=e+j*f;b=math.floor(b/2)d=math.floor(d/2)f=f*2 end;return e%aa end;local function k(b,d,e,...)local f;if d then b=b%aa;d=d%aa;f=c(b,d)if e then f=k(f,e,...)end;return f elseif b then return b%aa else return 0 end end;local function n(b,d,e,...)local f;if d then b=b%aa;d=d%aa;f=(b+d-c(b,d))/2;if e then f=n(f,e,...)end;return f elseif b then return b%aa else return ab end end;local function o(b)return ab-b end;local function q(b,d)if d<0 then return lshift(b,-d)end;return math.floor(b%4294967296/2^d)end;local function s(b,d)if d>31 or d<-31 then return 0 end;return q(b%aa,d)end;local function lshift(b,d)if d<0 then return s(b,-d)end;return b*2^d%4294967296 end;local function t(b,d)b=b%aa;d=d%32;local e=n(b,2^d-1)return s(b,d)+lshift(e,32-d)end;local b={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(d)return string.gsub(d,".",function(e)return string.format("%02x",string.byte(e))end)end;local function y(d,e)local f=""for g=1,e do local h=d%256;f=string.char(h)..f;d=(d-h)/256 end;return f end;local function D(d,e)local f=0;for g=e,e+3 do f=f*256+string.byte(d,g)end;return f end;local function E(d,e)local f=64-(e+9)%64;e=y(8*e,8)d=d.."\128"..string.rep("\0",f)..e;assert(#d%64==0)return d end;local function I(d)d[1]=0x6a09e667;d[2]=0xbb67ae85;d[3]=0x3c6ef372;d[4]=0xa54ff53a;d[5]=0x510e527f;d[6]=0x9b05688c;d[7]=0x1f83d9ab;d[8]=0x5be0cd19;return d end;local function K(d,e,f)local g={}for h=1,16 do g[h]=D(d,e+(h-1)*4)end;for h=17,64 do local j=g[h-15]local l=k(t(j,7),t(j,18),s(j,3))j=g[h-2]g[h]=(g[h-16]+l+g[h-7]+k(t(j,17),t(j,19),s(j,10)))%aa end;local h,j,l,m,p,r,u,v=f[1],f[2],f[3],f[4],f[5],f[6],f[7],f[8]for x=1,64 do local z=k(t(h,2),t(h,13),t(h,22))local A=k(n(h,j),n(h,l),n(j,l))local B=(z+A)%aa;local C=k(t(p,6),t(p,11),t(p,25))local F=k(n(p,r),n(o(p),u))local G=(v+C+F+b[x]+g[x])%aa;v=u;u=r;r=p;p=(m+G)%aa;m=l;l=j;j=h;h=(G+B)%aa end;f[1]=(f[1]+h)%aa;f[2]=(f[2]+j)%aa;f[3]=(f[3]+l)%aa;f[4]=(f[4]+m)%aa;f[5]=(f[5]+p)%aa;f[6]=(f[6]+r)%aa;f[7]=(f[7]+u)%aa;f[8]=(f[8]+v)%aa end;local function Z(d)d=E(d,#d)local e=I{}for f=1,#d,64 do K(d,f,e)end;return w(y(e[1],4)..y(e[2],4)..y(e[3],4)..y(e[4],4)..y(e[5],4)..y(e[6],4)..y(e[7],4)..y(e[8],4))end;local d;local e={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local f={["/"]="/"}for g,h in pairs(e)do f[h]=g end;local g=function(g)return"\\"..(e[g]or string.format("u%04x",g:byte()))end;local h=function(h)return"null"end;local j=function(j,l)local m={}l=l or{}if l[j]then error"circular reference"end;l[j]=true;if rawget(j,1)~=nil or next(j)==nil then local p=0;for r in pairs(j)do if type(r)~="number"then error"invalid table: mixed or invalid key types"end;p=p+1 end;if p~=#j then error"invalid table: sparse array"end;for r,u in ipairs(j)do table.insert(m,d(u,l))end;l[j]=nil;return"["..table.concat(m,",").."]"else for p,r in pairs(j)do if type(p)~="string"then error"invalid table: mixed or invalid key types"end;table.insert(m,d(p,l)..":"..d(r,l))end;l[j]=nil;return"{"..table.concat(m,",").."}"end end;local l=function(l)return'"'..l:gsub('[%z\1-\31\\"]',g)..'"'end;local m=function(m)if m~=m or m<=-math.huge or m>=math.huge then error("unexpected number value '"..tostring(m).."'")end;return string.format("%.14g",m)end;local p={["nil"]=h,table=j,string=l,number=m,boolean=tostring}d=function(r,u)local v=type(r)local x=p[v]if x then return x(r,u)end;error("unexpected type '"..v.."'")end;local r=function(r)return d(r)end;local u;local v=function(...)local v={}for x=1,select("#",...)do v[select(x,...)]=true end;return v end;local x=v(" ","\t","\r","\n")local z=v(" ","\t","\r","\n","]","}",",")local A=v("\\","/",'"',"b","f","n","r","t","u")local B=v("true","false","null")local C={["true"]=true,["false"]=false,null=nil}local F=function(F,G,H,J)for L=G,#F do if H[F:sub(L,L)]~=J then return L end end;return#F+1 end;local G=function(G,H,J)local L=1;local M=1;for N=1,H-1 do M=M+1;if G:sub(N,N)=="\n"then L=L+1;M=1 end end;error(string.format("%s at line %d col %d",J,L,M))end;local H=function(H)local J=math.floor;if H<=0x7f then return string.char(H)elseif H<=0x7ff then return string.char(J(H/64)+192,H%64+128)elseif H<=0xffff then return string.char(J(H/4096)+224,J(H%4096/64)+128,H%64+128)elseif H<=0x10ffff then return string.char(J(H/262144)+240,J(H%262144/4096)+128,J(H%4096/64)+128,H%64+128)end;error(string.format("invalid unicode codepoint '%x'",H))end;local J=function(J)local L=tonumber(J:sub(1,4),16)local M=tonumber(J:sub(7,10),16)if M then return H((L-0xd800)*0x400+M-0xdc00+0x10000)else return H(L)end end;local L=function(L,M)local N=""local O=M+1;local P=O;while O<=#L do local Q=L:byte(O)if Q<32 then G(L,O,"control character in string")elseif Q==92 then N=N..L:sub(P,O-1)O=O+1;local R=L:sub(O,O)if R=="u"then local S=L:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",O+1)or L:match("^%x%x%x%x",O+1)or G(L,O-1,"invalid unicode escape in string")N=N..J(S)O=O+#S else if not A[R]then G(L,O-1,"invalid escape char '"..R.."' in string")end;N=N..f[R]end;P=O+1 elseif Q==34 then N=N..L:sub(P,O-1)return N,O+1 end;O=O+1 end;G(L,M,"expected closing quote for string")end;local M=function(M,N)local O=F(M,N,z)local P=M:sub(N,O-1)local Q=tonumber(P)if not Q then G(M,N,"invalid number '"..P.."'")end;return Q,O end;local N=function(N,O)local P=F(N,O,z)local Q=N:sub(O,P-1)if not B[Q]then G(N,O,"invalid literal '"..Q.."'")end;return C[Q],P end;local O=function(O,P)local Q={}local R=1;P=P+1;while 1 do local S;P=F(O,P,x,true)if O:sub(P,P)=="]"then P=P+1;break end;S,P=u(O,P)Q[R]=S;R=R+1;P=F(O,P,x,true)local T=O:sub(P,P)P=P+1;if T=="]"then break end;if T~=","then G(O,P,"expected ']' or ','")end end;return Q,P end;local P=function(P,Q)local R={}Q=Q+1;while 1 do local S,T;Q=F(P,Q,x,true)if P:sub(Q,Q)=="}"then Q=Q+1;break end;if P:sub(Q,Q)~='"'then G(P,Q,"expected string for key")end;S,Q=u(P,Q)Q=F(P,Q,x,true)if P:sub(Q,Q)~=":"then G(P,Q,"expected ':' after key")end;Q=F(P,Q+1,x,true)T,Q=u(P,Q)R[S]=T;Q=F(P,Q,x,true)local U=P:sub(Q,Q)Q=Q+1;if U=="}"then break end;if U~=","then G(P,Q,"expected '}' or ','")end end;return R,Q end;local Q={['"']=L,["0"]=M,["1"]=M,["2"]=M,["3"]=M,["4"]=M,["5"]=M,["6"]=M,["7"]=M,["8"]=M,["9"]=M,["-"]=M,t=N,f=N,n=N,["["]=O,["{"]=P}u=function(R,S)local T=R:sub(S,S)local U=Q[T]if U then return U(R,S)end;G(R,S,"unexpected character '"..T.."'")end;local R=function(R)if type(R)~="string"then error("expected argument of type string, got "..type(R))end;local S,T=u(R,F(R,1,x,true))T=F(R,T,x,true)if T<=#R then G(R,T,"trailing garbage")end;return S end;
local S,T,U=r,R,Z;





local V={}

local W=(cloneref or clonereference or function(W)return W end)


function V.New(X,Y)

local _=X;
local ac=Y;
local ad=true;


local ae=function(ae)end;


repeat task.wait(1)until game:IsLoaded();


local af=false;
local ag,ah,ai,aj,ak,al,am,an,ao=setclipboard or toclipboard,request or http_request or syn_request,string.char,tostring,string.sub,os.time,math.random,math.floor,gethwid or function()return W(game:GetService"Players").LocalPlayer.UserId end
local ap,aq="",0;


local ar="https://api.platoboost.app";
local as=ah{
Url=ar.."/public/connectivity",
Method="GET"
};
if as.StatusCode~=200 and as.StatusCode~=429 then
ar="https://api.platoboost.net";
end


function cacheLink()
if aq+(600)<al()then
local at=ah{
Url=ar.."/public/start",
Method="POST",
Body=S{
service=_,
identifier=U(ao())
},
Headers={
["Content-Type"]="application/json",
["User-Agent"]="Roblox/Exploit"
}
};

if at.StatusCode==200 then
local au=T(at.Body);

if au.success==true then
ap=au.data.url;
aq=al();
return true,ap
else
ae(au.message);
return false,au.message
end
elseif at.StatusCode==429 then
local au="you are being rate limited, please wait 20 seconds and try again.";
ae(au);
return false,au
end

local au="Failed to cache link.";
ae(au);
return false,au
else
return true,ap
end
end

cacheLink();


local at=function()
local at=""
for au=1,16 do
at=at..ai(an(am()*(26))+97)
end
return at
end


for au=1,5 do
local av=at();
task.wait(0.2)
if at()==av then
local aw="platoboost nonce error.";
ae(aw);
error(aw);
end
end


local au=function()
local au,av=cacheLink();

if au then
ag(av);
end
end


local av=function(av)
local aw=at();
local ax=ar.."/public/redeem/"..aj(_);

local ay={
identifier=U(ao()),
key=av
}

if ad then
ay.nonce=aw;
end

local az=ah{
Url=ax,
Method="POST",
Body=S(ay),
Headers={
["Content-Type"]="application/json"
}
};

if az.StatusCode==200 then
local aA=T(az.Body);

if aA.success==true then
if aA.data.valid==true then
if ad then
if aA.data.hash==U("true".."-"..aw.."-"..ac)then
return true
else
ae"failed to verify integrity.";
return false
end
else
return true
end
else
ae"key is invalid.";
return false
end
else
if ak(aA.message,1,27)=="unique constraint violation"then
ae"you already have an active key, please wait for it to expire before redeeming it.";
return false
else
ae(aA.message);
return false
end
end
elseif az.StatusCode==429 then
ae"you are being rate limited, please wait 20 seconds and try again.";
return false
else
ae"server returned an invalid status code, please try again later.";
return false
end
end


local aw=function(aw)
if af==true then
return false,("A request is already being sent, please slow down.")
else
af=true;
end

local ax=at();
local ay=ar.."/public/whitelist/"..aj(_).."?identifier="..U(ao()).."&key="..aw;

if ad then
ay=ay.."&nonce="..ax;
end

local az=ah{
Url=ay,
Method="GET",
};

af=false;

if az.StatusCode==200 then
local aA=T(az.Body);

if aA.success==true then
if aA.data.valid==true then
if ad then
if aA.data.hash==U("true".."-"..ax.."-"..ac)then
return true,""
else
return false,("failed to verify integrity.")
end
else
return true
end
else
if ak(aw,1,4)=="KEY_"then
return true,av(aw)
else
return false,("Key is invalid.")
end
end
else
return false,(aA.message)
end
elseif az.StatusCode==429 then
return false,("You are being rate limited, please wait 20 seconds and try again.")
else
return false,("Server returned an invalid status code, please try again later.")
end
end


local ax=function(ax)
local ay=at();
local az=ar.."/public/flag/"..aj(_).."?name="..ax;

if ad then
az=az.."&nonce="..ay;
end

local aA=ah{
Url=az,
Method="GET",
};

if aA.StatusCode==200 then
local aB=T(aA.Body);

if aB.success==true then
if ad then
if aB.data.hash==U(aj(aB.data.value).."-"..ay.."-"..ac)then
return aB.data.value
else
ae"failed to verify integrity.";
return nil
end
else
return aB.data.value
end
else
ae(aB.message);
return nil
end
else
return nil
end
end


return{
Verify=aw,
GetFlag=ax,
Copy=au,
}
end


return V end function a.f()









local aa=(cloneref or clonereference or function(aa)return aa end)

local ab=aa(game:GetService"HttpService")
local ac={}



function ac.New(ad)
local ae=gethwid or function()return aa(game:GetService"Players").LocalPlayer.UserId end
local af,ag=request or http_request or syn_request,setclipboard or toclipboard

function ValidateKey(ah)
local ai="https://pandadevelopment.net/v2_validation?key="..tostring(ah).."&service="..tostring(ad).."&hwid="..tostring(ae())


local aj,ak=pcall(function()
return af{
Url=ai,
Method="GET",
Headers={["User-Agent"]="Roblox/Exploit"}
}
end)

if aj and ak then
if ak.Success then
local al,am=pcall(function()
return ab:JSONDecode(ak.Body)
end)

if al and am then
if am.V2_Authentication and am.V2_Authentication=="success"then

return true,"Authenticated"
else
local an=am.Key_Information.Notes or"Unknown reason"

return false,"Authentication failed: "..an
end
else

return false,"JSON decode error"
end
else
warn("[Pelinda Ov2.5] HTTP request was not successful. Code: "..tostring(ak.StatusCode).." Message: "..ak.StatusMessage)
return false,"HTTP request failed: "..ak.StatusMessage
end
else

return false,"Request pcall error"
end
end

function GetKeyLink()
return"https://pandadevelopment.net/getkey?service="..tostring(ad).."&hwid="..tostring(ae())
end

function CopyLink()
return ag(GetKeyLink())
end

return{
Verify=ValidateKey,
Copy=CopyLink
}
end

return ac end function a.g()








local aa={}


function aa.New(ab,ac)
local ad="https://sdkapi-public.luarmor.net/library.lua"

local ae=loadstring(
game.HttpGetAsync and game:HttpGetAsync(ad)
or HttpService:GetAsync(ad)
)()
local af=setclipboard or toclipboard

ae.script_id=ab

function ValidateKey(ag)
local ah=ae.check_key(ag);


if(ah.code=="KEY_VALID")then
return true,"Whitelisted!"

elseif(ah.code=="KEY_HWID_LOCKED")then
return false,"Key linked to a different HWID. Please reset it using our bot"

elseif(ah.code=="KEY_INCORRECT")then
return false,"Key is wrong or deleted!"
else
return false,"Key check failed:"..ah.message.." Code: "..ah.code
end
end

function CopyLink()
af(tostring(ac))
end

return{
Verify=ValidateKey,
Copy=CopyLink
}
end


return aa end function a.h()
return{
platoboost={
Name="Platoboost",
Icon="rbxassetid://75920162824531",
Args={"ServiceId","Secret"},


New=a.load'e'.New
},
pandadevelopment={
Name="Panda Development",
Icon="panda",
Args={"ServiceId"},


New=a.load'f'.New
},
luarmor={
Name="Luarmor",
Icon="rbxassetid://130918283130165",
Args={"ScriptId","Discord"},


New=a.load'g'.New
},

}end function a.i()


return[[
{
    "name": "ANUI",
    "version": "1.0.200",
    "main": "./dist/main.lua",
    "repository": "https://github.com/ANHub-Script/ANUI",
    "discord": "https://discord.gg/cy6uMRmeZ",
    "author": "ANHub-Script",
    "description": "Roblox UI Library for scripts",
    "license": "MIT",
    "scripts": {
        "dev": "node build/build.js dev",
        "build": "node build/build.js build",
        "live": "python -m http.server 8642 --bind 0.0.0.0",
        "watch": "chokidar . -i 'node_modules' -i 'dist' -i 'build' -c 'npm run dev --'",
        "live-build": "concurrently \"npm run live\" \"npm run watch --\"",
        "example-live-build": "INPUT_FILE=main_example.lua npm run live-build",
        "updater": "python updater/main.py"
    },
    "keywords": [
        "ui-library",
        "ui-design",
        "script",
        "script-hub",
        "exploiting"
    ],
    "devDependencies": {
        "chokidar-cli": "^3.0.0",
        "concurrently": "^9.2.0"
    }
}

]]end function a.j()local aa={}local ab=a.load'b'local ac=ab.New local ad=ab.Tween function aa.New(ae,af,ag,ah,ai,aj,ak,al)ah=ah or"Primary"local am=al or(not ak and 10 or 99)local an if af and af~=""then an=ac("ImageLabel",{Image=ab.Icon(af)[1],ImageRectSize=ab.Icon(af)[2].ImageRectSize,ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,Size=UDim2.new(0,21,0,21),BackgroundTransparency=1,ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,ImageTransparency=ah=="White"and.4 or 0,ThemeTag={ImageColor3=ah~="White"and"Icon"or nil,}})end local ao=ac("TextButton",{Size=UDim2.new(0,0,1,0),AutomaticSize="X",Parent=ai,BackgroundTransparency=1},{
ab.NewRoundFrame(am,"Squircle",{
ThemeTag={
ImageColor3=ah~="White"and"Button"or nil,
},
ImageColor3=ah=="White"and Color3.new(1,1,1)or nil,
Size=UDim2.new(1,0,1,0),
Name="Squircle",
ImageTransparency=ah=="Primary"and 0 or ah=="White"and 0 or 1
}),

ab.NewRoundFrame(am,"Squircle",{



ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(1,0,1,0),
Name="Special",
ImageTransparency=ah=="Secondary"and 0.95 or 1
}),

ab.NewRoundFrame(am,"Shadow-sm",{



ImageColor3=Color3.new(0,0,0),
Size=UDim2.new(1,3,1,3),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Shadow",

ImageTransparency=1,
Visible=not ak
}),

ab.NewRoundFrame(am,not ak and"SquircleOutline"or"SquircleOutline2",{
ThemeTag={
ImageColor3=ah~="White"and"Outline"or nil,
},
Size=UDim2.new(1,0,1,0),
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=ah=="Primary"and.95 or.85,
Name="SquircleOutline",
},{
ac("UIGradient",{
Rotation=70,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),

ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3=ah~="White"and"Text"or nil
},
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=1
},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
an,
ac("TextLabel",{
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ae or"Button",
ThemeTag={
TextColor3=(ah~="Primary"and ah~="White")and"Text",
},
TextColor3=ah=="Primary"and Color3.new(1,1,1)or ah=="White"and Color3.new(0,0,0)or nil,
AutomaticSize="XY",
TextSize=18,
})
})
})

ab.AddSignal(ao.MouseEnter,function()
ad(ao.Frame,.047,{ImageTransparency=.95}):Play()
end)
ab.AddSignal(ao.MouseLeave,function()
ad(ao.Frame,.047,{ImageTransparency=1}):Play()
end)
ab.AddSignal(ao.MouseButton1Up,function()
if aj then
aj:Close()()
end
if ag then
ab.SafeCallback(ag)
end
end)

return ao
end


return aa end function a.k()
local aa={}

local ab=a.load'b'
local ac=ab.New local ad=
ab.Tween


function aa.New(ae,af,ag,ah,ai,aj,ak,al)
ah=ah or"Input"
local am=ak or 10
local an
if af and af~=""then
an=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local ao=ah~="Input"

local ap=ac("TextBox",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,an and-29 or 0,1,0),
PlaceholderText=ae,
ClearTextOnFocus=al or false,
ClipsDescendants=true,
TextWrapped=ao,
MultiLine=ao,
TextXAlignment="Left",
TextYAlignment=ah=="Input"and"Center"or"Top",

ThemeTag={
PlaceholderColor3="PlaceholderText",
TextColor3="Text",
},
})

local aq=ac("Frame",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1
},{
ac("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(am,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.97,
}),
ab.NewRoundFrame(am,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.95,
},{













}),
ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.95
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,ah=="Input"and 0 or 12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,ah=="Input"and 0 or 12),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment=ah=="Input"and"Center"or"Top",
HorizontalAlignment="Left",
}),
an,
ap,
})
})
})










if aj then
ab.AddSignal(ap:GetPropertyChangedSignal"Text",function()
if ai then
ab.SafeCallback(ai,ap.Text)
end
end)
else
ab.AddSignal(ap.FocusLost,function()
if ai then
ab.SafeCallback(ai,ap.Text)
end
end)
end

return aq
end


return aa end function a.l()
local aa=a.load'b'
local ab=aa.New
local ac=aa.Tween



local ad={
Holder=nil,

Parent=nil,
}

function ad.Init(ae,af)
Window=ae
ad.Parent=af
return ad
end

function ad.Create(ae,af)
local ag={
UICorner=24,
UIPadding=15,
UIElements={}
}

if ae then ag.UIPadding=0 end
if ae then ag.UICorner=26 end

af=af or"Dialog"

if not ae then
ag.UIElements.FullScreen=ab("Frame",{
ZIndex=999,
BackgroundTransparency=1,
BackgroundColor3=Color3.fromHex"#000000",
Size=UDim2.new(1,0,1,0),
Active=false,
Visible=false,
Parent=ad.Parent or(Window and Window.UIElements and Window.UIElements.Main and Window.UIElements.Main.Main)
},{
ab("UICorner",{
CornerRadius=UDim.new(0,Window.UICorner)
})
})
end

ag.UIElements.Main=ab("Frame",{
Size=UDim2.new(0,280,0,0),
ThemeTag={
BackgroundColor3=af.."Background",
},
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=false,
ZIndex=99999,
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,ag.UIPadding),
PaddingLeft=UDim.new(0,ag.UIPadding),
PaddingRight=UDim.new(0,ag.UIPadding),
PaddingBottom=UDim.new(0,ag.UIPadding),
})
})

ag.UIElements.MainContainer=aa.NewRoundFrame(ag.UICorner,"Squircle",{
Visible=false,

ImageTransparency=ae and 0.15 or 0,
Parent=ae and ad.Parent or ag.UIElements.FullScreen,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
AutomaticSize="XY",
ThemeTag={
ImageColor3=af.."Background",
ImageTransparency=af.."BackgroundTransparency",
},
ZIndex=9999,
},{





ag.UIElements.Main,



















})

function ag.Open(ah)
if not ae then
ag.UIElements.FullScreen.Visible=true
ag.UIElements.FullScreen.Active=true
end

task.spawn(function()
ag.UIElements.MainContainer.Visible=true

if not ae then
ac(ag.UIElements.FullScreen,0.1,{BackgroundTransparency=.3}):Play()
end
ac(ag.UIElements.MainContainer,0.1,{ImageTransparency=0}):Play()


task.spawn(function()
task.wait(0.05)
ag.UIElements.Main.Visible=true
end)
end)
end
function ag.Close(ah)
if not ae then
ac(ag.UIElements.FullScreen,0.1,{BackgroundTransparency=1}):Play()
ag.UIElements.FullScreen.Active=false
task.spawn(function()
task.wait(.1)
ag.UIElements.FullScreen.Visible=false
end)
end
ag.UIElements.Main.Visible=false

ac(ag.UIElements.MainContainer,0.1,{ImageTransparency=1}):Play()



task.spawn(function()
task.wait(.1)
if not ae then
ag.UIElements.FullScreen:Destroy()
else
ag.UIElements.MainContainer:Destroy()
end
end)

return function()end
end


return ag
end

return ad end function a.m()
local aa={}


local ab=a.load'b'
local ac=ab.New
local ad=ab.Tween

local ae=a.load'j'.New
local af=a.load'k'.New

function aa.new(ag,ah,ai,aj)
local ak=a.load'l'.Init(nil,ag.ANUI.ScreenGui.KeySystem)
local al=ak.Create(true)

local am={}

local an

local ao=(ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Width)or 200

local ap=430
if ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Image then
ap=430+(ao/2)
end

al.UIElements.Main.AutomaticSize="Y"
al.UIElements.Main.Size=UDim2.new(0,ap,0,0)

local aq

if ag.Icon then

aq=ab.Image(
ag.Icon,
ag.Title..":"..ag.Icon,
0,
"Temp",
"KeySystem",
ag.IconThemed
)
aq.Size=UDim2.new(0,24,0,24)
aq.LayoutOrder=-1
end

local ar=ac("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text=ag.KeySystem.Title or ag.Title,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
TextSize=20
})

local as=ac("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text="Key System",
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,0,0.5,0),
TextTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
TextSize=16
})

local at=ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
aq,ar
})

local au=ac("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





at,as,
})

local av=af("Enter Key","key",nil,"Input",function(av)
an=av
end)

local aw
if ag.KeySystem.Note and ag.KeySystem.Note~=""then
aw=ac("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=ag.KeySystem.Note,
TextSize=18,
TextTransparency=.4,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local ax=ac("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
},{
ac("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
})
})
})


local ay
if ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Image then
local az
if ag.KeySystem.Thumbnail.Title then
az=ac("TextLabel",{
Text=ag.KeySystem.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
ay=ac("ImageLabel",{
Image=ag.KeySystem.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,ao,1,-12),
Position=UDim2.new(0,6,0,6),
Parent=al.UIElements.Main,
ScaleType="Crop"
},{
az,
ac("UICorner",{
CornerRadius=UDim.new(0,20),
})
})
end

ac("Frame",{

Size=UDim2.new(1,ay and-ao or 0,1,0),
Position=UDim2.new(0,ay and ao or 0,0,0),
BackgroundTransparency=1,
Parent=al.UIElements.Main
},{
ac("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
au,
aw,
av,
ax,
ac("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})





local az=ae("Exit","log-out",function()
al:Close()()
end,"Tertiary",ax.Frame)

if ay then
az.Parent=ay
az.Size=UDim2.new(0,0,0,42)
az.Position=UDim2.new(0,10,1,-10)
az.AnchorPoint=Vector2.new(0,1)
end

if ag.KeySystem.URL then
ae("Get key","key",function()
setclipboard(ag.KeySystem.URL)
end,"Secondary",ax.Frame)
end

if ag.KeySystem.API then








local aA=240
local aB=false
local d=ae("Get key","key",nil,"Secondary",ax.Frame)

local e=ab.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,1,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=.9,
})

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=d.Frame,
},{
e,
ac("UIPadding",{
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
})
})

local f=ab.Image(
"chevron-down",
"chevron-down",
0,
"Temp",
"KeySystem",
true
)

f.Size=UDim2.new(1,0,1,0)

ac("Frame",{
Size=UDim2.new(0,21,0,21),
Parent=d.Frame,
BackgroundTransparency=1,
},{
f
})

local g=ab.NewRoundFrame(15,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Background",
},
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,5),
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
PaddingBottom=UDim.new(0,5),
}),
ac("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
})
})

local h=ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,aA,0,0),
ClipsDescendants=true,
AnchorPoint=Vector2.new(1,0),
Parent=d,
Position=UDim2.new(1,0,1,15)
},{
g
})

ac("TextLabel",{
Text="Select Service",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
Parent=g,
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
})
})

for j,l in next,ag.KeySystem.API do
local m=ag.ANUI.Services[l.Type]
if m then
local p={}
for r,u in next,m.Args do
table.insert(p,l[u])
end

local r=m.New(table.unpack(p))
r.Type=l.Type
table.insert(am,r)

local u=ab.Image(
l.Icon or m.Icon or Icons[l.Type]or"user",
l.Icon or m.Icon or Icons[l.Type]or"user",
0,
"Temp",
"KeySystem",
true
)
u.Size=UDim2.new(0,24,0,24)

local v=ab.NewRoundFrame(10,"Squircle",{
Size=UDim2.new(1,0,0,0),
ThemeTag={ImageColor3="Text"},
ImageTransparency=1,
Parent=g,
AutomaticSize="Y",
},{
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,10),
VerticalAlignment="Center",
}),
u,
ac("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,-34,0,0),
AutomaticSize="Y",
},{
ac("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
HorizontalAlignment="Center",
}),
ac("TextLabel",{
Text=l.Title or m.Name,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.05,
TextSize=18,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
}),
ac("TextLabel",{
Text=l.Desc or"",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
Visible=l.Desc and true or false,
TextXAlignment="Left",
})
})
},true)

ab.AddSignal(v.MouseEnter,function()
ad(v,0.08,{ImageTransparency=.95}):Play()
end)
ab.AddSignal(v.InputEnded,function()
ad(v,0.08,{ImageTransparency=1}):Play()
end)
ab.AddSignal(v.MouseButton1Click,function()
r.Copy()
ag.ANUI:Notify{
Title="Key System",
Content="Key link copied to clipboard.",
Image="key",
}
end)
end
end

ab.AddSignal(d.MouseButton1Click,function()
if not aB then
ad(h,.3,{Size=UDim2.new(0,aA,0,g.AbsoluteSize.Y+1)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(f,.3,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
else
ad(h,.25,{Size=UDim2.new(0,aA,0,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(f,.25,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
aB=not aB
end)

end

local function handleSuccess(aA)
al:Close()()
writefile((ag.Folder or"Temp").."/"..ah..".key",tostring(aA))
task.wait(.4)
ai(true)
end

local aA=ae("Submit","arrow-right",function()
local aA=tostring(an or"empty")local aB=
ag.Folder or ag.Title

if ag.KeySystem.KeyValidator then
local d=ag.KeySystem.KeyValidator(aA)

if d then
if ag.KeySystem.SaveKey then
handleSuccess(aA)
else
al:Close()()
task.wait(.4)
ai(true)
end
else
ag.ANUI:Notify{
Title="Key System. Error",
Content="Invalid key.",
Icon="triangle-alert",
}
end
elseif not ag.KeySystem.API then
local d=type(ag.KeySystem.Key)=="table"
and table.find(ag.KeySystem.Key,aA)
or ag.KeySystem.Key==aA

if d then
if ag.KeySystem.SaveKey then
handleSuccess(aA)
else
al:Close()()
task.wait(.4)
ai(true)
end
end
else
local d,e
for f,g in next,am do
local h,j=g.Verify(aA)
if h then
d,e=true,j
break
end
e=j
end

if d then
handleSuccess(aA)
else
ag.ANUI:Notify{
Title="Key System. Error",
Content=e,
Icon="triangle-alert",
}
end
end
end,"Primary",ax)

aA.AnchorPoint=Vector2.new(1,0.5)
aA.Position=UDim2.new(1,0,0.5,0)










al:Open()
end

return aa end function a.n()



local aa=(cloneref or clonereference or function(aa)return aa end)


local function map(ab,ac,ad,ae,af)
return(ab-ac)*(af-ae)/(ad-ac)+ae
end

local function viewportPointToWorld(ab,ac)
local ad=aa(game:GetService"Workspace").CurrentCamera:ScreenPointToRay(ab.X,ab.Y)
return ad.Origin+ad.Direction*ac
end

local function getOffset()
local ab=aa(game:GetService"Workspace").CurrentCamera.ViewportSize.Y
return map(ab,0,2560,8,56)
end

return{viewportPointToWorld,getOffset}end function a.o()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=a.load'b'
local ac=ab.New


local ad,ae=unpack(a.load'n')
local af=Instance.new("Folder",aa(game:GetService"Workspace").CurrentCamera)


local function createAcrylic()
local ag=ac("Part",{
Name="Body",
Color=Color3.new(0,0,0),
Material=Enum.Material.Glass,
Size=Vector3.new(1,1,0),
Anchored=true,
CanCollide=false,
Locked=true,
CastShadow=false,
Transparency=0.98,
},{
ac("SpecialMesh",{
MeshType=Enum.MeshType.Brick,
Offset=Vector3.new(0,0,-1E-6),
}),
})

return ag
end


local function createAcrylicBlur(ag)
local ah={}

ag=ag or 0.001
local ai={
topLeft=Vector2.new(),
topRight=Vector2.new(),
bottomRight=Vector2.new(),
}
local aj=createAcrylic()
aj.Parent=af

local function updatePositions(ak,al)
ai.topLeft=al
ai.topRight=al+Vector2.new(ak.X,0)
ai.bottomRight=al+ak
end

local function render()
local ak=aa(game:GetService"Workspace").CurrentCamera
if ak then
ak=ak.CFrame
end
local al=ak
if not al then
al=CFrame.new()
end

local am=al
local an=ai.topLeft
local ao=ai.topRight
local ap=ai.bottomRight

local aq=ad(an,ag)
local ar=ad(ao,ag)
local as=ad(ap,ag)

local at=(ar-aq).Magnitude
local au=(ar-as).Magnitude

aj.CFrame=
CFrame.fromMatrix((aq+as)/2,am.XVector,am.YVector,am.ZVector)
aj.Mesh.Scale=Vector3.new(at,au,0)
end

local function onChange(ak)
local al=ae()
local am=ak.AbsoluteSize-Vector2.new(al,al)
local an=ak.AbsolutePosition+Vector2.new(al/2,al/2)

updatePositions(am,an)
task.spawn(render)
end

local function renderOnChange()
local ak=aa(game:GetService"Workspace").CurrentCamera
if not ak then
return
end

table.insert(ah,ak:GetPropertyChangedSignal"CFrame":Connect(render))
table.insert(ah,ak:GetPropertyChangedSignal"ViewportSize":Connect(render))
table.insert(ah,ak:GetPropertyChangedSignal"FieldOfView":Connect(render))
task.spawn(render)
end

aj.Destroying:Connect(function()
for ak,al in ah do
pcall(function()
al:Disconnect()
end)
end
end)

renderOnChange()

return onChange,aj
end

return function(ag)
local ah={}
local ai,aj=createAcrylicBlur(ag)

local ak=ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
})

ab.AddSignal(ak:GetPropertyChangedSignal"AbsolutePosition",function()
ai(ak)
end)

ab.AddSignal(ak:GetPropertyChangedSignal"AbsoluteSize",function()
ai(ak)
end)

ah.AddParent=function(al)
ab.AddSignal(al:GetPropertyChangedSignal"Visible",function()
ah.SetVisibility(al.Visible)
end)
end

ah.SetVisibility=function(al)
aj.Transparency=al and 0.98 or 1
end

ah.Frame=ak
ah.Model=aj

return ah
end end function a.p()



local aa=a.load'b'
local ab=a.load'o'

local ac=aa.New

return function(ad)
local ae={}

ae.Frame=ac("Frame",{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,
},{












ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Name="Background",
ThemeTag={
BackgroundColor3="AcrylicMain",
},
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{










}),

ac("ImageLabel",{
Image="rbxassetid://9968344105",
ImageTransparency=0.98,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("ImageLabel",{
Image="rbxassetid://9968344227",
ImageTransparency=0.9,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
ThemeTag={
ImageTransparency="AcrylicNoise",
},
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
ZIndex=2,
},{










}),
})


local af

task.wait()
if ad.UseAcrylic then
af=ab()

af.Frame.Parent=ae.Frame
ae.Model=af.Model
ae.AddParent=af.AddParent
ae.SetVisibility=af.SetVisibility
end

return ae,af
end end function a.q()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab={
AcrylicBlur=a.load'o',

AcrylicPaint=a.load'p',
}

function ab.init()
local ac=Instance.new"DepthOfFieldEffect"
ac.FarIntensity=0
ac.InFocusRadius=0.1
ac.NearIntensity=1

local ad={}

function ab.Enable()
for ae,af in pairs(ad)do
af.Enabled=false
end

local ae=pcall(function()
ac.Parent=aa(game:GetService"Lighting")
end)

if not ae then
pcall(function()
ac.Parent=aa(game:GetService"Workspace").CurrentCamera
end)
end
end

function ab.Disable()
for ae,af in pairs(ad)do
af.Enabled=af.enabled
end
ac.Parent=nil
end

local function registerDefaults()
local function register(ae)
if ae:IsA"DepthOfFieldEffect"then
ad[ae]={enabled=ae.Enabled}
end
end

for ae,af in pairs(aa(game:GetService"Lighting"):GetChildren())do
register(af)
end

if aa(game:GetService"Workspace").CurrentCamera then
for ae,af in pairs(aa(game:GetService"Workspace").CurrentCamera:GetChildren())do
register(af)
end
end
end

registerDefaults()
ab.Enable()
end

return ab end function a.r()

local aa={}

local ab=a.load'b'
local ac=ab.New local ad=
ab.Tween


function aa.new(ae)
local af={
Title=ae.Title or"Dialog",
Content=ae.Content,
Icon=ae.Icon,
IconThemed=ae.IconThemed,
Thumbnail=ae.Thumbnail,
Buttons=ae.Buttons,

IconSize=22,
}

local ag=a.load'l'.Init(nil,ae.ANUI.ScreenGui.Popups)
local ah=ag.Create(true,"Popup")

local ai=200

local aj=430
if af.Thumbnail and af.Thumbnail.Image then
aj=430+(ai/2)
end

ah.UIElements.Main.AutomaticSize="Y"
ah.UIElements.Main.Size=UDim2.new(0,aj,0,0)



local ak

if af.Icon then
ak=ab.Image(
af.Icon,
af.Title..":"..af.Icon,
0,
ae.ANUI.Window,
"Popup",
true,
ae.IconThemed,
"PopupIcon"
)
ak.Size=UDim2.new(0,af.IconSize,0,af.IconSize)
ak.LayoutOrder=-1
end


local al=ac("TextLabel",{
AutomaticSize="Y",
BackgroundTransparency=1,
Text=af.Title,
TextXAlignment="Left",
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="PopupTitle",
},
TextSize=20,
TextWrapped=true,
Size=UDim2.new(1,ak and-af.IconSize-14 or 0,0,0)
})

local am=ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
ak,al
})

local an=ac("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





am,
})

local ao
if af.Content and af.Content~=""then
ao=ac("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=af.Content,
TextSize=18,
TextTransparency=.2,
ThemeTag={
TextColor3="PopupContent",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local ap=ac("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
HorizontalAlignment="Right"
})
})

local aq
if af.Thumbnail and af.Thumbnail.Image then
local ar
if af.Thumbnail.Title then
ar=ac("TextLabel",{
Text=af.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
aq=ac("ImageLabel",{
Image=af.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,ai,1,0),
Parent=ah.UIElements.Main,
ScaleType="Crop"
},{
ar,
ac("UICorner",{
CornerRadius=UDim.new(0,0),
})
})
end

ac("Frame",{

Size=UDim2.new(1,aq and-ai or 0,1,0),
Position=UDim2.new(0,aq and ai or 0,0,0),
BackgroundTransparency=1,
Parent=ah.UIElements.Main
},{
ac("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
an,
ao,
ap,
ac("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})

local ar=a.load'j'.New

for as,at in next,af.Buttons do
ar(at.Title,at.Icon,at.Callback,at.Variant,ap,ah)
end

ah:Open()


return af
end

return aa end function a.s()
return function(aa)
return{
Dark={
Name="Dark",

Accent=Color3.fromHex"#18181b",
Dialog=Color3.fromHex"#161616",
Outline=Color3.fromHex"#FFFFFF",
Text=Color3.fromHex"#FFFFFF",
Placeholder=Color3.fromHex"#7a7a7a",
Background=Color3.fromHex"#101010",
Button=Color3.fromHex"#52525b",
Icon=Color3.fromHex"#a1a1aa",
Toggle=Color3.fromHex"#33C759",
Checkbox=Color3.fromHex"#0091ff",
},
Light={
Name="Light",

Accent=Color3.fromHex"#FFFFFF",
Dialog=Color3.fromHex"#f4f4f5",
Outline=Color3.fromHex"#09090b",
Text=Color3.fromHex"#000000",
Placeholder=Color3.fromHex"#555555",
Background=Color3.fromHex"#e4e4e7",
Button=Color3.fromHex"#18181b",
Icon=Color3.fromHex"#52525b",
},
Rose={
Name="Rose",

Accent=Color3.fromHex"#be185d",
Dialog=Color3.fromHex"#4c0519",
Outline=Color3.fromHex"#fecdd3",
Text=Color3.fromHex"#fdf2f8",
Placeholder=Color3.fromHex"#d67aa6",
Background=Color3.fromHex"#1f0308",
Button=Color3.fromHex"#e11d48",
Icon=Color3.fromHex"#fb7185",
},
Plant={
Name="Plant",

Accent=Color3.fromHex"#166534",
Dialog=Color3.fromHex"#052e16",
Outline=Color3.fromHex"#bbf7d0",
Text=Color3.fromHex"#f0fdf4",
Placeholder=Color3.fromHex"#4fbf7a",
Background=Color3.fromHex"#0a1b0f",
Button=Color3.fromHex"#16a34a",
Icon=Color3.fromHex"#4ade80",
},
Red={
Name="Red",

Accent=Color3.fromHex"#991b1b",
Dialog=Color3.fromHex"#450a0a",
Outline=Color3.fromHex"#fecaca",
Text=Color3.fromHex"#fef2f2",
Placeholder=Color3.fromHex"#d95353",
Background=Color3.fromHex"#1c0606",
Button=Color3.fromHex"#dc2626",
Icon=Color3.fromHex"#ef4444",
},
Indigo={
Name="Indigo",

Accent=Color3.fromHex"#3730a3",
Dialog=Color3.fromHex"#1e1b4b",
Outline=Color3.fromHex"#c7d2fe",
Text=Color3.fromHex"#f1f5f9",
Placeholder=Color3.fromHex"#7078d9",
Background=Color3.fromHex"#0f0a2e",
Button=Color3.fromHex"#4f46e5",
Icon=Color3.fromHex"#6366f1",
},
Sky={
Name="Sky",

Accent=Color3.fromHex"#0369a1",
Dialog=Color3.fromHex"#0c4a6e",
Outline=Color3.fromHex"#bae6fd",
Text=Color3.fromHex"#f0f9ff",
Placeholder=Color3.fromHex"#4fb6d9",
Background=Color3.fromHex"#041f2e",
Button=Color3.fromHex"#0284c7",
Icon=Color3.fromHex"#0ea5e9",
},
Violet={
Name="Violet",

Accent=Color3.fromHex"#6d28d9",
Dialog=Color3.fromHex"#3c1361",
Outline=Color3.fromHex"#ddd6fe",
Text=Color3.fromHex"#faf5ff",
Placeholder=Color3.fromHex"#8f7ee0",
Background=Color3.fromHex"#1e0a3e",
Button=Color3.fromHex"#7c3aed",
Icon=Color3.fromHex"#8b5cf6",
},
Amber={
Name="Amber",

Accent=Color3.fromHex"#b45309",
Dialog=Color3.fromHex"#451a03",
Outline=Color3.fromHex"#fde68a",
Text=Color3.fromHex"#fffbeb",
Placeholder=Color3.fromHex"#d1a326",
Background=Color3.fromHex"#1c1003",
Button=Color3.fromHex"#d97706",
Icon=Color3.fromHex"#f59e0b",
},
Emerald={
Name="Emerald",

Accent=Color3.fromHex"#047857",
Dialog=Color3.fromHex"#022c22",
Outline=Color3.fromHex"#a7f3d0",
Text=Color3.fromHex"#ecfdf5",
Placeholder=Color3.fromHex"#3fbf8f",
Background=Color3.fromHex"#011411",
Button=Color3.fromHex"#059669",
Icon=Color3.fromHex"#10b981",
},
Midnight={
Name="Midnight",

Accent=Color3.fromHex"#1e3a8a",
Dialog=Color3.fromHex"#0c1e42",
Outline=Color3.fromHex"#bfdbfe",
Text=Color3.fromHex"#dbeafe",
Placeholder=Color3.fromHex"#2f74d1",
Background=Color3.fromHex"#0a0f1e",
Button=Color3.fromHex"#2563eb",
Icon=Color3.fromHex"#3b82f6",
},
Crimson={
Name="Crimson",

Accent=Color3.fromHex"#b91c1c",
Dialog=Color3.fromHex"#450a0a",
Outline=Color3.fromHex"#fca5a5",
Text=Color3.fromHex"#fef2f2",
Placeholder=Color3.fromHex"#6f757b",
Background=Color3.fromHex"#0c0404",
Button=Color3.fromHex"#991b1b",
Icon=Color3.fromHex"#dc2626",
},
MonokaiPro={
Name="Monokai Pro",

Accent=Color3.fromHex"#fc9867",
Dialog=Color3.fromHex"#1e1e1e",
Outline=Color3.fromHex"#78dce8",
Text=Color3.fromHex"#fcfcfa",
Placeholder=Color3.fromHex"#6f6f6f",
Background=Color3.fromHex"#191622",
Button=Color3.fromHex"#ab9df2",
Icon=Color3.fromHex"#a9dc76",
},
CottonCandy={
Name="Cotton Candy",

Accent=Color3.fromHex"#ec4899",
Dialog=Color3.fromHex"#2d1b3d",
Outline=Color3.fromHex"#f9a8d4",
Text=Color3.fromHex"#fdf2f8",
Placeholder=Color3.fromHex"#8a5fd3",
Background=Color3.fromHex"#1a0b2e",
Button=Color3.fromHex"#d946ef",
Icon=Color3.fromHex"#06b6d4",
},
Rainbow={
Name="Rainbow",

Accent=aa:Gradient({
["0"]={Color=Color3.fromHex"#00ff41",Transparency=0},
["33"]={Color=Color3.fromHex"#00ffff",Transparency=0},
["66"]={Color=Color3.fromHex"#0080ff",Transparency=0},
["100"]={Color=Color3.fromHex"#8000ff",Transparency=0},
},{
Rotation=45,
}),

Dialog=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0080",Transparency=0},
["25"]={Color=Color3.fromHex"#8000ff",Transparency=0},
["50"]={Color=Color3.fromHex"#0080ff",Transparency=0},
["75"]={Color=Color3.fromHex"#00ff80",Transparency=0},
["100"]={Color=Color3.fromHex"#ff8000",Transparency=0},
},{
Rotation=135,
}),

Outline=Color3.fromHex"#ffffff",
Text=Color3.fromHex"#ffffff",

Placeholder=Color3.fromHex"#00ff80",

Background=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0040",Transparency=0},
["20"]={Color=Color3.fromHex"#ff4000",Transparency=0},
["40"]={Color=Color3.fromHex"#ffff00",Transparency=0},
["60"]={Color=Color3.fromHex"#00ff40",Transparency=0},
["80"]={Color=Color3.fromHex"#0040ff",Transparency=0},
["100"]={Color=Color3.fromHex"#4000ff",Transparency=0},
},{
Rotation=90,
}),

Button=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0080",Transparency=0},
["25"]={Color=Color3.fromHex"#ff8000",Transparency=0},
["50"]={Color=Color3.fromHex"#ffff00",Transparency=0},
["75"]={Color=Color3.fromHex"#80ff00",Transparency=0},
["100"]={Color=Color3.fromHex"#00ffff",Transparency=0},
},{
Rotation=60,
}),

Icon=Color3.fromHex"#ffffff",
},

NordTheme={
Name="Nord",

Accent=Color3.fromHex"#88c0d0",
Dialog=Color3.fromHex"#3b4252",
Outline=Color3.fromHex"#eceff4",
Text=Color3.fromHex"#eceff4",
Placeholder=Color3.fromHex"#81a1c1",
Background=Color3.fromHex"#2e3440",
Button=Color3.fromHex"#5e81ac",
Icon=Color3.fromHex"#8fbcbb",
Toggle=Color3.fromHex"#a3be8c",
Checkbox=Color3.fromHex"#81a1c1",
},
DraculaTheme={
Name="Dracula",

Accent=Color3.fromHex"#ff79c6",
Dialog=Color3.fromHex"#44475a",
Outline=Color3.fromHex"#f8f8f2",
Text=Color3.fromHex"#f8f8f2",
Placeholder=Color3.fromHex"#6272a4",
Background=Color3.fromHex"#282a36",
Button=Color3.fromHex"#bd93f9",
Icon=Color3.fromHex"#50fa7b",
Toggle=Color3.fromHex"#50fa7b",
Checkbox=Color3.fromHex"#8be9fd",
},
TokyoNight={
Name="Tokyo Night",

Accent=Color3.fromHex"#7aa2f7",
Dialog=Color3.fromHex"#16161e",
Outline=Color3.fromHex"#c0caf5",
Text=Color3.fromHex"#c0caf5",
Placeholder=Color3.fromHex"#565f89",
Background=Color3.fromHex"#1a1b26",
Button=Color3.fromHex"#9ece6a",
Icon=Color3.fromHex"#7aa2f7",
Toggle=Color3.fromHex"#9ece6a",
Checkbox=Color3.fromHex"#7aa2f7",
},
OneDark={
Name="One Dark",

Accent=Color3.fromHex"#61afef",
Dialog=Color3.fromHex"#2c323c",
Outline=Color3.fromHex"#abb2bf",
Text=Color3.fromHex"#abb2bf",
Placeholder=Color3.fromHex"#5c6370",
Background=Color3.fromHex"#1e2127",
Button=Color3.fromHex"#e06c75",
Icon=Color3.fromHex"#56b6c2",
Toggle=Color3.fromHex"#98c379",
Checkbox=Color3.fromHex"#61afef",
},
Gruvbox={
Name="Gruvbox",

Accent=Color3.fromHex"#d65c0b",
Dialog=Color3.fromHex"#3c3836",
Outline=Color3.fromHex"#ebdbb2",
Text=Color3.fromHex"#ebdbb2",
Placeholder=Color3.fromHex"#928374",
Background=Color3.fromHex"#282828",
Button=Color3.fromHex"#b8bb26",
Icon=Color3.fromHex"#83a598",
Toggle=Color3.fromHex"#b8bb26",
Checkbox=Color3.fromHex"#d3869b",
},
SolarizedDark={
Name="Solarized Dark",

Accent=Color3.fromHex"#268bd2",
Dialog=Color3.fromHex"#073642",
Outline=Color3.fromHex"#93a1a1",
Text=Color3.fromHex"#93a1a1",
Placeholder=Color3.fromHex"#586e75",
Background=Color3.fromHex"#002b36",
Button=Color3.fromHex"#2aa198",
Icon=Color3.fromHex"#859900",
Toggle=Color3.fromHex"#859900",
Checkbox=Color3.fromHex"#268bd2",
},
MaterialDark={
Name="Material Dark",

Accent=Color3.fromHex"#bb86fc",
Dialog=Color3.fromHex"#1e1e1e",
Outline=Color3.fromHex"#fffbfe",
Text=Color3.fromHex"#e1e1e6",
Placeholder=Color3.fromHex"#8a8a8f",
Background=Color3.fromHex"#121212",
Button=Color3.fromHex"#6200ee",
Icon=Color3.fromHex"#03dac6",
Toggle=Color3.fromHex"#03dac6",
Checkbox=Color3.fromHex"#bb86fc",
},
CyberpunkPink={
Name="Cyberpunk Pink",

Accent=Color3.fromHex"#ff006e",
Dialog=Color3.fromHex"#0a0012",
Outline=Color3.fromHex"#ffbe0b",
Text=Color3.fromHex"#ffffff",
Placeholder=Color3.fromHex"#8338ec",
Background=Color3.fromHex"#050008",
Button=Color3.fromHex"#ff006e",
Icon=Color3.fromHex"#ffbe0b",
Toggle=Color3.fromHex"#06ffa5",
Checkbox=Color3.fromHex"#8338ec",
},
OceanBlue={
Name="Ocean Blue",

Accent=Color3.fromHex"#0a7ea4",
Dialog=Color3.fromHex"#0d2c3e",
Outline=Color3.fromHex"#b0e0e6",
Text=Color3.fromHex"#d4f1f4",
Placeholder=Color3.fromHex"#4a90a4",
Background=Color3.fromHex"#061621",
Button=Color3.fromHex"#1695a0",
Icon=Color3.fromHex"#1db5d9",
Toggle=Color3.fromHex"#40b5b5",
Checkbox=Color3.fromHex"#0a7ea4",
},
NeonGreen={
Name="Neon Green",

Accent=Color3.fromHex"#00ff00",
Dialog=Color3.fromHex"#0a1f0a",
Outline=Color3.fromHex"#00ff00",
Text=Color3.fromHex"#00ff00",
Placeholder=Color3.fromHex"#00aa00",
Background=Color3.fromHex"#001a00",
Button=Color3.fromHex"#00dd00",
Icon=Color3.fromHex"#00ff00",
Toggle=Color3.fromHex"#00ff00",
Checkbox=Color3.fromHex"#00ff66",
},
SoftPastel={
Name="Soft Pastel",

Accent=Color3.fromHex"#e0bbea",
Dialog=Color3.fromHex"#faf5f0",
Outline=Color3.fromHex"#c4b5a0",
Text=Color3.fromHex"#5a4a4a",
Placeholder=Color3.fromHex"#b8a0a0",
Background=Color3.fromHex"#fef9f5",
Button=Color3.fromHex"#d4a5d4",
Icon=Color3.fromHex"#c9a8c9",
Toggle=Color3.fromHex"#a8d4a8",
Checkbox=Color3.fromHex"#b8d4e0",
},
}
end end function a.t()
local aa={}

local ab=a.load'b'
local ac=ab.New local ad=
ab.Tween


function aa.New(ae,af,ag,ah,ai)
local aj=ai or 10
local ak
if af and af~=""then
ak=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local al=ac("TextLabel",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,ak and-29 or 0,1,0),
TextXAlignment="Left",
ThemeTag={
TextColor3=ah and"Placeholder"or"Text",
},
Text=ae,
})

local am=ac("TextButton",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1,
Text="",
},{
ac("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(aj,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.97,
}),
ab.NewRoundFrame(aj,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.95,
},{
ac("UIGradient",{
Rotation=70,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),
ab.NewRoundFrame(aj,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.95
},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ak,
al,
})
})
})

return am
end


return aa end function a.u()
local aa={}

local ab=(cloneref or clonereference or function(ab)return ab end)


local ac=ab(game:GetService"UserInputService")

local ad=a.load'b'
local ae=ad.New local af=
ad.Tween


function aa.New(ag,ah,ai,aj)
local ak=ae("Frame",{
Size=UDim2.new(0,aj,1,0),
BackgroundTransparency=1,
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
Parent=ah,
ZIndex=999,
Active=true,
})

local al=ad.NewRoundFrame(aj/2,"Squircle",{
Size=UDim2.new(1,0,0,0),
ImageTransparency=0.85,
ThemeTag={ImageColor3="Text"},
Parent=ak,
})

local am=ae("Frame",{
Size=UDim2.new(1,12,1,12),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Active=true,
ZIndex=999,
Parent=al,
})

local an=false
local ao=0

local function updateSliderSize()
local ap=ag
local aq=ap.AbsoluteCanvasSize.Y
local ar=ap.AbsoluteWindowSize.Y

if aq<=ar then
al.Visible=false
return
end

local as=math.clamp(ar/aq,0.1,1)
al.Size=UDim2.new(1,0,as,0)
al.Visible=true
end

local function updateScrollingFramePosition()
local ap=al.Position.Y.Scale
local aq=ag.AbsoluteCanvasSize.Y
local ar=ag.AbsoluteWindowSize.Y
local as=math.max(aq-ar,0)

if as<=0 then return end

local at=math.max(1-al.Size.Y.Scale,0)
if at<=0 then return end

local au=ap/at

ag.CanvasPosition=Vector2.new(
ag.CanvasPosition.X,
au*as
)
end

local function updateThumbPosition()
if an then return end

local ap=ag.CanvasPosition.Y
local aq=ag.AbsoluteCanvasSize.Y
local ar=ag.AbsoluteWindowSize.Y
local as=math.max(aq-ar,0)

if as<=0 then
al.Position=UDim2.new(0,0,0,0)
return
end

local at=ap/as
local au=math.max(1-al.Size.Y.Scale,0)
local av=math.clamp(at*au,0,au)

al.Position=UDim2.new(0,0,av,0)
end

ad.AddSignal(ak.InputBegan,function(ap)
if(ap.UserInputType==Enum.UserInputType.MouseButton1 or ap.UserInputType==Enum.UserInputType.Touch)then
local aq=al.AbsolutePosition.Y
local ar=aq+al.AbsoluteSize.Y

if not(ap.Position.Y>=aq and ap.Position.Y<=ar)then
local as=ak.AbsolutePosition.Y
local at=ak.AbsoluteSize.Y
local au=al.AbsoluteSize.Y

local av=ap.Position.Y-as-au/2
local aw=at-au

local ax=math.clamp(av/aw,0,1-al.Size.Y.Scale)

al.Position=UDim2.new(0,0,ax,0)
updateScrollingFramePosition()
end
end
end)

ad.AddSignal(am.InputBegan,function(ap)
if ap.UserInputType==Enum.UserInputType.MouseButton1 or ap.UserInputType==Enum.UserInputType.Touch then
an=true
ao=ap.Position.Y-al.AbsolutePosition.Y

local aq
local ar

aq=ac.InputChanged:Connect(function(as)
if as.UserInputType==Enum.UserInputType.MouseMovement or as.UserInputType==Enum.UserInputType.Touch then
local at=ak.AbsolutePosition.Y
local au=ak.AbsoluteSize.Y
local av=al.AbsoluteSize.Y

local aw=as.Position.Y-at-ao
local ax=au-av

local ay=math.clamp(aw/ax,0,1-al.Size.Y.Scale)

al.Position=UDim2.new(0,0,ay,0)
updateScrollingFramePosition()
end
end)

ar=ac.InputEnded:Connect(function(as)
if as.UserInputType==Enum.UserInputType.MouseButton1 or as.UserInputType==Enum.UserInputType.Touch then
an=false
if aq then aq:Disconnect()end
if ar then ar:Disconnect()end
end
end)
end
end)

ad.AddSignal(ag:GetPropertyChangedSignal"AbsoluteWindowSize",function()
updateSliderSize()
updateThumbPosition()
end)

ad.AddSignal(ag:GetPropertyChangedSignal"AbsoluteCanvasSize",function()
updateSliderSize()
updateThumbPosition()
end)

ad.AddSignal(ag:GetPropertyChangedSignal"CanvasPosition",function()
if not an then
updateThumbPosition()
end
end)

updateSliderSize()
updateThumbPosition()

return ak
end


return aa end function a.v()
local aa={}


local ab=a.load'b'
local ac=ab.New
local ad=ab.Tween

local function Color3ToHSB(ae)
local af,ag,ah=ae.R,ae.G,ae.B
local ai=math.max(af,ag,ah)
local aj=math.min(af,ag,ah)
local ak=ai-aj

local al=0
if ak~=0 then
if ai==af then
al=(ag-ah)/ak%6
elseif ai==ag then
al=(ah-af)/ak+2
else
al=(af-ag)/ak+4
end
al=al*60
else
al=0
end

local am=(ai==0)and 0 or(ak/ai)
local an=ai

return{
h=math.floor(al+0.5),
s=am,
b=an
}
end

local function GetPerceivedBrightness(ae)
local af=ae.R
local ag=ae.G
local ah=ae.B
return 0.299*af+0.587*ag+0.114*ah
end

local function GetTextColorForHSB(ae)
local af=Color3ToHSB(ae)local
ag, ah, ai=af.h, af.s, af.b
if GetPerceivedBrightness(ae)>0.5 then
return Color3.fromHSV(ag/360,0,0.05)
else
return Color3.fromHSV(ag/360,0,0.98)
end
end

local function GetAverageColor(ae)
local af,ag,ah=0,0,0
local ai=ae.Color.Keypoints
for aj,ak in ipairs(ai)do

af=af+ak.Value.R
ag=ag+ak.Value.G
ah=ah+ak.Value.B
end
local aj=#ai
return Color3.new(af/aj,ag/aj,ah/aj)
end


function aa.New(ae,af,ag)
local ah={
Title=af.Title or"Tag",
Icon=af.Icon,
Color=af.Color or Color3.fromHex"#315dff",
Radius=af.Radius or 999,

TagFrame=nil,
Height=26,
Padding=10,
TextSize=14,
IconSize=16,
}

local ai
if ah.Icon then
ai=ab.Image(
ah.Icon,
ah.Icon,
0,
af.Window,
"Tag",
false
)

ai.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
ai.ImageLabel.ImageColor3=typeof(ah.Color)=="Color3"and GetTextColorForHSB(ah.Color)or nil
end

local aj=ac("TextLabel",{
BackgroundTransparency=1,
AutomaticSize="XY",
TextSize=ah.TextSize,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ah.Title,
TextColor3=typeof(ah.Color)=="Color3"and GetTextColorForHSB(ah.Color)or nil,
})

local ak

if typeof(ah.Color)=="table"then

ak=ac"UIGradient"
for al,am in next,ah.Color do
ak[al]=am
end

aj.TextColor3=GetTextColorForHSB(GetAverageColor(ak))
if ai then
ai.ImageLabel.ImageColor3=GetTextColorForHSB(GetAverageColor(ak))
end
end



local al=ab.NewRoundFrame(ah.Radius,"Squircle",{
AutomaticSize="X",
Size=UDim2.new(0,0,0,ah.Height),
Parent=ag,
ImageColor3=typeof(ah.Color)=="Color3"and ah.Color or Color3.new(1,1,1),
},{
ak,
ac("UIPadding",{
PaddingLeft=UDim.new(0,ah.Padding),
PaddingRight=UDim.new(0,ah.Padding),
}),
ai,
aj,
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,ah.Padding/1.5)
})
})


function ah.SetTitle(am,an)
ah.Title=an
aj.Text=an
end

function ah.SetColor(am,an)
ah.Color=an
if typeof(an)=="table"then
local ao=GetAverageColor(an)
ad(aj,.06,{TextColor3=GetTextColorForHSB(ao)}):Play()
local ap=al:FindFirstChildOfClass"UIGradient"or ac("UIGradient",{Parent=al})
for aq,ar in next,an do ap[aq]=ar end
ad(al,.06,{ImageColor3=Color3.new(1,1,1)}):Play()
else
if ak then
ak:Destroy()
end
ad(aj,.06,{TextColor3=GetTextColorForHSB(an)}):Play()
if ai then
ad(ai.ImageLabel,.06,{ImageColor3=GetTextColorForHSB(an)}):Play()
end
ad(al,.06,{ImageColor3=an}):Play()
end
end


return ah
end


return aa end function a.w()
local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=aa(game:GetService"HttpService")

local ac

local ad
ad={
Folder=nil,
Path=nil,
Configs={},
Parser={
Colorpicker={
Save=function(ae)
return{
__type=ae.__type,
value=ae.Default:ToHex(),
transparency=ae.Transparency or nil,
}
end,
Load=function(ae,af)
if ae and ae.Update then
ae:Update(Color3.fromHex(af.value),af.transparency or nil)
end
end
},
Dropdown={
Save=function(ae)
return{
__type=ae.__type,
value=ae.Value,
}
end,
Load=function(ae,af)
if ae and ae.Select then
ae:Select(af.value)
end
end
},
Input={
Save=function(ae)
return{
__type=ae.__type,
value=ae.Value,
}
end,
Load=function(ae,af)
if ae and ae.Set then
ae:Set(af.value)
end
end
},
Keybind={
Save=function(ae)
return{
__type=ae.__type,
value=ae.Value,
}
end,
Load=function(ae,af)
if ae and ae.Set then
ae:Set(af.value)
end
end
},
Slider={
Save=function(ae)
return{
__type=ae.__type,
value=ae.Value.Default,
}
end,
Load=function(ae,af)
if ae and ae.Set then
ae:Set(tonumber(af.value))
end
end
},
Toggle={
Save=function(ae)
return{
__type=ae.__type,
value=ae.Value,
}
end,
Load=function(ae,af)
if ae and ae.Set then
ae:Set(af.value)
end
end
},
}
}

function ad.Init(ae,af)
if not af.Folder then
warn"[ ANUI.ConfigManager ] Window.Folder is not specified."
return false
end

ac=af
ad.Folder=ac.Folder
ad.Path="ANUI/"..tostring(ad.Folder).."/config/"

if not isfolder("ANUI/"..ad.Folder)then
makefolder("ANUI/"..ad.Folder)
if not isfolder("ANUI/"..ad.Folder.."/config/")then
makefolder("ANUI/"..ad.Folder.."/config/")
end
end

local ag=ad:AllConfigs()

for ah,ai in next,ag do
if isfile and readfile and isfile(ai..".json")then
ad.Configs[ai]=readfile(ai..".json")
end
end

return ad
end

function ad.CreateConfig(ae,af,ag)
local ah={
Path=ad.Path..af..".json",
Elements={},
CustomData={},
AutoLoad=ag or false,
Version=1.2,
}

if not af then
return false,"No config file is selected"
end

function ah.SetAsCurrent(ai)
ac:SetCurrentConfig(ah)
end

function ah.Register(ai,aj,ak)
ah.Elements[aj]=ak
end

function ah.Set(ai,aj,ak)
ah.CustomData[aj]=ak
end

function ah.Get(ai,aj)
return ah.CustomData[aj]
end

function ah.SetAutoLoad(ai,aj)
ah.AutoLoad=aj
end

function ah.Save(ai)
if ac.PendingFlags then
for aj,ak in next,ac.PendingFlags do
ah:Register(aj,ak)
end
end

local aj={
__version=ah.Version,
__elements={},
__autoload=ah.AutoLoad,
__custom=ah.CustomData
}

for ak,al in next,ah.Elements do
if ad.Parser[al.__type]then
aj.__elements[tostring(ak)]=ad.Parser[al.__type].Save(al)
end
end

local ak=ab:JSONEncode(aj)
if writefile then
writefile(ah.Path,ak)
end

return aj
end

function ah.Load(ai)
if isfile and not isfile(ah.Path)then
return false,"Config file does not exist"
end

local aj,ak=pcall(function()
local aj=readfile or function()
warn"[ ANUI.ConfigManager ] The config system doesn't work in the studio."
return nil
end
return ab:JSONDecode(aj(ah.Path))
end)

if not aj then
return false,"Failed to parse config file"
end

if not ak.__version then
local al={
__version=ah.Version,
__elements=ak,
__custom={}
}
ak=al
end

if ac.PendingFlags then
for al,am in next,ac.PendingFlags do
ah:Register(al,am)
end
end

for al,am in next,(ak.__elements or{})do
if ah.Elements[al]and ad.Parser[am.__type]then
task.spawn(function()
ad.Parser[am.__type].Load(ah.Elements[al],am)
end)
end
end

ah.CustomData=ak.__custom or{}

return ah.CustomData
end

function ah.Delete(ai)
if not delfile then
return false,"delfile function is not available"
end

if not isfile(ah.Path)then
return false,"Config file does not exist"
end

local aj,ak=pcall(function()
delfile(ah.Path)
end)

if not aj then
return false,"Failed to delete config file: "..tostring(ak)
end

ad.Configs[af]=nil

if ac.CurrentConfig==ah then
ac.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ah.GetData(ai)
return{
elements=ah.Elements,
custom=ah.CustomData,
autoload=ah.AutoLoad
}
end


if isfile(ah.Path)then
local ai,aj=pcall(function()
return ab:JSONDecode(readfile(ah.Path))
end)

if ai and aj and aj.__autoload then
ah.AutoLoad=true

task.spawn(function()
task.wait(0.5)
local ak,al=pcall(function()
return ah:Load()
end)
if ak then
if ac.Debug then print("[ ANUI.ConfigManager ] AutoLoaded config: "..af)end
else
warn("[ ANUI.ConfigManager ] Failed to AutoLoad config: "..af.." - "..tostring(al))
end
end)
end
end


ah:SetAsCurrent()
ad.Configs[af]=ah
return ah
end

function ad.Config(ae,af,ag)
return ad:CreateConfig(af,ag)
end

function ad.GetAutoLoadConfigs(ae)
local af={}

for ag,ah in pairs(ad.Configs)do
if ah.AutoLoad then
table.insert(af,ag)
end
end

return af
end

function ad.DeleteConfig(ae,af)
if not delfile then
return false,"delfile function is not available"
end

local ag=ad.Path..af..".json"

if not isfile(ag)then
return false,"Config file does not exist"
end

local ah,ai=pcall(function()
delfile(ag)
end)

if not ah then
return false,"Failed to delete config file: "..tostring(ai)
end

ad.Configs[af]=nil

if ac.CurrentConfig and ac.CurrentConfig.Path==ag then
ac.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ad.AllConfigs(ae)
if not listfiles then return{}end

local af={}
if not isfolder(ad.Path)then
makefolder(ad.Path)
return af
end

for ag,ah in next,listfiles(ad.Path)do
local ai=ah:match"([^\\/]+)%.json$"
if ai then
table.insert(af,ai)
end
end

return af
end

function ad.GetConfig(ae,af)
return ad.Configs[af]
end

return ad end function a.x()
local aa={}

local ab=a.load'b'
local ac=ab.New
local ad=ab.Tween


local ae=(cloneref or clonereference or function(ae)return ae end)


ae(game:GetService"UserInputService")


function aa.New(af)
local ag={
Button=nil,
CurrentConfig={}
}

local ah













local ai=ac("TextLabel",{
Text=af.Title,
TextSize=10,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
})

local aj=ac("Frame",{
Size=UDim2.new(0,14,0,14),
BackgroundTransparency=1,
Name="Drag",
},{
ac("ImageLabel",{
Image=ab.Icon"move"[1],
ImageRectOffset=ab.Icon"move"[2].ImageRectPosition,
ImageRectSize=ab.Icon"move"[2].ImageRectSize,
Size=UDim2.new(0,9,0,9),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.3,
})
})
local ak=ac("Frame",{
Size=UDim2.new(0,1,1,0),
Position=UDim2.new(0,18,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=.9,
})

local al=ac("Frame",{
Size=UDim2.new(0,0,0,0),
Position=UDim2.new(0.5,0,0,17),
AnchorPoint=Vector2.new(0.5,0.5),
Parent=af.Parent,
BackgroundTransparency=1,
Active=true,
Visible=false,
})
local am=ac("TextButton",{
Size=UDim2.new(0,0,0,22),
AutomaticSize="X",
Parent=al,
Active=false,
BackgroundTransparency=.25,
ZIndex=99,
BackgroundColor3=Color3.new(0,0,0),
},{
ac("UIScale",{
Scale=1,
}),
ac("UICorner",{
CornerRadius=UDim.new(1,0)
}),
ac("UIStroke",{
Thickness=1,
ApplyStrokeMode="Border",
Color=Color3.new(1,1,1),
Transparency=0,
},{
ac("UIGradient",{
Color=ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff")
})
}),
aj,
ak,

ac("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),

ac("TextButton",{
AutomaticSize="XY",
Active=true,
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,14),
BackgroundColor3=Color3.new(1,1,1),
},{
ac("UICorner",{
CornerRadius=UDim.new(1,-4)
}),
ah,
ac("UIListLayout",{
Padding=UDim.new(0,af.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ai,
ac("UIPadding",{
PaddingLeft=UDim.new(0,6),
PaddingRight=UDim.new(0,6),
}),
}),
ac("UIPadding",{
PaddingLeft=UDim.new(0,4),
PaddingRight=UDim.new(0,4),
})
})

ag.Button=am



function ag.SetIcon(an,ao)
if ah then
ah:Destroy()
end
if ao then
ah=ab.Image(
ao,
af.Title,
0,
af.Folder,
"OpenButton",
true,
af.IconThemed
)
ah.Size=UDim2.new(0,11,0,11)
ah.LayoutOrder=-1
ah.Parent=ag.Button.TextButton
end
end

if af.Icon then
ag:SetIcon(af.Icon)
end



ab.AddSignal(am:GetPropertyChangedSignal"AbsoluteSize",function()
al.Size=UDim2.new(
0,am.AbsoluteSize.X,
0,am.AbsoluteSize.Y
)
end)

ab.AddSignal(am.TextButton.MouseEnter,function()
ad(am.TextButton,.1,{BackgroundTransparency=.93}):Play()
end)
ab.AddSignal(am.TextButton.MouseLeave,function()
ad(am.TextButton,.1,{BackgroundTransparency=1}):Play()
end)

ab.Drag(al,{aj,am.TextButton})


function ag.Visible(an,ao)
al.Visible=ao
end

function ag.Edit(an,ao)
for ap,aq in pairs(ao)do
ag.CurrentConfig[ap]=aq
end
local ap=ag.CurrentConfig

local aq={
Title=ap.Title,
Icon=ap.Icon,
Enabled=ap.Enabled,
Position=ap.Position,
OnlyIcon=ap.OnlyIcon or false,
Draggable=ap.Draggable,
OnlyMobile=ap.OnlyMobile,
CornerRadius=ap.CornerRadius or UDim.new(1,0),
StrokeThickness=ap.StrokeThickness or 2,
Color=ap.Color
or ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff"),
}



if aq.Enabled==false then
af.IsOpenButtonEnabled=false
end

if aq.OnlyMobile~=false then
aq.OnlyMobile=true
else
af.IsPC=false
end

if aq.OnlyIcon==true then

local ar=af.IsPC and 50 or 60
aq.Size=UDim2.new(0,ar,0,ar)
aq.CornerRadius=UDim.new(1,0)

if ai then ai.Visible=false end
if aj then aj.Visible=false end
if ak then ak.Visible=false end


am.TextButton.UIPadding.PaddingLeft=UDim.new(0,0)
am.TextButton.UIPadding.PaddingRight=UDim.new(0,0)


am.TextButton.UIListLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
am.TextButton.UIListLayout.VerticalAlignment=Enum.VerticalAlignment.Center


if ah then
ah.Size=UDim2.new(0,ar*0.5,0,ar*0.5)
end


am.AutomaticSize=Enum.AutomaticSize.None
am.Size=aq.Size
am.TextButton.Size=UDim2.new(1,0,1,0)
am.TextButton.AutomaticSize=Enum.AutomaticSize.None

elseif aq.OnlyIcon==false then
ai.Visible=true
if aj then aj.Visible=true end
if ak then ak.Visible=true end

am.TextButton.UIPadding.PaddingLeft=UDim.new(0,6)
am.TextButton.UIPadding.PaddingRight=UDim.new(0,6)

am.TextButton.UIListLayout.HorizontalAlignment=Enum.HorizontalAlignment.Left
am.TextButton.UIListLayout.VerticalAlignment=Enum.VerticalAlignment.Center

if ah then
ah.Size=UDim2.new(0,11,0,11)
end


local ar=af.IsPC and 150 or 60
if not aq.Size then
aq.Size=UDim2.new(0,ar,0,22)
end
am.AutomaticSize=Enum.AutomaticSize.None
am.Size=aq.Size
am.TextButton.Size=UDim2.new(0,0,0,14)
am.TextButton.AutomaticSize=Enum.AutomaticSize.XY
end





if ai then
if aq.Title then
ai.Text=aq.Title
ab:ChangeTranslationKey(ai,aq.Title)
elseif aq.Title==nil then

end
end

if aq.Icon then
ag:SetIcon(aq.Icon)
end

am.UIStroke.UIGradient.Color=aq.Color
if Glow then
Glow.UIGradient.Color=aq.Color
end

am.UICorner.CornerRadius=aq.CornerRadius
am.TextButton.UICorner.CornerRadius=UDim.new(aq.CornerRadius.Scale,aq.CornerRadius.Offset-4)
am.UIStroke.Thickness=aq.StrokeThickness
end

return ag
end



return aa end function a.y()

local aa={}

local ab=a.load'b'
local ac=ab.New
local ad=ab.Tween


function aa.New(ae,af)
local ag={
Container=nil,
ToolTipSize=16,
}

local ah=ac("TextLabel",{
AutomaticSize="XY",
TextWrapped=true,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
Text=ae,
TextSize=17,
TextTransparency=1,
ThemeTag={
TextColor3="Text",
}
})

local ai=ac("UIScale",{
Scale=.9
})

local aj=ac("Frame",{
AnchorPoint=Vector2.new(0.5,0),
AutomaticSize="XY",
BackgroundTransparency=1,
Parent=af,

Visible=false
},{
ac("UISizeConstraint",{
MaxSize=Vector2.new(400,math.huge)
}),
ac("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
LayoutOrder=99,
Visible=false
},{
ac("ImageLabel",{
Size=UDim2.new(0,ag.ToolTipSize,0,ag.ToolTipSize/2),
BackgroundTransparency=1,
Rotation=180,
Image="rbxassetid://89524607682719",
ThemeTag={
ImageColor3="Accent",
},
},{
ac("ImageLabel",{
Size=UDim2.new(0,ag.ToolTipSize,0,ag.ToolTipSize/2),
BackgroundTransparency=1,
LayoutOrder=99,
ImageTransparency=.9,
Image="rbxassetid://89524607682719",
ThemeTag={
ImageColor3="Text",
},
}),
}),
}),
ab.NewRoundFrame(14,"Squircle",{
AutomaticSize="XY",
ThemeTag={
ImageColor3="Accent",
},
ImageTransparency=1,
Name="Background",
},{



ac("Frame",{
ThemeTag={
BackgroundColor3="Text",
},
AutomaticSize="XY",
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,16),
}),
ac("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),

ah,
ac("UIPadding",{
PaddingTop=UDim.new(0,12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,12),
}),
})
}),
ai,
ac("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
})
ag.Container=aj

function ag.Open(ak)
aj.Visible=true


ad(aj.Background,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(ah,.2,{TextTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(ai,.18,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

function ag.Close(ak)

ad(aj.Background,.3,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(ah,.3,{TextTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(ai,.35,{Scale=.9},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(.35)

aj.Visible=false
aj:Destroy()
end

return ag
end



return aa end function a.z()
local aa=a.load'b'
local ab=aa.New
local ac=aa.NewRoundFrame
local ad=aa.Tween



local function Color3ToHSB(ae)
local af,ag,ah=ae.R,ae.G,ae.B
local ai=math.max(af,ag,ah)
local aj=math.min(af,ag,ah)
local ak=ai-aj

local al=0
if ak~=0 then
if ai==af then
al=(ag-ah)/ak%6
elseif ai==ag then
al=(ah-af)/ak+2
else
al=(af-ag)/ak+4
end
al=al*60
else
al=0
end

local am=(ai==0)and 0 or(ak/ai)
local an=ai

return{
h=math.floor(al+0.5),
s=am,
b=an
}
end

local function GetPerceivedBrightness(ae)
local af=ae.R
local ag=ae.G
local ah=ae.B
return 0.299*af+0.587*ag+0.114*ah
end

local function GetTextColorForHSB(ae)
local af=Color3ToHSB(ae)local
ag, ah, ai=af.h, af.s, af.b
if GetPerceivedBrightness(ae)>0.5 then
return Color3.fromHSV(ag/360,0,0.05)
else
return Color3.fromHSV(ag/360,0,0.98)
end
end

local function getElementPosition(ae,af)
if type(af)~="number"or af~=math.floor(af)then
return nil,1
end

local ag=#ae

if ag==0 or af<1 or af>ag then
return nil,2
end

local function isDelimiter(ah)
if ah==nil then return true end
local ai=ah.__type
return ai=="Divider"or ai=="Space"or ai=="Section"or ai=="Code"or ai=="Paragraph"
end

if isDelimiter(ae[af])then
return nil,3
end

local function calculate(ah,ai)
if ai==1 then return"Squircle"end
if ah==1 then return"Squircle-TL-TR"end
if ah==ai then return"Squircle-BL-BR"end
return"Square"
end

local ah=1
local ai=0

for aj=1,ag do
local ak=ae[aj]
if isDelimiter(ak)then
if af>=ah and af<=aj-1 then
local al=af-ah+1
return calculate(al,ai)
end
ah=aj+1
ai=0
else
ai=ai+1
end
end

if af>=ah and af<=ag then
local aj=af-ah+1
return calculate(aj,ai)
end

return nil,4
end

return function(ae)
local af={
Title=ae.Title,
Desc=ae.Desc or nil,
Hover=ae.Hover,
Thumbnail=ae.Thumbnail,
ThumbnailSize=ae.ThumbnailSize or 80,
Image=ae.Image,
IconThemed=ae.IconThemed or false,
ImageSize=ae.ImageSize or 30,
Color=ae.Color,
Scalable=ae.Scalable,
Parent=ae.Parent,
Justify=ae.Justify or"Between",
UIPadding=ae.Window.ElementConfig.UIPadding,
UICorner=ae.Window.ElementConfig.UICorner,
UIElements={},

Index=ae.Index
}

local ag=af.ImageSize
local ah=af.ThumbnailSize
local ai=true
local aj=0

local ak
local al
if af.Thumbnail then
ak=aa.Image(
af.Thumbnail,
af.Title,
ae.Window.NewElements and af.UICorner-11 or(af.UICorner-4),
ae.Window.Folder,
"Thumbnail",
false,
af.IconThemed
)
ak.Size=UDim2.new(1,0,0,ah)
end
if af.Image then
al=aa.Image(
af.Image,
af.Title,
ae.Window.NewElements and af.UICorner-11 or(af.UICorner-4),
ae.Window.Folder,
"Image",
af.IconThemed,
not af.Color and true or false,
"ElementIcon"
)
if typeof(af.Color)=="string"then
al.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
elseif typeof(af.Color)=="Color3"then
al.ImageLabel.ImageColor3=GetTextColorForHSB(af.Color)
end

al.Size=UDim2.new(0,ag,0,ag)

aj=ag
end


local function CreateText(am,an)
local ao=typeof(af.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
or typeof(af.Color)=="Color3"
and GetTextColorForHSB(af.Color)

return ab("TextLabel",{
BackgroundTransparency=1,
Text=am or"",
TextSize=an=="Desc"and 15 or 17,
TextXAlignment="Left",
ThemeTag={
TextColor3=not af.Color and("Element"..an)or nil,
},
TextColor3=af.Color and ao or nil,
TextTransparency=an=="Desc"and.3 or 0,
TextWrapped=true,
Size=UDim2.new(af.Justify=="Between"and 1 or 0,0,0,0),
AutomaticSize=af.Justify=="Between"and"Y"or"XY",
FontFace=Font.new(aa.Font,an=="Desc"and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold)
})
end

local am=CreateText(af.Title,"Title")


local an=ab("Frame",{
Name="DescContainer",
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize=Enum.AutomaticSize.Y,
},{
ab("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,2),
})
})


local function UpdateDesc(ao)

if ae.Window and ae.Window.Closed then
return
end

if not ao or ao==""then
an.Visible=false
return
end
an.Visible=true


local ap=string.split(ao,"\n")
local aq={}
for ar,as in ipairs(ap)do
local at={}
local au=1
while true do
local av,aw=string.find(as,"rbxassetid://%d+",au)
local ax=string.sub(as,au,av and(av-1)or-1)

if ax~=""then
table.insert(at,{Type="Text",Content=ax})
end

if not av then break end

local ay=string.sub(as,av,aw)
table.insert(at,{Type="Image",Content=ay})
au=aw+1
end
table.insert(aq,at)
end


local ar={}
for as,at in ipairs(an:GetChildren())do
if at:IsA"Frame"then table.insert(ar,at)end
end

for as,at in ipairs(aq)do
local au=ar[as]


if not au then
au=ab("Frame",{
Parent=an,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize=Enum.AutomaticSize.Y,
},{
ab("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,4),
VerticalAlignment=Enum.VerticalAlignment.Center
})
})
end
au.LayoutOrder=as
au.Visible=true


local av={}
for aw,ax in ipairs(au:GetChildren())do
if ax:IsA"GuiObject"then table.insert(av,ax)end
end

for aw,ax in ipairs(at)do
local ay=av[aw]


if ay then
local az=ay:IsA"TextLabel"
local aA=ay:IsA"ImageLabel"
if(ax.Type=="Text"and not az)or(ax.Type=="Image"and not aA)then
ay:Destroy()
ay=nil
end
end


if not ay then
if ax.Type=="Text"then
ay=CreateText(ax.Content,"Desc")
ay.Parent=au

else
ay=ab("ImageLabel",{
Parent=au,
BackgroundTransparency=1,
Size=UDim2.new(0,16,0,16),
ScaleType=Enum.ScaleType.Fit,
ThemeTag={ImageColor3="ElementDesc"},
ImageTransparency=0.3
})
end
end


ay.LayoutOrder=aw
ay.Visible=true

if ax.Type=="Text"then
if ay.Text~=ax.Content then
ay.Text=ax.Content
end



if#at==1 then
ay.Size=UDim2.new(1,0,0,0)
ay.AutomaticSize=Enum.AutomaticSize.Y
ay.TextWrapped=true
else


ay.Size=UDim2.new(0,0,0,0)
ay.AutomaticSize=Enum.AutomaticSize.XY
ay.TextWrapped=false
end
else
if ay.Image~=ax.Content then
ay.Image=ax.Content
end

if af.Color then
if typeof(af.Color)=="string"then
ay.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
elseif typeof(af.Color)=="Color3"then
ay.ImageColor3=GetTextColorForHSB(af.Color)
end
end
end
end


for aw=#at+1,#av do
av[aw]:Destroy()
end
end


for as=#aq+1,#ar do
ar[as]:Destroy()
end
end

af.UIElements.Container=ab("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ab("UIListLayout",{
Padding=UDim.new(0,af.UIPadding),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment=af.Justify=="Between"and"Left"or"Center",
}),
ak,
ab("Frame",{
Size=UDim2.new(
af.Justify=="Between"and 1 or 0,
af.Justify=="Between"and-ae.TextOffset or 0,
0,
0
),
AutomaticSize=af.Justify=="Between"and"Y"or"XY",
BackgroundTransparency=1,
Name="TitleFrame",
},{
ab("UIListLayout",{
Padding=UDim.new(0,af.UIPadding),
FillDirection="Horizontal",
VerticalAlignment=(ae.ElementTable and ae.ElementTable.__type=="Dropdown")and"Center"
or((al and ae.ElementTable and ae.ElementTable.__type=="Toggle")and"Center"
or(ae.Window.NewElements and(af.Justify=="Between"and"Top"or"Center")or"Center")),
HorizontalAlignment=af.Justify~="Between"and af.Justify or"Center",
}),
al,
ab("Frame",{
BackgroundTransparency=1,
AutomaticSize=af.Justify=="Between"and"Y"or"XY",
Size=UDim2.new(
af.Justify=="Between"and 1 or 0,
af.Justify=="Between"and(al and-aj-af.UIPadding or-aj)or 0,
1,
0
),
Name="TitleFrame",
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,ae.Window.NewElements and af.UIPadding/2 or 0),
PaddingLeft=UDim.new(0,ae.Window.NewElements and af.UIPadding/2 or 0),
PaddingRight=UDim.new(0,ae.Window.NewElements and af.UIPadding/2 or 0),
PaddingBottom=UDim.new(0,ae.Window.NewElements and af.UIPadding/2 or 0),
}),
ab("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
am,
an
}),
})
})

local ao=aa.Image(
"lock","lock",0,ae.Window.Folder,"Lock",false
)
ao.Size=UDim2.new(0,20,0,20)
ao.ImageLabel.ImageColor3=Color3.new(1,1,1)
ao.ImageLabel.ImageTransparency=.4

local ap=ab("TextLabel",{
Text="Locked",
TextSize=18,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
AutomaticSize="XY",
BackgroundTransparency=1,
TextColor3=Color3.new(1,1,1),
TextTransparency=.05,
})

local aq=ab("Frame",{
Size=UDim2.new(1,af.UIPadding*2,1,af.UIPadding*2),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ZIndex=9999999,
})

local ar,as=ac(af.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=.25,
ImageColor3=Color3.new(0,0,0),
Visible=false,
Active=false,
Parent=aq,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
ao,ap
},nil,true)

local at,au=ac(af.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={ImageColor3="Text"},
Parent=aq,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
},nil,true)

local av,aw=ac(af.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={ImageColor3="Text"},
Parent=aq,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
},nil,true)

local ax,ay=ac(af.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={ImageColor3="Text"},
Parent=aq,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
ab("UIGradient",{
Name="HoverGradient",
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1))
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.25,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.75,0.9),
NumberSequenceKeypoint.new(1,1)
},
}),
},nil,true)

local az,aA=ac(af.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={ImageColor3="Text"},
Parent=aq,
},{
ab("UIGradient",{
Name="HoverGradient",
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1))
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.25,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.75,0.9),
NumberSequenceKeypoint.new(1,1)
},
}),
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
},nil,true)

local aB,d=ac(af.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=af.Color and.05 or.93,
Parent=ae.Parent,
ThemeTag={
ImageColor3=not af.Color and"ElementBackground"or nil
},
ImageColor3=af.Color and
(
typeof(af.Color)=="string"
and Color3.fromHex(aa.Colors[af.Color])
or typeof(af.Color)=="Color3"
and af.Color
)or nil
},{
af.UIElements.Container,
aq,
ab("UIPadding",{
PaddingTop=UDim.new(0,af.UIPadding),
PaddingLeft=UDim.new(0,af.UIPadding),
PaddingRight=UDim.new(0,af.UIPadding),
PaddingBottom=UDim.new(0,af.UIPadding),
}),
},true,true)

af.UIElements.Main=aB
af.UIElements.Locked=ar

if af.Hover then
aa.AddSignal(aB.MouseEnter,function()
if ai then
ad(aB,.12,{ImageTransparency=af.Color and.15 or.9}):Play()
ad(az,.12,{ImageTransparency=.9}):Play()
ad(ax,.12,{ImageTransparency=.8}):Play()
aa.AddSignal(aB.MouseMoved,function(e,f)
az.HoverGradient.Offset=Vector2.new(((e-aB.AbsolutePosition.X)/aB.AbsoluteSize.X)-0.5,0)
ax.HoverGradient.Offset=Vector2.new(((e-aB.AbsolutePosition.X)/aB.AbsoluteSize.X)-0.5,0)
end)
end
end)
aa.AddSignal(aB.InputEnded,function()
if ai then
ad(aB,.12,{ImageTransparency=af.Color and.05 or.93}):Play()
ad(az,.12,{ImageTransparency=1}):Play()
ad(ax,.12,{ImageTransparency=1}):Play()
end
end)
end

function af.SetTitle(e,f)
af.Title=f
am.Text=f
end

function af.SetDesc(e,f)

if af.Desc==f then
return
end

af.Desc=f
UpdateDesc(f)

if ae.ElementTable then
ae.ElementTable.Desc=f
end
end


UpdateDesc(af.Desc)

function af.Colorize(e,f,g)
if af.Color then
f[g]=typeof(af.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
or typeof(af.Color)=="Color3"
and GetTextColorForHSB(af.Color)
or nil
end
end

if ae.ElementTable then
aa.AddSignal(am:GetPropertyChangedSignal"Text",function()
if af.Title~=am.Text then
af:SetTitle(am.Text)
ae.ElementTable.Title=am.Text
end
end)
end

function af.SetThumbnail(e,f,g)
af.Thumbnail=f
if g then
af.ThumbnailSize=g
ah=g
end

if ak then
if f then
ak:Destroy()
ak=aa.Image(
f,
af.Title,
af.UICorner-3,
ae.Window.Folder,
"Thumbnail",
false,
af.IconThemed
)
ak.Size=UDim2.new(1,0,0,ah)
ak.Parent=af.UIElements.Container
local h=af.UIElements.Container:FindFirstChild"UIListLayout"
if h then
ak.LayoutOrder=-1
end
else
ak.Visible=false
end
else
if f then
ak=aa.Image(
f,
af.Title,
af.UICorner-3,
ae.Window.Folder,
"Thumbnail",
false,
af.IconThemed
)
ak.Size=UDim2.new(1,0,0,ah)
ak.Parent=af.UIElements.Container
local h=af.UIElements.Container:FindFirstChild"UIListLayout"
if h then
ak.LayoutOrder=-1
end
end
end
end

function af.SetImage(e,f,g)
af.Image=f
if g then
af.ImageSize=g
ag=g
end

local h=al
if f then
local j=aa.Image(
f,
af.Title,
af.UICorner-3,
ae.Window.Folder,
"Image",
not af.Color and true or false
)
if typeof(af.Color)=="string"and j.ImageLabel then
j.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
elseif typeof(af.Color)=="Color3"and j.ImageLabel then
j.ImageLabel.ImageColor3=GetTextColorForHSB(af.Color)
end
j.Visible=true
j.Size=UDim2.new(0,ag,0,ag)
aj=ag
if h and h.Parent then h:Destroy()end
j.Parent=af.UIElements.Container.TitleFrame
al=j
else
if al then
al.Visible=false
end
aj=0
end

af.UIElements.Container.TitleFrame.TitleFrame.Size=UDim2.new(1,-aj,1,0)
end

function af.Destroy(e)
aB:Destroy()
end

function af.Lock(e,f)
ai=false
ap.Text=f or"Locked"
ar.Active=true
ar.Visible=true
end

function af.Unlock(e)
ai=true
ar.Active=false
ar.Visible=false
end

function af.Highlight(e)
local f=ab("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1))
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.1,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.9,0.9),
NumberSequenceKeypoint.new(1,1)
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=at
})

local g=ab("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1))
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.15,0.8),
NumberSequenceKeypoint.new(0.5,0.1),
NumberSequenceKeypoint.new(0.85,0.8),
NumberSequenceKeypoint.new(1,1)
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=av
})

at.ImageTransparency=0.65
av.ImageTransparency=0.88

ad(f,0.75,{
Offset=Vector2.new(1,0)
}):Play()

ad(g,0.75,{
Offset=Vector2.new(1,0)
}):Play()

task.spawn(function()
task.wait(.75)
at.ImageTransparency=1
av.ImageTransparency=1
f:Destroy()
g:Destroy()
end)
end

function af.UpdateShape(e)
if ae.Window.NewElements then
local f
local g=ae.ParentType or(ae.ParentConfig and ae.ParentConfig.ParentType)
if g=="Group"or g=="Paragraph"then
f="Squircle"
else
f=getElementPosition(e.Elements,af.Index)
end

if f and aB then
d:SetType(f)
as:SetType(f)
aw:SetType(f)
au:SetType(f.."-Outline")
aA:SetType(f)
ay:SetType(f.."-Outline")
end
end
end

return af
end end function a.A()
local aa=a.load'b'
local ab=aa.New
local ac=aa.Tween

local ad={}
local ae=a.load'j'.New


local function GetGradientData(af)
if typeof(af)=="ColorSequence"then
return af
elseif typeof(af)=="Color3"then
return ColorSequence.new(af)
else
return ColorSequence.new(Color3.fromRGB(80,80,80))
end
end

function ad.New(af,ag)
ag.Hover=false
ag.TextOffset=0
ag.ParentConfig=ag

local ah={
__type="Paragraph",
Title=ag.Title or"Paragraph",
Desc=ag.Desc or nil,
Locked=ag.Locked or false,
Elements={}
}

local ai=a.load'z'(ag)
ah.ParagraphFrame=ai


function ah.SetTitle(aj,ak)
aj.Title=ak
if aj.ParagraphFrame.UIElements.Title then
aj.ParagraphFrame.UIElements.Title.Text=ak
end
end

function ah.SetDesc(aj,ak)
aj.Desc=ak
if aj.ParagraphFrame.UIElements.Description then
aj.ParagraphFrame.UIElements.Description.Text=ak
end
end




function ah.SetViewport(aj,ak,al)
if not aj.ParagraphFrame then return end


if aj.ViewportFrame then
aj.ViewportFrame:Destroy()
end

local am=aj.ParagraphFrame.UIElements.Main

local an=ab("ViewportFrame",{
Name="ModelPreview",
Size=UDim2.new(0,95,0,95),
Position=UDim2.new(1,-100,0.5,-47),
BackgroundTransparency=1,
Parent=am,
ZIndex=10
})

local ao=ab("WorldModel",{Parent=an})

if ak then
local ap=ak:Clone()

ap:PivotTo(CFrame.new(0,0,0))
ap.Parent=ao local


aq, ar=ap:GetBoundingBox()
local as=Vector3.new(0,ar.Y/2,0)

local at=ab("Camera",{
FieldOfView=50,
Parent=an
})


local au=al or Vector3.new(0,0.8,-4.2)


at.CFrame=CFrame.lookAt(as+au,as)
an.CurrentCamera=at
end


if am:FindFirstChild"UIElements"and am.UIElements:FindFirstChild"Content"then
am.UIElements.Content.PaddingRight=UDim.new(0,105)
end

aj.ViewportFrame=an
return an
end


if ag.Images and#ag.Images>0 then
local aj=ab("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
Parent=ai.UIElements.Container,
LayoutOrder=2
},{
ab("UIGridLayout",{
CellSize=ag.ImageSize or UDim2.new(0,70,0,70),
CellPadding=UDim2.new(0,8,0,8),
FillDirection=Enum.FillDirection.Horizontal,
SortOrder=Enum.SortOrder.LayoutOrder,
HorizontalAlignment=Enum.HorizontalAlignment.Center,
}),
ab("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingBottom=UDim.new(0,10)
})
})

for ak,al in ipairs(ag.Images)do
local am=al.Title or"Item"
local an=al.Quantity
local ao=al.Image
local ap=GetGradientData(al.Gradient)
local aq=ap.Keypoints[1].Value
local ar=(type(al.Callback)=="function")

local as=aa.NewRoundFrame(8,"Squircle",{
ImageColor3=aq,
ClipsDescendants=true,
Parent=aj,
Active=ar
},{
ab("ImageLabel",{
Image="rbxassetid://5554236805",
ScaleType=Enum.ScaleType.Slice,
SliceCenter=Rect.new(23,23,277,277),
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ImageColor3=Color3.new(0,0,0),
ImageTransparency=0.4,
ZIndex=2,
}),

aa.NewRoundFrame(8,"Squircle",{
Size=UDim2.new(1,-4,1,-4),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageColor3=Color3.new(1,1,1),
ClipsDescendants=true,
ZIndex=3,
},{
ab("UIGradient",{Color=ap,Rotation=45}),
aa.Image(ao,am,0,ag.Window.Folder,"CardIcon",false).ImageLabel,

an and ab("TextLabel",{
Text=an,
Size=UDim2.new(1,-8,0,12),
Position=UDim2.new(0,4,0,2),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
TextSize=10,
TextStrokeTransparency=0.5,
ZIndex=5,
})or nil,

ab("Frame",{
Size=UDim2.new(1,0,0,18),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.4,
BorderSizePixel=0,
ZIndex=6,
},{
ab("TextLabel",{
Text=am,
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Center,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
TextSize=9,
TextTruncate=Enum.TextTruncate.AtEnd,
ZIndex=7,
})
})
})
},ar)

local at=as:FindFirstChild("ImageLabel",true)
if at then
at.Size=UDim2.new(0.65,0,0.65,0)
at.AnchorPoint=Vector2.new(0.5,0.5)
at.Position=UDim2.new(0.5,0,0.45,0)
at.BackgroundTransparency=1
at.ScaleType=Enum.ScaleType.Fit
at.ZIndex=4
end

if ar then
aa.AddSignal(as.MouseButton1Click,function()al.Callback()end)
aa.AddSignal(as.MouseButton1Down,function()
ac(as,0.1,{Size=UDim2.new(0,ag.ImageSize.X.Offset*0.95,0,ag.ImageSize.Y.Offset*0.95)}):Play()
end)
aa.AddSignal(as.MouseButton1Up,function()ac(as,0.1,{Size=ag.ImageSize}):Play()end)
aa.AddSignal(as.MouseLeave,function()ac(as,0.1,{Size=ag.ImageSize}):Play()end)
end
end
end


if ag.Buttons and#ag.Buttons>0 then
local aj=ab("Frame",{
Size=UDim2.new(1,0,0,38),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ai.UIElements.Container,
LayoutOrder=3
},{
ab("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
})
})

for ak,al in next,ag.Buttons do
local am=ae(al.Title,al.Icon,al.Callback,"White",aj,nil,nil,ag.Window.NewElements and 12 or 10)
am.Size=UDim2.new(1,0,0,38)
end
end

return ah.__type,ah
end

return ad end function a.B()
local aa=a.load'b'local ab=
aa.New

local ac={}

function ac.New(ad,ae)
local af={
__type="Button",
Title=ae.Title or"Button",
Desc=ae.Desc or nil,
Icon=ae.Icon or"mouse-pointer-click",
IconThemed=ae.IconThemed or false,
Color=ae.Color,
Justify=ae.Justify or"Between",
IconAlign=ae.IconAlign or"Right",
Locked=ae.Locked or false,
Callback=ae.Callback or function()end,
UIElements={}
}

local ag=true

af.ButtonFrame=a.load'z'{
Title=af.Title,
Desc=af.Desc,
Parent=ae.Parent,




Window=ae.Window,
Color=af.Color,
Justify=af.Justify,
TextOffset=20,
Hover=true,
Scalable=true,
Tab=ae.Tab,
Index=ae.Index,
ElementTable=af,
ParentConfig=ae,
ParentType=ae.ParentType,
}














af.UIElements.ButtonIcon=aa.Image(
af.Icon,
af.Icon,
0,
ae.Window.Folder,
"Button",
not af.Color and true or nil,
af.IconThemed
)

af.UIElements.ButtonIcon.Size=UDim2.new(0,20,0,20)
af.UIElements.ButtonIcon.Parent=af.Justify=="Between"and af.ButtonFrame.UIElements.Main or af.ButtonFrame.UIElements.Container.TitleFrame
af.UIElements.ButtonIcon.LayoutOrder=af.IconAlign=="Left"and-99999 or 99999
af.UIElements.ButtonIcon.AnchorPoint=Vector2.new(1,0.5)
af.UIElements.ButtonIcon.Position=UDim2.new(1,0,0.5,0)

af.ButtonFrame:Colorize(af.UIElements.ButtonIcon.ImageLabel,"ImageColor3")

function af.Lock(ah)
af.Locked=true
ag=false
return af.ButtonFrame:Lock()
end
function af.Unlock(ah)
af.Locked=false
ag=true
return af.ButtonFrame:Unlock()
end

if af.Locked then
af:Lock()
end

aa.AddSignal(af.ButtonFrame.UIElements.Main.MouseButton1Click,function()
if ag then
task.spawn(function()
aa.SafeCallback(af.Callback)
end)
end
end)
return af.__type,af
end

return ac end function a.C()
local aa={}

local ab=a.load'b'
local ac=ab.New
local ad=ab.Tween

local ae=game:GetService"UserInputService"

function aa.New(af,ag,ah,ai,aj,ak,al)
local am={}

local an=12
local ao
if ag and ag~=""then
ao=ac("ImageLabel",{
Size=UDim2.new(1,-7,1,-7),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Image=ab.Icon(ag)[1],
ImageRectOffset=ab.Icon(ag)[2].ImageRectPosition,
ImageRectSize=ab.Icon(ag)[2].ImageRectSize,
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
})
end

local ap=ac("Frame",{
Size=UDim2.new(0,2,0,26),
BackgroundTransparency=1,
Parent=ai,
})

local aq=ab.NewRoundFrame(an,"Squircle",{
ImageTransparency=.85,
ThemeTag={
ImageColor3="Text"
},
Parent=ap,
Size=UDim2.new(0,ak and(52)or(40.8),0,24),
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(0,0,0.5,0),
},{
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Toggle",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(an,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
},{
ac("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
}
})
}),


ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(0,ak and 30 or 20,0,20),
Position=UDim2.new(0,2,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ImageTransparency=1,
Name="Frame",
},{
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0,
ThemeTag={
ImageColor3="ToggleBar",
},
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Bar"
},{
ab.NewRoundFrame(an,"SquircleOutline2",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=.45,
},{
ac("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
ao,
ac("UIScale",{
Scale=1,
})
}),
})
})

local ar
local as

local at=ak and 30 or 20
local au=aq.Size.X.Offset

function am.Set(av,aw,ax,ay)
if not ay then
if aw then
ad(aq.Frame,0.15,{
Position=UDim2.new(0,au-at-2,0.5,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(aq.Layer,0.1,{
ImageTransparency=0,
}):Play()

if ao then
ad(ao,0.1,{
ImageTransparency=0,
}):Play()
end
else
ad(aq.Frame,0.15,{
Position=UDim2.new(0,2,0.5,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(aq.Layer,0.1,{
ImageTransparency=1,
}):Play()

if ao then
ad(ao,0.1,{
ImageTransparency=1,
}):Play()
end
end
end

ax=ax~=false

task.spawn(function()
if aj and ax then
ab.SafeCallback(aj,aw)
end
end)
end


function am.Animate(av,aw,ax)
if not al.Window.IsToggleDragging then
al.Window.IsToggleDragging=true

local ay=aw.Position.X
local az=aw.Position.Y
local aA=aq.Frame.Position.X.Offset
local aB=false

ad(aq.Frame.Bar.UIScale,0.28,{Scale=1.5},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(aq.Frame.Bar,0.28,{ImageTransparency=.85},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if ar then
ar:Disconnect()
end

ar=ae.InputChanged:Connect(function(d)
if al.Window.IsToggleDragging and(d.UserInputType==Enum.UserInputType.MouseMovement or d.UserInputType==Enum.UserInputType.Touch)then
if aB then
return
end

local e=math.abs(d.Position.X-ay)
local f=math.abs(d.Position.Y-az)

if f>e and f>10 then
aB=true
al.Window.IsToggleDragging=false

if ar then
ar:Disconnect()
ar=nil
end
if as then
as:Disconnect()
as=nil
end

ad(aq.Frame,0.15,{
Position=UDim2.new(0,aA,0.5,0)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ad(aq.Frame.Bar.UIScale,0.23,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(aq.Frame.Bar,0.23,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return
end

local g=d.Position.X-ay
local h=math.max(2,math.min(aA+g,au-at-2))

ad(aq.Frame,0.05,{
Position=UDim2.new(0,h,0.5,0)
},Enum.EasingStyle.Linear,Enum.EasingDirection.Out):Play()
end
end)

if as then
as:Disconnect()
end

as=ae.InputEnded:Connect(function(d)
if al.Window.IsToggleDragging and(d.UserInputType==Enum.UserInputType.MouseButton1 or d.UserInputType==Enum.UserInputType.Touch)then
al.Window.IsToggleDragging=false

if ar then
ar:Disconnect()
ar=nil
end

if as then
as:Disconnect()
as=nil
end

if aB then
return
end

local e=aq.Frame.Position.X.Offset
local f=math.abs(d.Position.X-ay)

if f<10 then
ax:Set(not ax.Value,true,false)
else
local g=e+at/2
local h=au/2
local j=g>h
ax:Set(j,true,false)
end

ad(aq.Frame.Bar.UIScale,0.23,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(aq.Frame.Bar,0.23,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end)
end
end

return ap,am
end

return aa end function a.D()
local aa={}

local ab=a.load'b'
local ac=ab.New
local ad=ab.Tween


function aa.New(ae,af,ag,ah,ai,aj)
local ak={}

af=af or"sfsymbols:checkmark"

local al=9

local am=ab.Image(
af,
af,
0,
(aj and aj.Window.Folder or"Temp"),
"Checkbox",
true,
false,
"CheckboxIcon"
)
am.Size=UDim2.new(1,-26+ag,1,-26+ag)
am.AnchorPoint=Vector2.new(0.5,0.5)
am.Position=UDim2.new(0.5,0,0.5,0)


local an=ab.NewRoundFrame(al,"Squircle",{
ImageTransparency=.85,
ThemeTag={
ImageColor3="Text"
},
Parent=ah,
Size=UDim2.new(0,26,0,26),
},{
ab.NewRoundFrame(al,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Checkbox",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(al,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
},{
ac("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
}
})
}),

am,
})

function ak.Set(ao,ap)
if ap then
ad(an.Layer,0.06,{
ImageTransparency=0,
}):Play()



ad(am.ImageLabel,0.06,{
ImageTransparency=0,
}):Play()
else
ad(an.Layer,0.05,{
ImageTransparency=1,
}):Play()



ad(am.ImageLabel,0.06,{
ImageTransparency=1,
}):Play()
end

task.spawn(function()
if ai then
ab.SafeCallback(ai,ap)
end
end)
end

return an,ak
end


return aa end function a.E()
local aa=a.load'b'
local ab=aa.New local ac=
aa.Tween

local ad=a.load'C'.New
local ae=a.load'D'.New

local af={}

function af.New(ag,ah)
local ai={
__type="Toggle",
Title=ah.Title or"Toggle",
Desc=ah.Desc or nil,
Locked=ah.Locked or false,
Value=ah.Value,
Icon=ah.Icon or nil,
IconSize=ah.IconSize or 23,
Image=ah.Image,
ImageSize=ah.ImageSize or 30,
Thumbnail=ah.Thumbnail,
ThumbnailSize=ah.ThumbnailSize or 80,
Type=ah.Type or"Toggle",
Callback=ah.Callback or function()end,
UIElements={}
}


local aj=ai.Image
if typeof(aj)=="table"then
aj=nil
end

ai.ToggleFrame=a.load'z'{
Title=ai.Title,
Desc=ai.Desc,
Image=aj,
ImageSize=ai.ImageSize,
Thumbnail=ai.Thumbnail,
ThumbnailSize=ai.ThumbnailSize,
Window=ah.Window,
Parent=ah.Parent,
TextOffset=(52),
Hover=false,
Tab=ah.Tab,
Index=ah.Index,
ElementTable=ai,
ParentConfig=ah,
ParentType=ah.ParentType,
}

local ak=true

if ai.Value==nil then
ai.Value=false
end


function ai.SetMainImage(al,am,an)
local ao=ai.ToggleFrame.UIElements.Container:FindFirstChild"TitleFrame"
if not ao then return end

local ap=ao:FindFirstChild"CustomMainIcon"
if ap then ap:Destroy()end

for aq,ar in ipairs(ao:GetChildren())do
if ar:IsA"Frame"and ar.Name~="TitleFrame"and ar.Name~="UIListLayout"and ar.Name~="CustomMainIcon"then
ar:Destroy()
end
end

if not am then
local aq=ao:FindFirstChild"TitleFrame"
if aq then aq.Size=UDim2.new(1,0,1,0)end
return
end

local aq=an or ai.ImageSize or 30
if typeof(aq)=="number"then
aq=UDim2.new(0,aq,0,aq)
end

local ar


if typeof(am)=="table"then
local as=am
local at=as.Image or""
local au=as.Gradient
local av=as.Quantity
local aw=as.Rate
local ax=as.Title

local ay
if typeof(au)=="ColorSequence"then
ay=au
elseif typeof(au)=="Color3"then
ay=ColorSequence.new(au)
else
ay=ColorSequence.new(Color3.fromRGB(80,80,80))
end

local az=ay.Keypoints[1].Value
local aA=2


ar=aa.NewRoundFrame(8,"Squircle",{
Name="CustomMainIcon",
Size=aq,
Parent=ao,
ImageColor3=az,
ClipsDescendants=true,
LayoutOrder=-1,
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,0,0.5,0),
},{

ab("ImageLabel",{
Image="rbxassetid://5554236805",
ScaleType=Enum.ScaleType.Slice,
SliceCenter=Rect.new(23,23,277,277),
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ImageColor3=Color3.new(0,0,0),
ImageTransparency=0.4,
ZIndex=2,
}),

aa.NewRoundFrame(8,"Squircle",{
Size=UDim2.new(1,-aA*2,1,-aA*2),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageColor3=Color3.new(1,1,1),
ClipsDescendants=true,
ZIndex=3,
},{

ab("UIGradient",{
Color=ay,
Rotation=45,
}),

ab("ImageLabel",{
Image=at,
Size=UDim2.new(0.65,0,0.65,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.45,0),
BackgroundTransparency=1,
ScaleType="Fit",
ZIndex=4,
}),


av and ab("TextLabel",{
Text=av,
Size=UDim2.new(0.5,0,0,12),
Position=UDim2.new(0,4,0,2),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
TextSize=8,
TextStrokeTransparency=0,
TextStrokeColor3=Color3.new(0,0,0),

ZIndex=5,
})or nil,


aw and ab("TextLabel",{
Text=aw,
Size=UDim2.new(0.5,-4,0,12),
Position=UDim2.new(1,-4,0,2),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Right,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
TextSize=11,
TextStrokeTransparency=0,
TextStrokeColor3=Color3.new(0,0,0),
TextWrapped=true,
ZIndex=5,
})or nil,


ax and ab("Frame",{
Size=UDim2.new(1,0,0,18),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.4,
BorderSizePixel=0,
ZIndex=6,
},{
ab("TextLabel",{
Text=ax,
Size=UDim2.new(1,-2,1,0),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Center,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
TextSize=10,
TextWrapped=true,
ZIndex=7,
})
})or nil
})
})


else
ar=aa.Image(
am,
ai.Title,
ah.Window.NewElements and 12 or 6,
ah.Window.Folder,
"ToggleIcon",
false
)
ar.Name="CustomMainIcon"
ar.Parent=ao
ar.Size=aq
ar.LayoutOrder=-1
ar.AnchorPoint=Vector2.new(0,0.5)
ar.Position=UDim2.new(0,0,0.5,0)
ar.BackgroundTransparency=1
end

local as=ao:FindFirstChild"TitleFrame"
if as then
as.Size=UDim2.new(1,-aq.X.Offset,1,0)
end
end

if typeof(ai.Image)=="table"then
ai:SetMainImage(ai.Image,ai.ImageSize)
end


function ai.Lock(al,am)
ai.Locked=true
ak=false
return ai.ToggleFrame:Lock(am)
end
function ai.Unlock(al)
ai.Locked=false
ak=true
return ai.ToggleFrame:Unlock()
end

if ai.Locked then
ai:Lock()
end

local al=ai.Value

local am,an
if ai.Type=="Toggle"then
am,an=ad(al,ai.Icon,ai.IconSize,ai.ToggleFrame.UIElements.Main,ai.Callback,ah.Window.NewElements,ah)
elseif ai.Type=="Checkbox"then
am,an=ae(al,ai.Icon,ai.IconSize,ai.ToggleFrame.UIElements.Main,ai.Callback,ah)
else
error("Unknown Toggle Type: "..tostring(ai.Type))
end

am.AnchorPoint=Vector2.new(1,ah.Window.NewElements and 0 or 0.5)
am.Position=UDim2.new(1,0,ah.Window.NewElements and 0 or 0.5,0)

function ai.Set(ao,ap,aq,ar)
if ak then
an:Set(ap,aq,ar or false)
al=ap
ai.Value=ap
end
end

ai:Set(al,false,ah.Window.NewElements)


if ah.Window.NewElements and an.Animate then
aa.AddSignal(ai.ToggleFrame.UIElements.Main.InputBegan,function(ao)
if ao.UserInputType==Enum.UserInputType.MouseButton1 or ao.UserInputType==Enum.UserInputType.Touch then
an:Animate(ao,ai)
end
end)
else
aa.AddSignal(ai.ToggleFrame.UIElements.Main.MouseButton1Click,function()
ai:Set(not ai.Value,nil,ah.Window.NewElements)
end)
end

return ai.__type,ai
end

return af end function a.F()
local aa=a.load'b'
local ab=aa.New
local ac=aa.Tween

local ad=(cloneref or clonereference or function(ad)return ad end)


local ae={}

local af=false

function ae.New(ag,ah)
local ai={
__type="Slider",
Title=ah.Title or"Slider",
Desc=ah.Desc or nil,
Locked=ah.Locked or nil,
Value=ah.Value or{
Min=ah.Min or 0,
Max=ah.Max or 100,
Default=ah.Default or 0
},
Step=ah.Step or 1,
Callback=ah.Callback or function()end,
UIElements={},
IsFocusing=false,

Width=130,
TextBoxWidth=30,
ThumbSize=13,
}
local aj
local ak
local al
local am=ai.Value.Default or ai.Value.Min or 0

local an=am
local ao=(am-(ai.Value.Min or 0))/((ai.Value.Max or 100)-(ai.Value.Min or 0))

local ap=true
local aq=ai.Step%1~=0

local function FormatValue(ar)
if aq then
return string.format("%.2f",ar)
else
return tostring(math.floor(ar+0.5))
end
end

local function CalculateValue(ar)
if aq then
return math.floor(ar/ai.Step+0.5)*ai.Step
else
return math.floor(ar/ai.Step+0.5)*ai.Step
end
end

ai.SliderFrame=a.load'z'{
Title=ai.Title,
Desc=ai.Desc,
Parent=ah.Parent,
TextOffset=ai.Width,
Hover=false,
Tab=ah.Tab,
Index=ah.Index,
Window=ah.Window,
ElementTable=ai,
ParentConfig=ah,
ParentType=ah.ParentType,
}

ai.UIElements.SliderIcon=aa.NewRoundFrame(99,"Squircle",{
ImageTransparency=.95,
Size=UDim2.new(1,-ai.TextBoxWidth-8,0,4),
Name="Frame",
ThemeTag={
ImageColor3="Text",
},
},{
aa.NewRoundFrame(99,"Squircle",{
Name="Frame",
Size=UDim2.new(ao,0,1,0),
ImageTransparency=.1,
ThemeTag={
ImageColor3="Button",
},
},{
aa.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,ah.Window.NewElements and(ai.ThumbSize*1.75)or(ai.ThumbSize+2),0,ai.ThumbSize+2),
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Text",
},
Name="Thumb",
})
})
})

ai.UIElements.SliderContainer=ab("Frame",{
Size=UDim2.new(0,ai.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,ah.Window.NewElements and-20 or 0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Parent=ai.SliderFrame.UIElements.Main,
},{
ab("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ai.UIElements.SliderIcon,
ab("TextBox",{
Size=UDim2.new(0,ai.TextBoxWidth,0,0),
TextXAlignment="Left",
Text=FormatValue(am),
ThemeTag={
TextColor3="Text"
},
TextTransparency=.4,
AutomaticSize="Y",
TextSize=15,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
LayoutOrder=-1,
})
})

function ai.Lock(ar)
ai.Locked=true
ap=false
return ai.SliderFrame:Lock()
end
function ai.Unlock(ar)
ai.Locked=false
ap=true
return ai.SliderFrame:Unlock()
end

if ai.Locked then
ai:Lock()
end


local ar=ah.Tab.UIElements.ContainerFrame

function ai.Set(as,at,au)
if ap then
if not ai.IsFocusing and not af and(not au or(au.UserInputType==Enum.UserInputType.MouseButton1 or au.UserInputType==Enum.UserInputType.Touch))then
at=math.clamp(at,ai.Value.Min or 0,ai.Value.Max or 100)

local av=math.clamp((at-(ai.Value.Min or 0))/((ai.Value.Max or 100)-(ai.Value.Min or 0)),0,1)
at=CalculateValue((ai.Value.Min or 0)+av*((ai.Value.Max or 100)-(ai.Value.Min or 0)))

if at~=an then
ac(ai.UIElements.SliderIcon.Frame,0.05,{Size=UDim2.new(av,0,1,0)}):Play()
ai.UIElements.SliderContainer.TextBox.Text=FormatValue(at)
ai.Value.Default=FormatValue(at)
an=at
aa.SafeCallback(ai.Callback,FormatValue(at))
end

if au then
aj=(au.UserInputType==Enum.UserInputType.Touch)
ar.ScrollingEnabled=false
af=true
ak=ad(game:GetService"RunService").RenderStepped:Connect(function()
local aw=aj and au.Position.X or ad(game:GetService"UserInputService"):GetMouseLocation().X
local ax=math.clamp((aw-ai.UIElements.SliderIcon.AbsolutePosition.X)/ai.UIElements.SliderIcon.AbsoluteSize.X,0,1)
at=CalculateValue((ai.Value.Min or 0)+ax*((ai.Value.Max or 100)-(ai.Value.Min or 0)))

if at~=an then
ac(ai.UIElements.SliderIcon.Frame,0.05,{Size=UDim2.new(ax,0,1,0)}):Play()
ai.UIElements.SliderContainer.TextBox.Text=FormatValue(at)
ai.Value.Default=FormatValue(at)
an=at
aa.SafeCallback(ai.Callback,FormatValue(at))
end
end)
al=ad(game:GetService"UserInputService").InputEnded:Connect(function(aw)
if(aw.UserInputType==Enum.UserInputType.MouseButton1 or aw.UserInputType==Enum.UserInputType.Touch)and au==aw then
ak:Disconnect()
al:Disconnect()
af=false
ar.ScrollingEnabled=true

ac(ai.UIElements.SliderIcon.Frame.Thumb,.2,{Size=UDim2.new(0,ah.Window.NewElements and(ai.ThumbSize*1.75)or(ai.ThumbSize+2),0,ai.ThumbSize+2)},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end
end)
end
end
end
end

function ai.SetMax(as,at)
ai.Value.Max=at

local au=tonumber(ai.Value.Default)or an
if au>at then
ai:Set(at)
else
local av=math.clamp((au-(ai.Value.Min or 0))/(at-(ai.Value.Min or 0)),0,1)
ac(ai.UIElements.SliderIcon.Frame,0.1,{Size=UDim2.new(av,0,1,0)}):Play()
end
end

function ai.SetMin(as,at)
ai.Value.Min=at

local au=tonumber(ai.Value.Default)or an
if au<at then
ai:Set(at)
else
local av=math.clamp((au-at)/((ai.Value.Max or 100)-at),0,1)
ac(ai.UIElements.SliderIcon.Frame,0.1,{Size=UDim2.new(av,0,1,0)}):Play()
end
end

aa.AddSignal(ai.UIElements.SliderContainer.TextBox.FocusLost,function(as)
if as then
local at=tonumber(ai.UIElements.SliderContainer.TextBox.Text)
if at then
ai:Set(at)
else
ai.UIElements.SliderContainer.TextBox.Text=FormatValue(an)
end
end
end)

aa.AddSignal(ai.UIElements.SliderContainer.InputBegan,function(as)
ai:Set(am,as)

if as.UserInputType==Enum.UserInputType.MouseButton1 or as.UserInputType==Enum.UserInputType.Touch then
ac(ai.UIElements.SliderIcon.Frame.Thumb,.24,{Size=UDim2.new(0,(ah.Window.NewElements and(ai.ThumbSize*1.75)or(ai.ThumbSize))+8,0,ai.ThumbSize+8)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end)

return ai.__type,ai
end

return ae end function a.G()
local aa=(cloneref or clonereference or function(aa)return aa end)

local ab=aa(game:GetService"UserInputService")

local ac=a.load'b'
local ad=ac.New local ae=
ac.Tween

local af={
UICorner=6,
UIPadding=8,
}

local ag=a.load't'.New

function af.New(ah,ai)
local aj={
__type="Keybind",
Title=ai.Title or"Keybind",
Desc=ai.Desc or nil,
Locked=ai.Locked or false,
Value=ai.Value or"F",
Callback=ai.Callback or function()end,
CanChange=ai.CanChange or true,
Picking=false,
UIElements={},
}

local ak=true

aj.KeybindFrame=a.load'z'{
Title=aj.Title,
Desc=aj.Desc,
Parent=ai.Parent,
TextOffset=85,
Hover=aj.CanChange,
Tab=ai.Tab,
Index=ai.Index,
Window=ai.Window,
ElementTable=aj,
ParentConfig=ai,
ParentType=ai.ParentType,
}

aj.UIElements.Keybind=ag(aj.Value,nil,aj.KeybindFrame.UIElements.Main)

aj.UIElements.Keybind.Size=UDim2.new(
0,24
+aj.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
aj.UIElements.Keybind.AnchorPoint=Vector2.new(1,0.5)
aj.UIElements.Keybind.Position=UDim2.new(1,0,0.5,0)

ad("UIScale",{
Parent=aj.UIElements.Keybind,
Scale=.85,
})

ac.AddSignal(aj.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal"TextBounds",function()
aj.UIElements.Keybind.Size=UDim2.new(
0,24
+aj.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
end)

function aj.Lock(al)
aj.Locked=true
ak=false
return aj.KeybindFrame:Lock()
end
function aj.Unlock(al)
aj.Locked=false
ak=true
return aj.KeybindFrame:Unlock()
end

function aj.Set(al,am)
aj.Value=am
aj.UIElements.Keybind.Frame.Frame.TextLabel.Text=am
end

if aj.Locked then
aj:Lock()
end

ac.AddSignal(aj.KeybindFrame.UIElements.Main.MouseButton1Click,function()
if ak then
if aj.CanChange then
aj.Picking=true
aj.UIElements.Keybind.Frame.Frame.TextLabel.Text="..."

task.wait(0.2)

local al
al=ab.InputBegan:Connect(function(am)
local an

if am.UserInputType==Enum.UserInputType.Keyboard then
an=am.KeyCode.Name
elseif am.UserInputType==Enum.UserInputType.MouseButton1 then
an="MouseLeft"
elseif am.UserInputType==Enum.UserInputType.MouseButton2 then
an="MouseRight"
end

local ao
ao=ab.InputEnded:Connect(function(ap)
if ap.KeyCode.Name==an or an=="MouseLeft"and ap.UserInputType==Enum.UserInputType.MouseButton1 or an=="MouseRight"and ap.UserInputType==Enum.UserInputType.MouseButton2 then
aj.Picking=false

aj.UIElements.Keybind.Frame.Frame.TextLabel.Text=an
aj.Value=an

al:Disconnect()
ao:Disconnect()
end
end)
end)
end
end
end)

ac.AddSignal(ab.InputBegan,function(al,am)
if ab:GetFocusedTextBox()then
return
end

if not ak then
return
end

if al.UserInputType==Enum.UserInputType.Keyboard then
if al.KeyCode.Name==aj.Value then
ac.SafeCallback(aj.Callback,al.KeyCode.Name)
end
elseif al.UserInputType==Enum.UserInputType.MouseButton1 and aj.Value=="MouseLeft"then
ac.SafeCallback(aj.Callback,"MouseLeft")
elseif al.UserInputType==Enum.UserInputType.MouseButton2 and aj.Value=="MouseRight"then
ac.SafeCallback(aj.Callback,"MouseRight")
end
end)

return aj.__type,aj
end

return af end function a.H()
local aa=a.load'b'
local ab=aa.New local ac=
aa.Tween

local ad={
UICorner=8,
UIPadding=8,
}local ae=a.load'j'


.New
local af=a.load'k'.New

function ad.New(ag,ah)
local ai={
__type="Input",
Title=ah.Title or"Input",
Desc=ah.Desc or nil,
Type=ah.Type or"Input",
Locked=ah.Locked or false,
InputIcon=ah.InputIcon or false,
Placeholder=ah.Placeholder or"Enter Text...",
Value=ah.Value or"",
Callback=ah.Callback or function()end,
ClearTextOnFocus=ah.ClearTextOnFocus or false,
UIElements={},

Width=150,
}

local aj=true

ai.InputFrame=a.load'z'{
Title=ai.Title,
Desc=ai.Desc,
Parent=ah.Parent,
TextOffset=ai.Width,
Hover=false,
Tab=ah.Tab,
Index=ah.Index,
Window=ah.Window,
ElementTable=ai,
ParentConfig=ah,
ParentType=ah.ParentType,
}

local ak=af(
ai.Placeholder,
ai.InputIcon,
ai.Type=="Textarea"and ai.InputFrame.UIElements.Container or ai.InputFrame.UIElements.Main,
ai.Type,
function(ak)
ai:Set(ak,true)
end,
nil,
ah.Window.NewElements and 12 or 10,
ai.ClearTextOnFocus
)

if ai.Type=="Input"then
ak.Size=UDim2.new(0,ai.Width,0,36)
ak.Position=UDim2.new(1,0,ah.Window.NewElements and 0 or 0.5,0)
ak.AnchorPoint=Vector2.new(1,ah.Window.NewElements and 0 or 0.5)
else
ak.Size=UDim2.new(1,0,0,148)
end

ab("UIScale",{
Parent=ak,
Scale=1,
})

function ai.Lock(al)
ai.Locked=true
aj=false
return ai.InputFrame:Lock()
end
function ai.Unlock(al)
ai.Locked=false
aj=true
return ai.InputFrame:Unlock()
end


function ai.Set(al,am,an)
if aj then
ai.Value=am
aa.SafeCallback(ai.Callback,am)

if not an then
ak.Frame.Frame.TextBox.Text=am
end
end
end

function ai.SetPlaceholder(al,am)
ak.Frame.Frame.TextBox.PlaceholderText=am
ai.Placeholder=am
end

ai:Set(ai.Value)

if ai.Locked then
ai:Lock()
end

return ai.__type,ai
end

return ad end function a.I()
local aa=a.load'b'
local ab=aa.New

local ad={}

function ad.New(ae,af)
local ag=ab("Frame",{
Size=af.ParentType~="Group"and UDim2.new(1,0,0,1)or UDim2.new(0,1,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local ah=ab("Frame",{
Parent=af.Parent,
Size=af.ParentType~="Group"and UDim2.new(1,-7,0,7)or UDim2.new(0,7,1,-7),
BackgroundTransparency=1,
},{
ag
})

return"Divider",{__type="Divider",ElementFrame=ah}
end

return ad end function a.J()
local aa={}

local ab=(cloneref or clonereference or function(ab)return ab end)

local ad=ab(game:GetService"UserInputService")
local ae=ab(game:GetService"Players").LocalPlayer:GetMouse()
local af=ab(game:GetService"Workspace").CurrentCamera

local ag=a.load'b'
local ah=ag.New
local ai=ag.Tween

local aj=workspace.CurrentCamera

function aa.New(ak,al,am,an,ao)
local ap={}

if not al.Callback then
ao="Menu"
end


local function RenderImages(aq,ar)

for as,at in ipairs(aq:GetChildren())do
if not at:IsA"UIListLayout"and not at:IsA"UIPadding"then
at:Destroy()
end
end

if not ar or#ar==0 then return end

for as,at in ipairs(ar)do
local au=false
if typeof(at)=="table"and(at.Quantity or at.Gradient or at.Card)then
au=true
end

if au then
local av=at.Size or al.ImageSize or UDim2.new(0,60,0,60)
local aw=at.Title or"Item"
local ax=at.Quantity or""
local ay=at.Rate or""
local az=at.Image or""
local aA=at.Gradient

local aB
if typeof(aA)=="ColorSequence"then
aB=aA
elseif typeof(aA)=="Color3"then
aB=ColorSequence.new(aA)
else
aB=ColorSequence.new(Color3.fromRGB(80,80,80))
end

local d=aB.Keypoints[1].Value
local e=2


ag.NewRoundFrame(8,"Squircle",{
Size=av,
Parent=aq,
ImageColor3=d,
ClipsDescendants=true,
},{
ah("ImageLabel",{
Image="rbxassetid://5554236805",
ScaleType=Enum.ScaleType.Slice,
SliceCenter=Rect.new(23,23,277,277),
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ImageColor3=Color3.new(0,0,0),
ImageTransparency=0.4,
ZIndex=2,
}),

(ag.NewRoundFrame(8,"Squircle",{
Size=UDim2.new(1,-e*2,1,-e*2),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageColor3=Color3.new(1,1,1),
ClipsDescendants=true,
ZIndex=3,
},{
ah("UIGradient",{Color=aB,Rotation=45}),
ah("ImageLabel",{
Image=az,
Size=UDim2.new(0.65,0,0.65,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.45,0),
BackgroundTransparency=1,
ScaleType="Fit",
ZIndex=4,
}),
ax and ah("TextLabel",{
Text=ax,
Size=UDim2.new(0.5,0,0,12),
Position=UDim2.new(0,4,0,2),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(ag.Font,Enum.FontWeight.Bold),
TextSize=10,
TextStrokeTransparency=0,
TextStrokeColor3=Color3.new(0,0,0),
ZIndex=5,
})or nil,
ay and ah("TextLabel",{
Text=ay,
Size=UDim2.new(0.5,-4,0,12),
Position=UDim2.new(1,-4,0,2),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Right,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(ag.Font,Enum.FontWeight.Bold),
TextSize=10,
TextStrokeTransparency=0,
TextStrokeColor3=Color3.new(0,0,0),
ZIndex=5,
})or nil,
ah("Frame",{
Size=UDim2.new(1,0,0,18),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.4,
BorderSizePixel=0,
ZIndex=6,
},{
ah("TextLabel",{
Text=aw,
Size=UDim2.new(1,-2,1,0),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Center,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(ag.Font,Enum.FontWeight.Bold),
TextSize=9,
TextWrapped=true,
TextTruncate="AtEnd",
ZIndex=7,
}),
})
}))
})
else
local av=(typeof(at)=="table"and(at.Image or at.Icon or at.Id))or at
local aw=ag.Image(av,tostring(av),6,ak.Window.Folder,"Dropdown",false)
aw.Size=al.ImageSize or UDim2.new(0,30,0,30)
aw.Parent=aq
end
end
end


al.UIElements.UIListLayout=ah("UIListLayout",{
Padding=UDim.new(0,am.MenuPadding/1.5),
FillDirection="Vertical",
HorizontalAlignment="Center",
})

al.UIElements.Menu=ag.NewRoundFrame(am.MenuCorner,"Squircle",{
ThemeTag={ImageColor3="Background"},
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
},{
ah("UIPadding",{
PaddingTop=UDim.new(0,am.MenuPadding),
PaddingLeft=UDim.new(0,am.MenuPadding),
PaddingRight=UDim.new(0,am.MenuPadding),
PaddingBottom=UDim.new(0,am.MenuPadding),
}),
ah("UIListLayout",{FillDirection="Vertical",Padding=UDim.new(0,am.MenuPadding)}),
ah("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,al.SearchBarEnabled and-am.MenuPadding-am.SearchBarHeight),
Name="Frame",
ClipsDescendants=true,
LayoutOrder=999,
},{
ah("UICorner",{CornerRadius=UDim.new(0,am.MenuCorner-am.MenuPadding)}),
ah("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
ScrollBarThickness=0,
ScrollingDirection="Y",
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
ScrollBarImageTransparency=1,
},{
al.UIElements.UIListLayout,
})
})
})

al.UIElements.MenuCanvas=ah("Frame",{
Size=UDim2.new(0,al.MenuWidth,0,300),
BackgroundTransparency=1,
Position=UDim2.new(-10,0,-10,0),
Visible=false,
Active=false,
Parent=ak.ANUI.DropdownGui,
AnchorPoint=Vector2.new(1,0),
},{
al.UIElements.Menu,
ah("UISizeConstraint",{
MinSize=Vector2.new(170,0),
MaxSize=Vector2.new(300,400),
})
})

local function RecalculateCanvasSize()
al.UIElements.Menu.Frame.ScrollingFrame.CanvasSize=UDim2.fromOffset(0,al.UIElements.UIListLayout.AbsoluteContentSize.Y)
end
local function RecalculateListSize()
local aq=aj.ViewportSize.Y*0.6
local ar=al.UIElements.UIListLayout.AbsoluteContentSize.Y
local as=al.SearchBarEnabled and(am.SearchBarHeight+(am.MenuPadding*3))or(am.MenuPadding*2)
local at=(ar)+as
if at>aq then
al.UIElements.MenuCanvas.Size=UDim2.fromOffset(al.UIElements.MenuCanvas.AbsoluteSize.X,aq)
else
al.UIElements.MenuCanvas.Size=UDim2.fromOffset(al.UIElements.MenuCanvas.AbsoluteSize.X,at)
end
end

function UpdatePosition()
local aq=al.UIElements.Dropdown or al.DropdownFrame.UIElements.Main
local ar=al.UIElements.MenuCanvas
local as=af.ViewportSize.Y-(aq.AbsolutePosition.Y+aq.AbsoluteSize.Y)-am.MenuPadding-54
local at=ar.AbsoluteSize.Y+am.MenuPadding
local au=-54
if as<at then au=at-as-54 end
ar.Position=UDim2.new(0,aq.AbsolutePosition.X+aq.AbsoluteSize.X,0,aq.AbsolutePosition.Y+aq.AbsoluteSize.Y-au+(am.MenuPadding*2))
end

local aq

function ap.Display(ar)
local as=al.Values
local at=""
if al.Multi then
local au={}
if typeof(al.Value)=="table"then
for av,aw in ipairs(al.Value)do
local ax=typeof(aw)=="table"and aw.Title or aw
au[ax]=true
end
end
for av,aw in ipairs(as)do
local ax=typeof(aw)=="table"and aw.Title or aw
if au[ax]then at=at..ax..", "end
end
if#at>0 then at=at:sub(1,#at-2)end
else
at=typeof(al.Value)=="table"and al.Value.Title or al.Value or""
end
if al.UIElements.Dropdown then
al.UIElements.Dropdown.Frame.Frame.TextLabel.Text=(at==""and"--"or at)
end
end

local function Callback(ar)
ap:Display()
if al.Callback then
task.spawn(function()ag.SafeCallback(al.Callback,al.Value)end)
else
task.spawn(function()ag.SafeCallback(ar)end)
end
end

function ap.Refresh(ar,as)

if al._ActiveRefreshTask then
task.cancel(al._ActiveRefreshTask)
al._ActiveRefreshTask=nil
end


local at=al.UIElements.Menu.Frame.ScrollingFrame
for au,av in next,at:GetChildren()do
if not av:IsA"UIListLayout"and not av:IsA"UIPadding"and av.Name~="SearchBar"then
av:Destroy()
end
end

al.Tabs={}


if al.SearchBarEnabled then
if not aq then
aq=CreateInput("Search...","search",al.UIElements.Menu,nil,function(au)
for av,aw in next,al.Tabs do
if string.find(string.lower(aw.Name),string.lower(au),1,true)then
aw.UIElements.TabItem.Visible=true
else
aw.UIElements.TabItem.Visible=false
end
RecalculateListSize()
RecalculateCanvasSize()
end
end,true)
aq.Size=UDim2.new(1,0,0,am.SearchBarHeight)
aq.Position=UDim2.new(0,0,0,0)
aq.Name="SearchBar"
else

aq.Parent=al.UIElements.Menu
end
end


al._ActiveRefreshTask=task.spawn(function()
local au=0
local av=15

for aw,ax in next,as do
if(ax.Type~="Divider")then
local ay={
Name=typeof(ax)=="table"and ax.Title or ax,
Desc=typeof(ax)=="table"and ax.Desc or nil,
Icon=typeof(ax)=="table"and ax.Icon or nil,
Images=typeof(ax)=="table"and ax.Images or nil,
Original=ax,
Selected=false,
Locked=typeof(ax)=="table"and ax.Locked or false,
UIElements={},
}
local az
if ay.Icon then
az=ag.Image(ay.Icon,ay.Icon,0,ak.Window.Folder,"Dropdown",true)
az.Size=UDim2.new(0,am.TabIcon,0,am.TabIcon)
az.ImageLabel.ImageTransparency=ao=="Dropdown"and.2 or 0
ay.UIElements.TabIcon=az
end


ay.UIElements.TabItem=ag.NewRoundFrame(am.MenuCorner-am.MenuPadding,"Squircle",{
Size=UDim2.new(1,0,0,36),
AutomaticSize=((ay.Desc or(ay.Images and#ay.Images>0))and"Y")or nil,
ImageTransparency=1,
Parent=al.UIElements.Menu.Frame.ScrollingFrame,
ImageColor3=Color3.new(1,1,1),
Active=not ay.Locked,
},{
ag.NewRoundFrame(am.MenuCorner-am.MenuPadding,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
Name="Highlight",
},{
ah("UIGradient",{
Rotation=80,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
ah("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Frame",
},{
ah("UIListLayout",{Padding=UDim.new(0,am.TabPadding),FillDirection="Horizontal",VerticalAlignment="Center"}),
ah("UIPadding",{
PaddingTop=UDim.new(0,am.TabPadding),
PaddingLeft=UDim.new(0,am.TabPadding),
PaddingRight=UDim.new(0,am.TabPadding),
PaddingBottom=UDim.new(0,am.TabPadding),
}),
ah("UICorner",{CornerRadius=UDim.new(0,am.MenuCorner-am.MenuPadding)}),
az,
ah("Frame",{
Size=UDim2.new(1,az and-am.TabPadding-am.TabIcon or 0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Name="Title",
},{
ah("TextLabel",{
Text=ay.Name,
TextXAlignment="Left",
FontFace=Font.new(ag.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text",BackgroundColor3="Text"},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=ao=="Dropdown"and.4 or.05,
LayoutOrder=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
}),
ah("TextLabel",{
Text=ay.Desc or"",
TextXAlignment="Left",
FontFace=Font.new(ag.Font,Enum.FontWeight.Regular),
ThemeTag={TextColor3="Text",BackgroundColor3="Text"},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=ao=="Dropdown"and.6 or.35,
LayoutOrder=2,
AutomaticSize="Y",
TextWrapped=true,
Size=UDim2.new(1,0,0,0),
Visible=ay.Desc and true or false,
Name="Desc",
}),
ah("ScrollingFrame",{
Size=UDim2.new(1,0,0,70),
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.None,
AutomaticCanvasSize=Enum.AutomaticSize.X,
ScrollingDirection=Enum.ScrollingDirection.X,
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
Visible=(ay.Images and#ay.Images>0)and true or false,
LayoutOrder=3,
Name="Images",
},{
ah("UIListLayout",{FillDirection="Horizontal",Padding=UDim.new(0,al.ImagePadding or am.TabPadding/3),VerticalAlignment="Center"}),
ah("UIPadding",{PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,2),PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,2)})
}),
ah("UIListLayout",{Padding=UDim.new(0,am.TabPadding/3),FillDirection="Vertical"}),
})
})
},true)

if ay.Images and#ay.Images>0 then
local aA=ay.UIElements.TabItem.Frame.Title:FindFirstChild"Images"
if aA then

aA.Active=true


local aB=false
local d=Vector2.new()
local e=Vector2.new()


aA.InputBegan:Connect(function(f)
if f.UserInputType==Enum.UserInputType.MouseButton1 then
aB=true
d=f.Position
e=aA.CanvasPosition
end
end)


aA.InputEnded:Connect(function(f)
if f.UserInputType==Enum.UserInputType.MouseButton1 then
aB=false
end
end)


aA.InputChanged:Connect(function(f)

if f.UserInputType==Enum.UserInputType.MouseMovement then
if aB then
local g=f.Position-d

aA.CanvasPosition=Vector2.new(e.X-g.X,0)
end


elseif f.UserInputType==Enum.UserInputType.MouseWheel then

local g=f.Position.Z*-35
aA.CanvasPosition=aA.CanvasPosition+Vector2.new(g,0)
end
end)


RenderImages(aA,ay.Images)
end
end

if ay.Locked then
ay.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0.6
if ay.UIElements.TabIcon then ay.UIElements.TabIcon.ImageLabel.ImageTransparency=0.6 end
end


if al.Multi and typeof(al.Value)=="string"then
for aA,aB in next,al.Values do
if typeof(aB)=="table"then
if aB.Title==al.Value then al.Value={aB}end
else
if aB==al.Value then al.Value={al.Value}end
end
end
end

if al.Multi then
local aA=false
if typeof(al.Value)=="table"then
for aB,d in ipairs(al.Value)do
local e=typeof(d)=="table"and d.Title or d
if e==ay.Name then aA=true break end
end
end
ay.Selected=aA
else
local aA=typeof(al.Value)=="table"and al.Value.Title or al.Value
ay.Selected=aA==ay.Name
end

if ay.Selected and not ay.Locked then
ay.UIElements.TabItem.ImageTransparency=.95
ay.UIElements.TabItem.Highlight.ImageTransparency=.75
ay.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0
if ay.UIElements.TabIcon then ay.UIElements.TabIcon.ImageLabel.ImageTransparency=0 end
end

al.Tabs[aw]=ay


if ao=="Dropdown"then
ag.AddSignal(ay.UIElements.TabItem.MouseButton1Click,function()
if ay.Locked then return end
if al.Multi then
if typeof(al.Value)~="table"then
al.Value={}
end
if not ay.Selected then
ay.Selected=true
ai(ay.UIElements.TabItem,0.1,{ImageTransparency=.95}):Play()
ai(ay.UIElements.TabItem.Highlight,0.1,{ImageTransparency=.75}):Play()
ai(ay.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if ay.UIElements.TabIcon then ai(ay.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()end
table.insert(al.Value,ay.Original)
else
if not al.AllowNone and#al.Value==1 then return end
ay.Selected=false
ai(ay.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ai(ay.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ai(ay.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=.4}):Play()
if ay.UIElements.TabIcon then ai(ay.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=.2}):Play()end
for aA,aB in next,al.Value do
if typeof(aB)=="table"and(aB.Title==ay.Name)or(aB==ay.Name)then
table.remove(al.Value,aA)
break
end
end
end
else

if al.AllowNone and ay.Selected then

ay.Selected=false
ai(ay.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ai(ay.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ai(ay.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=.4}):Play()
if ay.UIElements.TabIcon then ai(ay.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=.2}):Play()end
al.Value=nil
else

for aA,aB in next,al.Tabs do
ai(aB.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ai(aB.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ai(aB.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=.4}):Play()
if aB.UIElements.TabIcon then ai(aB.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=.2}):Play()end
aB.Selected=false
end
ay.Selected=true
ai(ay.UIElements.TabItem,0.1,{ImageTransparency=.95}):Play()
ai(ay.UIElements.TabItem.Highlight,0.1,{ImageTransparency=.75}):Play()
ai(ay.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if ay.UIElements.TabIcon then ai(ay.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()end
al.Value=ay.Original
end
end
Callback()
end)
elseif ao=="Menu"then
if not ay.Locked then
ag.AddSignal(ay.UIElements.TabItem.MouseEnter,function()ai(ay.UIElements.TabItem,0.08,{ImageTransparency=.95}):Play()end)
ag.AddSignal(ay.UIElements.TabItem.InputEnded,function()ai(ay.UIElements.TabItem,0.08,{ImageTransparency=1}):Play()end)
end
ag.AddSignal(ay.UIElements.TabItem.MouseButton1Click,function()
if ay.Locked then return end
Callback(ax.Callback or function()end)
end)
end
else a.load'I'
:New{Parent=al.UIElements.Menu.Frame.ScrollingFrame}
end


au=au+1
if au%av==0 then

RecalculateCanvasSize()
task.wait()
end
end


local aw=al.MenuWidth or 0
if aw==0 then
for ax,ay in next,al.Tabs do
if ay.UIElements.TabItem.Frame.UIListLayout then aw=math.max(aw,ay.UIElements.TabItem.Frame.UIListLayout.AbsoluteContentSize.X)end
end
end
al.UIElements.MenuCanvas.Size=UDim2.new(0,aw+6+6+5+5+18+6+6,al.UIElements.MenuCanvas.Size.Y.Scale,al.UIElements.MenuCanvas.Size.Y.Offset)
Callback()
al.Values=as
RecalculateCanvasSize()
RecalculateListSize()

al._ActiveRefreshTask=nil
end)
end

ap:Refresh(al.Values)

function ap.Select(ar,as)
if as then al.Value=as else
if al.Multi then al.Value={}else al.Value=nil end
end
ap:Refresh(al.Values)
end




function ap.Edit(ar,as,at)
for au,av in ipairs(al.Tabs)do

if av.Name==as then


local aw=al.Values[au]
if aw and type(aw)=="table"then
if at.Title then aw.Title=at.Title end
if at.Desc then aw.Desc=at.Desc end
if at.Icon then aw.Icon=at.Icon end
if at.Images then aw.Images=at.Images end


if at.Title then av.Name=at.Title end
if at.Desc then
av.Desc=at.Desc
av.Original.Desc=at.Desc
end
if at.Images then
av.Images=at.Images
av.Original.Images=at.Images
end
end


local ax=av.UIElements
if ax and ax.TabItem then
local ay=ax.TabItem:FindFirstChild"Frame"
local az=ay and ay:FindFirstChild"Title"

if az then

if at.Title then
local aA=az:FindFirstChild"TextLabel"
if aA then aA.Text=at.Title end
end


if at.Desc then
local aA=az:FindFirstChild"Desc"
if aA then
aA.Text=at.Desc
aA.Visible=true

av.UIElements.TabItem.AutomaticSize=Enum.AutomaticSize.Y
end
end


if at.Images then
local aA=az:FindFirstChild"Images"
if aA then
aA.Visible=true

RenderImages(aA,at.Images)


av.UIElements.TabItem.AutomaticSize=Enum.AutomaticSize.Y
end
end
end


if at.Icon and ax.TabIcon then
local aA=ax.TabIcon:FindFirstChild"ImageLabel"
if aA then

local aB=ag.Icon(at.Icon)
if aB then
aA.Image=aB[1]
aA.ImageRectOffset=aB[2].ImageRectPosition
aA.ImageRectSize=aB[2].ImageRectSize
else
aA.Image=at.Icon
aA.ImageRectOffset=Vector2.new(0,0)
aA.ImageRectSize=Vector2.new(0,0)
end


if at.Gradient then
local d=aA:FindFirstChildOfClass"UIGradient"or ah("UIGradient",{Parent=aA})
d.Color=at.Gradient
end
end
end
end


RecalculateCanvasSize()
RecalculateListSize()
break
end
end
end


function ap.EditDrop(ar,as,at)
local au
local av


if type(as)=="number"then
au=as
av=al.Tabs[as]
else
for aw,ax in ipairs(al.Tabs)do
if ax.Name==as then
au=aw
av=ax
break
end
end
end

if av and au then

local aw=al.Values[au]
if type(aw)~="table"then
aw={Title=aw,Value=aw}
al.Values[au]=aw
end


if at.Title then aw.Title=at.Title end
if at.Desc then aw.Desc=at.Desc end
if at.Icon then aw.Icon=at.Icon end
if at.Images then aw.Images=at.Images end
if at.Gradient then aw.Gradient=at.Gradient end
if at.Value then aw.Value=at.Value end


if at.Title then av.Name=at.Title end
if at.Desc then
av.Desc=at.Desc
av.Original.Desc=at.Desc
end
if at.Images then
av.Images=at.Images
av.Original.Images=at.Images
end
for ax,ay in pairs(at)do av.Original[ax]=ay end


local ax=av.UIElements
if ax and ax.TabItem then
local ay=ax.TabItem:FindFirstChild"Frame"
local az=ay and ay:FindFirstChild"Title"

if az then
if at.Title then
local aA=az:FindFirstChild"TextLabel"
if aA then aA.Text=at.Title end
end
if at.Desc then
local aA=az:FindFirstChild"Desc"
if aA then
aA.Text=at.Desc
aA.Visible=true
ax.TabItem.AutomaticSize=Enum.AutomaticSize.Y
end
end

if at.Images then
local aA=az:FindFirstChild"Images"
if aA then
aA.Visible=(at.Images and#at.Images>0)
RenderImages(aA,at.Images)
ax.TabItem.AutomaticSize=Enum.AutomaticSize.Y
end
end
end

if at.Icon and ax.TabIcon then
local aA=ax.TabIcon:FindFirstChild"ImageLabel"
if aA then
local aB=ag.Icon(at.Icon)
if aB then
aA.Image=aB[1]
aA.ImageRectOffset=aB[2].ImageRectPosition
aA.ImageRectSize=aB[2].ImageRectSize
else
aA.Image=at.Icon
aA.ImageRectOffset=Vector2.new(0,0)
aA.ImageRectSize=Vector2.new(0,0)
end

if at.Gradient then
local d=aA:FindFirstChildOfClass"UIGradient"or ah("UIGradient",{Parent=aA})
d.Color=at.Gradient
end
end
end
end


local ay=al.Value
local az=false
if not al.Multi and ay==aw then az=true end

if az then
if al.UIElements.Dropdown and at.Title then
local aA=al.UIElements.Dropdown:FindFirstChild"Frame"
local aB=aA and aA:FindFirstChild"Frame"
local d=aB and aB:FindFirstChild"TextLabel"
if d then d.Text=at.Title end
end

al.Value=aw

if at.Desc then ap:SetDesc(at.Desc)end

if at.Icon then
ap:SetValueImage(at.Icon)
if at.Gradient then
ap:SetMainImage({Image=at.Icon,Quantity="",Gradient=at.Gradient},50)
else
ap:SetMainImage(at.Icon)
end
end
end

RecalculateCanvasSize()
RecalculateListSize()
end
end

RecalculateListSize()
RecalculateCanvasSize()

function ap.Open(ar)
if an then
al.UIElements.Menu.Visible=true
al.UIElements.MenuCanvas.Visible=true
al.UIElements.MenuCanvas.Active=true
al.UIElements.Menu.Size=UDim2.new(1,0,0,0)
ai(al.UIElements.Menu,0.1,{Size=UDim2.new(1,0,1,0),ImageTransparency=0.05},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()
task.spawn(function()task.wait(.1)al.Opened=true end)
UpdatePosition()
end
end

function ap.Close(ar)
al.Opened=false
ai(al.UIElements.Menu,0.25,{Size=UDim2.new(1,0,0,0),ImageTransparency=1},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()
task.spawn(function()task.wait(.1)al.UIElements.Menu.Visible=false end)
task.spawn(function()task.wait(.25)al.UIElements.MenuCanvas.Visible=false al.UIElements.MenuCanvas.Active=false end)
end

ag.AddSignal((al.UIElements.Dropdown and al.UIElements.Dropdown.MouseButton1Click or al.DropdownFrame.UIElements.Main.MouseButton1Click),function()
ap:Open()
end)

ag.AddSignal(ad.InputBegan,function(ar)
if ar.UserInputType==Enum.UserInputType.MouseButton1 or ar.UserInputType==Enum.UserInputType.Touch then
local as=al.UIElements.MenuCanvas
local at,au=as.AbsolutePosition,as.AbsoluteSize
local av=al.UIElements.Dropdown or al.DropdownFrame.UIElements.Main
local aw=av.AbsolutePosition
local ax=av.AbsoluteSize

local ay=ae.X>=aw.X and ae.X<=aw.X+ax.X and ae.Y>=aw.Y and ae.Y<=aw.Y+ax.Y
local az=ae.X>=at.X and ae.X<=at.X+au.X and ae.Y>=at.Y and ae.Y<=at.Y+au.Y

if ak.Window.CanDropdown and al.Opened and not ay and not az then
ap:Close()
end
end
end)

ag.AddSignal(
al.UIElements.Dropdown and al.UIElements.Dropdown:GetPropertyChangedSignal"AbsolutePosition"or al.DropdownFrame.UIElements.Main:GetPropertyChangedSignal"AbsolutePosition",
UpdatePosition
)

return ap
end

return aa end function a.K()
local aa=(cloneref or clonereference or function(aa)return aa end)

aa(game:GetService"UserInputService")
aa(game:GetService"Players").LocalPlayer:GetMouse()local ab=
aa(game:GetService"Workspace").CurrentCamera

local ad=a.load'b'
local ae=ad.New local af=
ad.Tween

local ag=a.load't'.New local ah=a.load'k'
.New
local ai=a.load'J'.New local aj=

workspace.CurrentCamera

local ak={
UICorner=10,
UIPadding=12,
MenuCorner=15,
MenuPadding=5,
TabPadding=10,
SearchBarHeight=39,
TabIcon=18,
}

function ak.New(al,am)
local an={
__type="Dropdown",
Title=am.Title or"Dropdown",
Desc=am.Desc or nil,
Locked=am.Locked or false,
Values=am.Values or{},
MenuWidth=am.MenuWidth,
Value=am.Value,
AllowNone=am.AllowNone,
SearchBarEnabled=am.SearchBarEnabled or false,
Multi=am.Multi,
Callback=am.Callback or nil,

UIElements={},

Opened=false,
Tabs={},

Width=150,
}

if an.Multi and not an.Value then
an.Value={}
end

local ao=true

an.DropdownFrame=a.load'z'{
Title=an.Title,
Desc=an.Desc,
Image=am.Image,
ImageSize=am.ImageSize,
IconThemed=am.IconThemed,
Color=am.Color,
Parent=am.Parent,
TextOffset=an.Callback and an.Width or 20,
Hover=not an.Callback and true or false,
Tab=am.Tab,
Index=am.Index,
Window=am.Window,
ElementTable=an,
ParentConfig=am,
ParentType=am.ParentType,
}


if an.Callback then
an.UIElements.Dropdown=ag("",nil,an.DropdownFrame.UIElements.Main,nil,am.Window.NewElements and 12 or 10)

an.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate="AtEnd"
an.UIElements.Dropdown.Frame.Frame.TextLabel.Size=UDim2.new(1,an.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset-18-12-12,0,0)

an.UIElements.Dropdown.Size=UDim2.new(0,an.Width,0,36)
an.UIElements.Dropdown.Position=UDim2.new(1,0,am.Window.NewElements and 0 or 0.5,0)
an.UIElements.Dropdown.AnchorPoint=Vector2.new(1,am.Window.NewElements and 0 or 0.5)
end




function an.SetMainImage(ap,aq,ar)

local as=an.DropdownFrame.UIElements.Container:FindFirstChild"TitleFrame"

if not as then return end



local at=as:FindFirstChild"CustomMainIcon"
if at then
at:Destroy()
end


for au,av in ipairs(as:GetChildren())do
if av:IsA"Frame"and av.Name~="TitleFrame"and av.Name~="UIListLayout"and av.Name~="CustomMainIcon"then
av:Destroy()
end
end


if not aq then
local au=as:FindFirstChild"TitleFrame"
if au then
au.Size=UDim2.new(1,0,1,0)
end
return
end


local au=ar or an.ImageSize or 30
if typeof(au)=="number"then
au=UDim2.new(0,au,0,au)
end


local av


if typeof(aq)=="table"then
local aw=aq
local ax=aw.Image or""
local ay=aw.Gradient
local az=aw.Quantity
local aA=aw.Rate
local aB=aw.Title

local d
if typeof(ay)=="ColorSequence"then
d=ay
elseif typeof(ay)=="Color3"then
d=ColorSequence.new(ay)
else
d=ColorSequence.new(Color3.fromRGB(80,80,80))
end

local e=d.Keypoints[1].Value
local f=2


av=ad.NewRoundFrame(8,"Squircle",{
Name="CustomMainIcon",
Size=au,
Parent=as,
ImageColor3=e,
ClipsDescendants=true,
LayoutOrder=-1,
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,0,0.5,0),
},{

ae("ImageLabel",{
Image="rbxassetid://5554236805",
ScaleType=Enum.ScaleType.Slice,
SliceCenter=Rect.new(23,23,277,277),
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ImageColor3=Color3.new(0,0,0),
ImageTransparency=0.4,
ZIndex=2,
}),

ad.NewRoundFrame(8,"Squircle",{
Size=UDim2.new(1,-f*2,1,-f*2),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageColor3=Color3.new(1,1,1),
ClipsDescendants=true,
ZIndex=3,
},{

ae("UIGradient",{
Color=d,
Rotation=45,
}),

ae("ImageLabel",{
Image=ax,
Size=UDim2.new(0.65,0,0.65,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.45,0),
BackgroundTransparency=1,
ScaleType="Fit",
ZIndex=4,
}),


az and ae("TextLabel",{
Text=az,
Size=UDim2.new(0.5,0,0,12),
Position=UDim2.new(0,4,0,2),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(ad.Font,Enum.FontWeight.Bold),
TextSize=8,
TextStrokeTransparency=0,
TextStrokeColor3=Color3.new(0,0,0),

ZIndex=5,
})or nil,


aA and ae("TextLabel",{
Text=aA,
Size=UDim2.new(0.5,-4,0,12),
Position=UDim2.new(1,-4,0,2),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Right,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(ad.Font,Enum.FontWeight.Bold),
TextSize=11,
TextStrokeTransparency=0,
TextStrokeColor3=Color3.new(0,0,0),
TextWrapped=true,
ZIndex=5,
})or nil,


aB and ae("Frame",{
Size=UDim2.new(1,0,0,18),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.4,
BorderSizePixel=0,
ZIndex=6,
},{
ae("TextLabel",{
Text=aB,
Size=UDim2.new(1,-2,1,0),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Center,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(ad.Font,Enum.FontWeight.Bold),
TextSize=10,
TextWrapped=true,
ZIndex=7,
})
})or nil
})
})

else
av=ad.Image(
aq,
an.Title,
am.Window.NewElements and 12 or 6,
am.Window.Folder,
"DropdownIcon",
false
)

av.Name="CustomMainIcon"
av.Parent=as
av.Size=au
av.LayoutOrder=-1
av.AnchorPoint=Vector2.new(0,0.5)
av.Position=UDim2.new(0,0,0.5,0)
av.BackgroundTransparency=1
end


local aw=as:FindFirstChild"TitleFrame"
if aw then
aw.Size=UDim2.new(1,-au.X.Offset,1,0)
end
end


function an.SetValueImage(ap,aq)
if an.UIElements.Dropdown then

local ar=an.UIElements.Dropdown:FindFirstChild"Frame"
local as=ar and ar:FindFirstChild"Frame"


if not as then
local at=an.UIElements.Dropdown:FindFirstChild("TextLabel",true)
if at then
as=at.Parent
end
end

if not as then return end

local at=as:FindFirstChild"TextLabel"
local au=as:FindFirstChild"DynamicValueIcon"

if aq and aq~=""then
if not au then
au=ae("ImageLabel",{
Name="DynamicValueIcon",
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
LayoutOrder=-1,
Parent=as
})
end

local av=ad.Icon(aq)
if av then
au.Image=av[1]
au.ImageRectSize=av[2].ImageRectSize
au.ImageRectOffset=av[2].ImageRectPosition
else
au.Image=aq
au.ImageRectSize=Vector2.new(0,0)
au.ImageRectOffset=Vector2.new(0,0)
end

au.Visible=true

if at then
at.Size=UDim2.new(1,-29,1,0)
end
else
if au then
au.Visible=false
end
if at then
at.Size=UDim2.new(1,0,1,0)
end
end
end
end

function an.SetValueIcon(ap,aq)
an:SetValueImage(aq)
end

an.DropdownMenu=ai(am,an,ak,ao,"Dropdown")

an.Display=an.DropdownMenu.Display
an.Refresh=an.DropdownMenu.Refresh
an.Select=an.DropdownMenu.Select
an.Open=an.DropdownMenu.Open
an.Close=an.DropdownMenu.Close

ae("ImageLabel",{
Image=ad.Icon"chevrons-up-down"[1],
ImageRectOffset=ad.Icon"chevrons-up-down"[2].ImageRectPosition,
ImageRectSize=ad.Icon"chevrons-up-down"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(
1,
an.UIElements.Dropdown and-12 or 0,
0.5,
0
),
ThemeTag={
ImageColor3="Icon"
},
AnchorPoint=Vector2.new(1,0.5),
Parent=an.UIElements.Dropdown and an.UIElements.Dropdown.Frame or an.DropdownFrame.UIElements.Main
})

function an.Lock(ap,aq)
an.Locked=true
ao=false
return an.DropdownFrame:Lock(aq)
end
function an.Unlock(ap)
an.Locked=false
ao=true
return an.DropdownFrame:Unlock()
end

function an.Edit(ap,aq,ar)
an.DropdownMenu:Edit(aq,ar)
end

function an.EditDrop(ap,aq,ar)
an.DropdownMenu:EditDrop(aq,ar)
end

if an.Locked then
an:Lock()
end



local ap=an.Open

an.Open=function()
if an.Opened then

an.Close()
else

ap()
end
end

return an.__type,an
end

return ak end function a.L()






local aa={}
local ad={
lua={
"and","break","or","else","elseif","if","then","until","repeat","while","do","for","in","end",
"local","return","function","export",
},
rbx={
"game","workspace","script","math","string","table","task","wait","select","next","Enum",
"tick","assert","shared","loadstring","tonumber","tostring","type",
"typeof","unpack","Instance","CFrame","Vector3","Vector2","Color3","UDim","UDim2","Ray","BrickColor",
"OverlapParams","RaycastParams","Axes","Random","Region3","Rect","TweenInfo",
"collectgarbage","not","utf8","pcall","xpcall","_G","setmetatable","getmetatable","os","pairs","ipairs"
},
operators={
"#","+","-","*","%","/","^","=","~","=","<",">",
}
}

local ae={
numbers=Color3.fromHex"#FAB387",
boolean=Color3.fromHex"#FAB387",
operator=Color3.fromHex"#94E2D5",
lua=Color3.fromHex"#CBA6F7",
rbx=Color3.fromHex"#F38BA8",
str=Color3.fromHex"#A6E3A1",
comment=Color3.fromHex"#9399B2",
null=Color3.fromHex"#F38BA8",
call=Color3.fromHex"#89B4FA",
self_call=Color3.fromHex"#89B4FA",
local_property=Color3.fromHex"#CBA6F7",
}

local function createKeywordSet(ag)
local ai={}
for aj,ak in ipairs(ag)do
ai[ak]=true
end
return ai
end

local ag=createKeywordSet(ad.lua)
local ai=createKeywordSet(ad.rbx)
local aj=createKeywordSet(ad.operators)

local function getHighlight(ak,al)
local am=ak[al]

if ae[am.."_color"]then
return ae[am.."_color"]
end

if tonumber(am)then
return ae.numbers
elseif am=="nil"then
return ae.null
elseif am:sub(1,2)=="--"then
return ae.comment
elseif aj[am]then
return ae.operator
elseif ag[am]then
return ae.lua
elseif ai[am]then
return ae.rbx
elseif am:sub(1,1)=="\""or am:sub(1,1)=="\'"then
return ae.str
elseif am=="true"or am=="false"then
return ae.boolean
end

if ak[al+1]=="("then
if ak[al-1]==":"then
return ae.self_call
end

return ae.call
end

if ak[al-1]=="."then
if ak[al-2]=="Enum"then
return ae.rbx
end

return ae.local_property
end
end

function aa.run(ak)
local al={}
local am=""

local an=false
local ao=false
local ap=false

for aq=1,#ak do
local ar=ak:sub(aq,aq)

if ao then
if ar=="\n"and not ap then
table.insert(al,am)
table.insert(al,ar)
am=""

ao=false
elseif ak:sub(aq-1,aq)=="]]"and ap then
am=am.."]"

table.insert(al,am)
am=""

ao=false
ap=false
else
am=am..ar
end
elseif an then
if ar==an and ak:sub(aq-1,aq-1)~="\\"or ar=="\n"then
am=am..ar
an=false
else
am=am..ar
end
else
if ak:sub(aq,aq+1)=="--"then
table.insert(al,am)
am="-"
ao=true
ap=ak:sub(aq+2,aq+3)=="[["
elseif ar=="\""or ar=="\'"then
table.insert(al,am)
am=ar
an=ar
elseif aj[ar]then
table.insert(al,am)
table.insert(al,ar)
am=""
elseif ar:match"[%w_]"then
am=am..ar
else
table.insert(al,am)
table.insert(al,ar)
am=""
end
end
end

table.insert(al,am)

local aq={}

for ar,as in ipairs(al)do
local at=getHighlight(al,ar)

if at then
local au=string.format("<font color = \"#%s\">%s</font>",at:ToHex(),as:gsub("<","&lt;"):gsub(">","&gt;"))

table.insert(aq,au)
else
table.insert(aq,as)
end
end

return table.concat(aq)
end

return aa end function a.M()
local aa={}

local ad=a.load'b'
local ae=ad.New
local ag=ad.Tween

local ai=a.load'L'

function aa.New(aj,ak,al,am,an)
local ao={
Radius=12,
Padding=10
}

local ap=ae("TextLabel",{
Text="",
TextColor3=Color3.fromHex"#CDD6F4",
TextTransparency=0,
TextSize=14,
TextWrapped=false,
LineHeight=1.15,
RichText=true,
TextXAlignment="Left",
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,ao.Padding+3),
PaddingLeft=UDim.new(0,ao.Padding+3),
PaddingRight=UDim.new(0,ao.Padding+3),
PaddingBottom=UDim.new(0,ao.Padding+3),
})
})
ap.Font="Code"

local aq=ae("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticCanvasSize="X",
ScrollingDirection="X",
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
},{
ap
})

local ar=ae("TextButton",{
BackgroundTransparency=1,
Size=UDim2.new(0,30,0,30),
Position=UDim2.new(1,-ao.Padding/2,0,ao.Padding/2),
AnchorPoint=Vector2.new(1,0),
Visible=am and true or false,
},{
ad.NewRoundFrame(ao.Radius-4,"Squircle",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Button",
},{
ae("UIScale",{
Scale=1,
}),
ae("ImageLabel",{
Image=ad.Icon"copy"[1],
ImageRectSize=ad.Icon"copy"[2].ImageRectSize,
ImageRectOffset=ad.Icon"copy"[2].ImageRectPosition,
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Size=UDim2.new(0,12,0,12),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.1,
})
})
})

ad.AddSignal(ar.MouseEnter,function()
ag(ar.Button,.05,{ImageTransparency=.95}):Play()
ag(ar.Button.UIScale,.05,{Scale=.9}):Play()
end)
ad.AddSignal(ar.InputEnded,function()
ag(ar.Button,.08,{ImageTransparency=1}):Play()
ag(ar.Button.UIScale,.08,{Scale=1}):Play()
end)

local as=ad.NewRoundFrame(ao.Radius,"Squircle",{



ImageColor3=Color3.fromHex"#212121",
ImageTransparency=.035,
Size=UDim2.new(1,0,0,20+(ao.Padding*2)),
AutomaticSize="Y",
Parent=al,
},{
ad.NewRoundFrame(ao.Radius,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.955,
}),
ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
},{
ad.NewRoundFrame(ao.Radius,"Squircle-TL-TR",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.96,
Size=UDim2.new(1,0,0,20+(ao.Padding*2)),
Visible=ak and true or false
},{
ae("ImageLabel",{
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Image="rbxassetid://132464694294269",



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.2,
}),
ae("TextLabel",{
Text=ak,



TextColor3=Color3.fromHex"#ffffff",
TextTransparency=.2,
TextSize=16,
AutomaticSize="Y",
FontFace=Font.new(ad.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
BackgroundTransparency=1,
TextTruncate="AtEnd",
Size=UDim2.new(1,ar and-20-(ao.Padding*2),0,0)
}),
ae("UIPadding",{

PaddingLeft=UDim.new(0,ao.Padding+3),
PaddingRight=UDim.new(0,ao.Padding+3),

}),
ae("UIListLayout",{
Padding=UDim.new(0,ao.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
aq,
ae("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
})
}),
ar,
})

ao.CodeFrame=as

ad.AddSignal(ap:GetPropertyChangedSignal"TextBounds",function()
aq.Size=UDim2.new(1,0,0,(ap.TextBounds.Y/(an or 1))+((ao.Padding+3)*2))
end)

function ao.Set(at)
ap.Text=ai.run(at)
end

function ao.Destroy()
as:Destroy()
ao=nil
end

ao.Set(aj)

ad.AddSignal(ar.MouseButton1Click,function()
if am then
am()
local at=ad.Icon"check"
ar.Button.ImageLabel.Image=at[1]
ar.Button.ImageLabel.ImageRectSize=at[2].ImageRectSize
ar.Button.ImageLabel.ImageRectOffset=at[2].ImageRectPosition

task.wait(1)
local au=ad.Icon"copy"
ar.Button.ImageLabel.Image=au[1]
ar.Button.ImageLabel.ImageRectSize=au[2].ImageRectSize
ar.Button.ImageLabel.ImageRectOffset=au[2].ImageRectPosition
end
end)
return ao
end


return aa end function a.N()
local aa=a.load'b'local ad=
aa.New


local ae=a.load'M'

local ag={}

function ag.New(ai,aj)
local ak={
__type="Code",
Title=aj.Title,
Code=aj.Code,
OnCopy=aj.OnCopy,
}

local al=not ak.Locked











local am=ae.New(ak.Code,ak.Title,aj.Parent,function()
if al then
local am=ak.Title or"code"
local an,ao=pcall(function()
toclipboard(ak.Code)

if ak.OnCopy then ak.OnCopy()end
end)
if not an then
aj.ANUI:Notify{
Title="Error",
Content="The "..am.." is not copied. Error: "..ao,
Icon="x",
Duration=5,
}
end
end
end,aj.ANUI.UIScale,ak)

function ak.SetCode(an,ao)
am.Set(ao)
ak.Code=ao
end

function ak.Destroy(an)
am.Destroy()
ak=nil
end

ak.ElementFrame=am.CodeFrame

return ak.__type,ak
end

return ag end function a.O()
local aa=a.load'b'
local ad=aa.New local ae=
aa.Tween

local ag=(cloneref or clonereference or function(ag)return ag end)

local ai=ag(game:GetService"UserInputService")
ag(game:GetService"TouchInputService")
local aj=ag(game:GetService"RunService")
local ak=ag(game:GetService"Players")

local al=aj.RenderStepped
local am=ak.LocalPlayer
local an=am:GetMouse()

local ao=a.load'j'.New
local ap=a.load'k'.New

local aq={
UICorner=9,

}

function aq.Colorpicker(ar,as,at,au)
local av={
__type="Colorpicker",
Title=as.Title,
Desc=as.Desc,
Default=as.Default,
Callback=as.Callback,
Transparency=as.Transparency,
UIElements=as.UIElements,

TextPadding=10,
}

function av.SetHSVFromRGB(aw,ax)
local ay,az,aA=Color3.toHSV(ax)
av.Hue=ay
av.Sat=az
av.Vib=aA
end

av:SetHSVFromRGB(av.Default)

local aw=a.load'l'.Init(at)
local ax=aw.Create()

av.ColorpickerFrame=ax

ax.UIElements.Main.Size=UDim2.new(1,0,0,0)



local ay,az,aA=av.Hue,av.Sat,av.Vib

av.UIElements.Title=ad("TextLabel",{
Text=av.Title,
TextSize=20,
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=ax.UIElements.Main
},{
ad("UIPadding",{
PaddingTop=UDim.new(0,av.TextPadding/2),
PaddingLeft=UDim.new(0,av.TextPadding/2),
PaddingRight=UDim.new(0,av.TextPadding/2),
PaddingBottom=UDim.new(0,av.TextPadding/2),
})
})





local aB=ad("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=HueDragHolder,
BackgroundColor3=av.Default
},{
ad("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ad("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

av.UIElements.SatVibMap=ad("ImageLabel",{
Size=UDim2.fromOffset(160,158),
Position=UDim2.fromOffset(0,40+av.TextPadding),
Image="rbxassetid://4155801252",
BackgroundColor3=Color3.fromHSV(ay,1,1),
BackgroundTransparency=0,
Parent=ax.UIElements.Main,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ad("UIGradient",{
Rotation=45,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),

aB,
})

av.UIElements.Inputs=ad("Frame",{
AutomaticSize="XY",
Size=UDim2.new(0,0,0,0),
Position=UDim2.fromOffset(av.Transparency and 240 or 210,40+av.TextPadding),
BackgroundTransparency=1,
Parent=ax.UIElements.Main
},{
ad("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Vertical",
})
})





local d=ad("Frame",{
BackgroundColor3=av.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=av.Transparency,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ad("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(85,208+av.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ax.UIElements.Main,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ad("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),







d,
})

local e=ad("Frame",{
BackgroundColor3=av.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=0,
ZIndex=9,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ad("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,208+av.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ax.UIElements.Main,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),







aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ad("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),
e,
})

local f={}

for g=0,1,0.1 do
table.insert(f,ColorSequenceKeypoint.new(g,Color3.fromHSV(g,1,1)))
end

local g=ad("UIGradient",{
Color=ColorSequence.new(f),
Rotation=90,
})

local h=ad("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
})

local j=ad("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=h,


BackgroundColor3=av.Default
},{
ad("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ad("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

local l=ad("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(180,40+av.TextPadding),
Parent=ax.UIElements.Main,
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
}),
g,
h,
})


function CreateNewInput(m,p)
local r=ap(m,nil,av.UIElements.Inputs)

ad("TextLabel",{
BackgroundTransparency=1,
TextTransparency=.4,
TextSize=17,
FontFace=Font.new(aa.Font,Enum.FontWeight.Regular),
AutomaticSize="XY",
ThemeTag={
TextColor3="Placeholder",
},
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,-12,0.5,0),
Parent=r.Frame,
Text=m,
})

ad("UIScale",{
Parent=r,
Scale=.85,
})

r.Frame.Frame.TextBox.Text=p
r.Size=UDim2.new(0,150,0,42)

return r
end

local function ToRGB(m)
return{
R=math.floor(m.R*255),
G=math.floor(m.G*255),
B=math.floor(m.B*255)
}
end

local m=CreateNewInput("Hex","#"..av.Default:ToHex())

local p=CreateNewInput("Red",ToRGB(av.Default).R)
local r=CreateNewInput("Green",ToRGB(av.Default).G)
local u=CreateNewInput("Blue",ToRGB(av.Default).B)
local v
if av.Transparency then
v=CreateNewInput("Alpha",((1-av.Transparency)*100).."%")
end

local x=ad("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="Y",
Position=UDim2.new(0,0,0,254+av.TextPadding),
BackgroundTransparency=1,
Parent=ax.UIElements.Main,
LayoutOrder=4,
},{
ad("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
}),






})

local z={
{
Title="Cancel",
Variant="Secondary",
Callback=function()end
},
{
Title="Apply",
Icon="chevron-right",
Variant="Primary",
Callback=function()au(Color3.fromHSV(av.Hue,av.Sat,av.Vib),av.Transparency)end
}
}

for A,B in next,z do
local C=ao(B.Title,B.Icon,B.Callback,B.Variant,x,ax,false)
C.Size=UDim2.new(0.5,-3,0,40)
C.AutomaticSize="None"
end



local A,B,C
if av.Transparency then
local F=ad("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.fromOffset(0,0),
BackgroundTransparency=1,
})

B=ad("ImageLabel",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
ThemeTag={
BackgroundColor3="Text",
},
Parent=F,

},{
ad("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ad("UICorner",{
CornerRadius=UDim.new(1,0),
})

})

C=ad("Frame",{
Size=UDim2.fromScale(1,1),
},{
ad("UIGradient",{
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
},
Rotation=270,
}),
ad("UICorner",{
CornerRadius=UDim.new(0,6),
}),
})

A=ad("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(210,40+av.TextPadding),
Parent=ax.UIElements.Main,
BackgroundTransparency=1,
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
}),
ad("ImageLabel",{
Image="rbxassetid://14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
C,
F,
})
end

function av.Round(F,G,H)
if H==0 then
return math.floor(G)
end
G=tostring(G)
return G:find"%."and tonumber(G:sub(1,G:find"%."+H))or G
end


function av.Update(F,G,H)
if G then ay,az,aA=Color3.toHSV(G)else ay,az,aA=av.Hue,av.Sat,av.Vib end

av.UIElements.SatVibMap.BackgroundColor3=Color3.fromHSV(ay,1,1)
aB.Position=UDim2.new(az,0,1-aA,0)
aB.BackgroundColor3=Color3.fromHSV(ay,az,aA)
e.BackgroundColor3=Color3.fromHSV(ay,az,aA)
j.BackgroundColor3=Color3.fromHSV(ay,1,1)
j.Position=UDim2.new(0.5,0,ay,0)

m.Frame.Frame.TextBox.Text="#"..Color3.fromHSV(ay,az,aA):ToHex()
p.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(ay,az,aA)).R
r.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(ay,az,aA)).G
u.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(ay,az,aA)).B

if H or av.Transparency then
e.BackgroundTransparency=av.Transparency or H
C.BackgroundColor3=Color3.fromHSV(ay,az,aA)
B.BackgroundColor3=Color3.fromHSV(ay,az,aA)
B.BackgroundTransparency=av.Transparency or H
B.Position=UDim2.new(0.5,0,1-av.Transparency or H,0)
v.Frame.Frame.TextBox.Text=av:Round((1-av.Transparency or H)*100,0).."%"
end
end

av:Update(av.Default,av.Transparency)




local function GetRGB()
local F=Color3.fromHSV(av.Hue,av.Sat,av.Vib)
return{R=math.floor(F.r*255),G=math.floor(F.g*255),B=math.floor(F.b*255)}
end



local function clamp(F,G,H)
return math.clamp(tonumber(F)or 0,G,H)
end

aa.AddSignal(m.Frame.Frame.TextBox.FocusLost,function(F)
if F then
local G=m.Frame.Frame.TextBox.Text:gsub("#","")
local H,J=pcall(Color3.fromHex,G)
if H and typeof(J)=="Color3"then
av.Hue,av.Sat,av.Vib=Color3.toHSV(J)
av:Update()
av.Default=J
end
end
end)

local function updateColorFromInput(F,G)
aa.AddSignal(F.Frame.Frame.TextBox.FocusLost,function(H)
if H then
local J=F.Frame.Frame.TextBox
local L=GetRGB()
local M=clamp(J.Text,0,255)
J.Text=tostring(M)

L[G]=M
local N=Color3.fromRGB(L.R,L.G,L.B)
av.Hue,av.Sat,av.Vib=Color3.toHSV(N)
av:Update()
end
end)
end

updateColorFromInput(p,"R")
updateColorFromInput(r,"G")
updateColorFromInput(u,"B")

if av.Transparency then
aa.AddSignal(v.Frame.Frame.TextBox.FocusLost,function(F)
if F then
local G=v.Frame.Frame.TextBox
local H=clamp(G.Text,0,100)
G.Text=tostring(H)

av.Transparency=1-H*0.01
av:Update(nil,av.Transparency)
end
end)
end



local F=av.UIElements.SatVibMap
aa.AddSignal(F.InputBegan,function(G)
if G.UserInputType==Enum.UserInputType.MouseButton1 or G.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local H=F.AbsolutePosition.X
local J=H+F.AbsoluteSize.X
local L=math.clamp(an.X,H,J)

local M=F.AbsolutePosition.Y
local N=M+F.AbsoluteSize.Y
local O=math.clamp(an.Y,M,N)

av.Sat=(L-H)/(J-H)
av.Vib=1-((O-M)/(N-M))
av:Update()

al:Wait()
end
end
end)

aa.AddSignal(l.InputBegan,function(G)
if G.UserInputType==Enum.UserInputType.MouseButton1 or G.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local H=l.AbsolutePosition.Y
local J=H+l.AbsoluteSize.Y
local L=math.clamp(an.Y,H,J)

av.Hue=((L-H)/(J-H))
av:Update()

al:Wait()
end
end
end)

if av.Transparency then
aa.AddSignal(A.InputBegan,function(G)
if G.UserInputType==Enum.UserInputType.MouseButton1 or G.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local H=A.AbsolutePosition.Y
local J=H+A.AbsoluteSize.Y
local L=math.clamp(an.Y,H,J)

av.Transparency=1-((L-H)/(J-H))
av:Update()

al:Wait()
end
end
end)
end

return av
end

function aq.New(ar,as)
local at={
__type="Colorpicker",
Title=as.Title or"Colorpicker",
Desc=as.Desc or nil,
Locked=as.Locked or false,
Default=as.Default or Color3.new(1,1,1),
Callback=as.Callback or function()end,

UIScale=as.UIScale,
Transparency=as.Transparency,
UIElements={}
}

local au=true



at.ColorpickerFrame=a.load'z'{
Title=at.Title,
Desc=at.Desc,
Parent=as.Parent,
TextOffset=40,
Hover=false,
Tab=as.Tab,
Index=as.Index,
Window=as.Window,
ElementTable=at,
ParentConfig=as,
}

at.UIElements.Colorpicker=aa.NewRoundFrame(aq.UICorner,"Squircle",{
ImageTransparency=0,
Active=true,
ImageColor3=at.Default,
Parent=at.ColorpickerFrame.UIElements.Main,
Size=UDim2.new(0,26,0,26),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
ZIndex=2
},nil,true)


function at.Lock(av)
at.Locked=true
au=false
return at.ColorpickerFrame:Lock()
end
function at.Unlock(av)
at.Locked=false
au=true
return at.ColorpickerFrame:Unlock()
end

if at.Locked then
at:Lock()
end


function at.Update(av,aw,ax)
at.UIElements.Colorpicker.ImageTransparency=ax or 0
at.UIElements.Colorpicker.ImageColor3=aw
at.Default=aw
if ax then
at.Transparency=ax
end
end

function at.Set(av,aw,ax)
return at:Update(aw,ax)
end

aa.AddSignal(at.UIElements.Colorpicker.MouseButton1Click,function()
if au then
aq:Colorpicker(at,as.Window,function(av,aw)
at:Update(av,aw)
at.Default=av
at.Transparency=aw
aa.SafeCallback(at.Callback,av,aw)
end).ColorpickerFrame:Open()
end
end)

return at.__type,at
end

return aq end function a.P()
local aa=a.load'b'
local ad=aa.New
local ae=aa.Tween

local ag={}

function ag.New(ai,aj)
local ak={
__type="Section",
Title=aj.Title or"Section",
Icon=aj.Icon,
TextXAlignment=aj.TextXAlignment or"Left",
TextSize=aj.TextSize or 19,
Box=aj.Box or false,
FontWeight=aj.FontWeight or Enum.FontWeight.SemiBold,
TextTransparency=aj.TextTransparency or 0.05,
Opened=aj.Opened or false,
UIElements={},

HeaderSize=42,
IconSize=20,
Padding=10,

Elements={},

Expandable=false,
}

local al


function ak.SetIcon(am,an)
ak.Icon=an or nil
if al then al:Destroy()end
if an then
al=aa.Image(
an,
an..":"..ak.Title,
0,
aj.Window.Folder,
ak.__type,
true
)
al.Size=UDim2.new(0,ak.IconSize,0,ak.IconSize)
end
end

local am=ad("Frame",{
Size=UDim2.new(0,ak.IconSize,0,ak.IconSize),
BackgroundTransparency=1,
Visible=false
},{
ad("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=aa.Icon"chevron-down"[1],
ImageRectSize=aa.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=aa.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.7,
})
})


if ak.Icon then
ak:SetIcon(ak.Icon)
end

local an=ad("TextLabel",{
BackgroundTransparency=1,
TextXAlignment=ak.TextXAlignment,
AutomaticSize="Y",
TextSize=ak.TextSize,
TextTransparency=ak.TextTransparency,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(aa.Font,ak.FontWeight),


Text=ak.Title,
Size=UDim2.new(
1,
0,
0,
0
),
TextWrapped=true,
})


local function UpdateTitleSize()
local ao=0
if al then
ao=ao-(ak.IconSize+8)
end
if am.Visible then
ao=ao-(ak.IconSize+8)
end
an.Size=UDim2.new(1,ao,0,0)
end


local ao=aa.NewRoundFrame(aj.Window.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Parent=aj.Parent,
ClipsDescendants=true,
AutomaticSize="Y",
ImageTransparency=ak.Box and.93 or 1,
ThemeTag={
ImageColor3="Text",
},
},{
ad("TextButton",{
Size=UDim2.new(1,0,0,Expandable and 0 or ak.HeaderSize),
BackgroundTransparency=1,
AutomaticSize=Expandable and nil or"Y",
Text="",
Name="Top",
},{
ak.Box and ad("UIPadding",{
PaddingLeft=UDim.new(0,aj.Window.ElementConfig.UIPadding),
PaddingRight=UDim.new(0,aj.Window.ElementConfig.UIPadding),
})or nil,
al,
an,
ad("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
am,
}),
ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=false,
Position=UDim2.new(0,0,0,ak.HeaderSize)
},{
ak.Box and ad("UIPadding",{
PaddingLeft=UDim.new(0,aj.Window.ElementConfig.UIPadding),
PaddingRight=UDim.new(0,aj.Window.ElementConfig.UIPadding),
PaddingBottom=UDim.new(0,aj.Window.ElementConfig.UIPadding),
})or nil,
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,aj.Tab.Gap),
VerticalAlignment="Top",
}),
})
})

ak.ElementFrame=ao







local ap=aj.ElementsModule

ap.Load(ak,ao.Content,ap.Elements,aj.Window,aj.ANUI,function()
if not ak.Expandable then
ak.Expandable=true
am.Visible=true
UpdateTitleSize()
end
end,ap,aj.UIScale,aj.Tab)


UpdateTitleSize()

function ak.SetTitle(aq,ar)
an.Text=ar
end

function ak.Destroy(aq)
for ar,as in next,ak.Elements do
as:Destroy()
end








ao:Destroy()
end

function ak.Open(aq)
if ak.Expandable then
ak.Opened=true
ae(ao,0.33,{
Size=UDim2.new(1,0,0,ak.HeaderSize+(ao.Content.AbsoluteSize.Y/aj.UIScale))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ae(am.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function ak.Close(aq)
if ak.Expandable then
ak.Opened=false
ae(ao,0.26,{
Size=UDim2.new(1,0,0,ak.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(am.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

aa.AddSignal(ao.Top.MouseButton1Click,function()
if ak.Expandable then
if ak.Opened then
ak:Close()
else
ak:Open()
end
end
end)

aa.AddSignal(ao.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if ak.Opened then
ak:Open()
end
end)

task.spawn(function()
task.wait(0.02)
if ak.Expandable then








ao.Size=UDim2.new(1,0,0,ak.HeaderSize)
ao.AutomaticSize="None"
ao.Top.Size=UDim2.new(1,0,0,ak.HeaderSize)
ao.Top.AutomaticSize="None"
ao.Content.Visible=true
end
if ak.Opened then
ak:Open()
end

end)

return ak.__type,ak
end

return ag end function a.Q()
local aa=a.load'b'
local ad=aa.New

local ae={}

function ae.New(ag,ai)
local aj=ad("Frame",{
Parent=ai.Parent,
Size=ai.ParentType~="Group"and UDim2.new(1,-7,0,7*(ai.Columns or 1))or UDim2.new(0,7*(ai.Columns or 1),0,0),
BackgroundTransparency=1,
})

return"Space",{__type="Space",ElementFrame=aj}
end

return ae end function a.R()
local aa=a.load'b'
local ad=aa.New

local ae={}

local function ParseAspectRatio(ag)
if type(ag)=="string"then
local ai,aj=ag:match"(%d+):(%d+)"
if ai and aj then
return tonumber(ai)/tonumber(aj)
end
elseif type(ag)=="number"then
return ag
end
return nil
end

function ae.New(ag,ai)
local aj={
__type="Image",
Image=ai.Image or"",
AspectRatio=ai.AspectRatio or"16:9",
Radius=ai.Radius or ai.Window.ElementConfig.UICorner,
}
local ak=aa.Image(
aj.Image,
aj.Image,
aj.Radius,
ai.Window.Folder,
"Image",
false
)
ak.Parent=ai.Parent
ak.Size=UDim2.new(1,0,0,0)
ak.BackgroundTransparency=1












local al=ParseAspectRatio(aj.AspectRatio)
local am

if al then
am=ad("UIAspectRatioConstraint",{
Parent=ak,
AspectRatio=al,
AspectType="ScaleWithParentSize",
DominantAxis="Width"
})
end

function aj.Destroy(an)
ak:Destroy()
end

return aj.__type,aj
end

return ae end function a.S()
local aa=a.load'b'
local ad=aa.New

local ae={}

function ae.New(ag,ai)
local aj={
__type="Group",
Elements={}
}

local ak=ad("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ai.Parent,
},{
ad("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Center",
VerticalAlignment="Center",
Padding=UDim.new(0,ai.Tab and ai.Tab.Gap or((ai.Window and ai.Window.NewElements)and 1 or 6))
}),
})

aj.GroupFrame=ak

local al=ai.ElementsModule
al.Load(
aj,
ak,
al.Elements,
ai.Window,
ai.ANUI,
function(am,an)
local ao=ai.Tab and ai.Tab.Gap or((ai.Window and ai.Window.NewElements)and 1 or 6)

local ap={}
local aq=0

for ar,as in next,an do
if as.__type=="Space"then
aq=aq+(as.ElementFrame.Size.X.Offset or 6)
elseif as.__type=="Divider"then
aq=aq+(as.ElementFrame.Size.X.Offset or 1)
else
table.insert(ap,as)
end
end

local ar=#ap
if ar==0 then return end

local as=ak.AbsoluteSize.X
local at
if as and as>0 then
local au=ao*(ar-1)
local av=math.max(as-au-aq,0)
at=(av/as)/ar
else
at=1/ar
end

for au,av in next,ap do
if av.ElementFrame then
av.ElementFrame.Size=UDim2.new(at,0,1,0)
end
end
end,
al,
ai.UIScale,
ai.Tab
)



return aj.__type,aj
end

return ae end function a.T()

local aa=a.load'b'
local ad=aa.New
local ae=aa.Tween

local ag={}

function ag.New(ai,aj)
local ak={
__type="Category",
Title=aj.Title,
Desc=aj.Desc,
Options=aj.Options or{},
Default=aj.Default,
Callback=aj.Callback or function()end,
Parent=aj.Parent,
UIElements={},
}



local al=ad("Frame",{
Size=UDim2.new(1,0,0,45),
BackgroundTransparency=1,
Parent=aj.Parent,
})


local am=ad("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScrollingDirection=Enum.ScrollingDirection.X,
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize=Enum.AutomaticSize.X,
Parent=al,
},{
ad("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,8),
VerticalAlignment=Enum.VerticalAlignment.Center,
}),
ad("UIPadding",{
PaddingLeft=UDim.new(0,2),
PaddingRight=UDim.new(0,2),
})
})


am.Active=true

local an=false
local ao=Vector2.new()
local ap=Vector2.new()


am.InputBegan:Connect(function(aq)
if aq.UserInputType==Enum.UserInputType.MouseButton1 then
an=true
ao=aq.Position
ap=am.CanvasPosition
end
end)


am.InputEnded:Connect(function(aq)
if aq.UserInputType==Enum.UserInputType.MouseButton1 then
an=false
end
end)


am.InputChanged:Connect(function(aq)
if aq.UserInputType==Enum.UserInputType.MouseMovement then
if an then
local ar=aq.Position-ao

am.CanvasPosition=Vector2.new(ap.X-ar.X,0)
end
elseif aq.UserInputType==Enum.UserInputType.MouseWheel then

local ar=aq.Position.Z*-35
am.CanvasPosition=am.CanvasPosition+Vector2.new(ar,0)
end
end)


local aq={}

local function UpdateVisuals(ar)
for as,at in pairs(aq)do
local au=(as==ar)
local av=aa.Theme

local aw=aa.GetThemeProperty(au and"Toggle"or"Button",av)
local ax=aa.GetThemeProperty("Text",av)
local ay=au and 0 or 0.5

ae(at.Background,0.2,{ImageColor3=aw}):Play()
ae(at.Title,0.2,{TextTransparency=ay,TextColor3=ax}):Play()

if at.Icon then
ae(at.Icon.ImageLabel,0.2,{ImageTransparency=ay,ImageColor3=ax}):Play()
end
end
end

for ar,as in ipairs(ak.Options)do
local at=(type(as)=="table"and as.Title)or as
local au=(type(as)=="table"and as.Icon)or nil

local av=ad("TextButton",{
AutoButtonColor=false,
Size=UDim2.new(0,0,0,32),
AutomaticSize=Enum.AutomaticSize.X,
BackgroundTransparency=1,
Text="",
Parent=am,
LayoutOrder=ar
})

local aw=aa.NewRoundFrame(8,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={ImageColor3="Button"},
Name="Background",
Parent=av
},{
ad("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
VerticalAlignment=Enum.VerticalAlignment.Center,
Padding=UDim.new(0,6),
HorizontalAlignment=Enum.HorizontalAlignment.Center,
}),
ad("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
})
})

local ax
if au then
ax=aa.Image(au,"Icon",0,aj.Window.Folder,"Icon",false)
ax.Size=UDim2.new(0,18,0,18)
ax.BackgroundTransparency=1
ax.ImageLabel.ImageTransparency=0.5
ax.Parent=aw
end

local ay=ad("TextLabel",{
Text=at,
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
TextSize=14,
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.XY,
ThemeTag={TextColor3="Text"},
TextTransparency=0.5,
Parent=aw
})

aq[at]={
Frame=av,
Background=aw,
Title=ay,
Icon=ax
}

aa.AddSignal(av.MouseButton1Click,function()
UpdateVisuals(at)
if ak.Callback then
ak.Callback(at)
end
end)
end

if ak.Default then
UpdateVisuals(ak.Default)
elseif ak.Options[1]then
local ar=ak.Options[1]
local as=(type(ar)=="table"and ar.Title)or ar
UpdateVisuals(as)
end


ak.ElementFrame=al
return ak.__type,ak
end

return ag end function a.U()
return{
Elements={
Paragraph=a.load'A',
Button=a.load'B',
Toggle=a.load'E',
Slider=a.load'F',
Keybind=a.load'G',
Input=a.load'H',
Dropdown=a.load'K',
Code=a.load'N',
Colorpicker=a.load'O',
Section=a.load'P',
Divider=a.load'I',
Space=a.load'Q',
Image=a.load'R',
Group=a.load'S',
Category=a.load'T'

},
Load=function(aa,ad,ae,ag,ai,aj,ak,al,am)
for an,ao in next,ae do
aa[an]=function(ap,aq)
aq=aq or{}
aq.Tab=am or aa
aq.ParentType=aa.__type
aq.ParentTable=aa
aq.Index=#aa.Elements+1
aq.GlobalIndex=#ag.AllElements+1
aq.Parent=ad
aq.Window=ag
aq.ANUI=ai
aq.UIScale=al
aq.ElementsModule=ak local

ar, as=ao:New(aq)

if aq.Flag and typeof(aq.Flag)=="string"then
if ag.CurrentConfig then
ag.CurrentConfig:Register(aq.Flag,as)

if ag.PendingConfigData and ag.PendingConfigData[aq.Flag]then
local at=ag.PendingConfigData[aq.Flag]

local au=ag.ConfigManager
if au.Parser[at.__type]then
task.defer(function()
local av,aw=pcall(function()
au.Parser[at.__type].Load(as,at)
end)

if av then
ag.PendingConfigData[aq.Flag]=nil
else
warn("[ ANUI ] Failed to apply pending config for '"..aq.Flag.."': "..tostring(aw))
end
end)
end
end
else
ag.PendingFlags=ag.PendingFlags or{}
ag.PendingFlags[aq.Flag]=as
end
end

local at
for au,av in pairs(as)do
if typeof(av)=="table"and au:match"Frame$"then
at=av
break
end
end

if at then
as.ElementFrame=at.UIElements.Main
function as.SetTitle(au,av)
at:SetTitle(av)
end
function as.SetDesc(au,av)
at:SetDesc(av)
end
function as.SetImage(au,av,aw)
at:SetImage(av,aw)
end
function as.SetIcon(au,av,aw)
at:SetImage(av,aw)
end
function as.Highlight(au)
at:Highlight()
end
function as.Destroy(au)
at:Destroy()

table.remove(ag.AllElements,aq.GlobalIndex)
table.remove(aa.Elements,aq.Index)
table.remove(am.Elements,aq.Index)
aa:UpdateAllElementShapes(aa)
end
end



ag.AllElements[aq.Index]=as
aa.Elements[aq.Index]=as
if am then am.Elements[aq.Index]=as end

if ag.NewElements then
aa:UpdateAllElementShapes(aa)
end

if aj then
aj(as,aa.Elements)
end
return as
end
end
function aa.UpdateAllElementShapes(an,ao)
for ap,aq in next,ao.Elements do
local ar
for as,at in pairs(aq)do
if typeof(at)=="table"and as:match"Frame$"then
ar=at
break
end
end

if ar then

ar.Index=ap
if ar.UpdateShape then

ar.UpdateShape(ao)
end
end
end
end
end,

}end function a.V()

local aa=(cloneref or clonereference or function(aa)return aa end)

aa(game:GetService"UserInputService")
local ad=game.Players.LocalPlayer:GetMouse()

local ae=a.load'b'
local ag=ae.New
local ai=ae.Tween

local aj=a.load'y'.New
local ak=a.load'u'.New



local al={
Tabs={},
Containers={},
SelectedTab=nil,
TabCount=0,
ToolTipParent=nil,
TabHighlight=nil,

OnChangeFunc=function(al)end
}

function al.Init(am,an,ao,ap)
Window=am
ANUI=an
al.ToolTipParent=ao
al.TabHighlight=ap
return al
end

function al.New(am,an)
local ao={
__type="Tab",
Title=am.Title or"Tab",
Desc=am.Desc,
Icon=am.Icon,
Image=am.Image,
IconThemed=am.IconThemed,
Locked=am.Locked,
ShowTabTitle=am.ShowTabTitle,

Profile=am.Profile,
SidebarProfile=am.SidebarProfile,

Selected=false,
Index=nil,
Parent=am.Parent,
UIElements={},
Elements={},
ContainerFrame=nil,
UICorner=Window.UICorner-(Window.UIPadding/2),

Gap=Window.NewElements and 1 or 6,
}

local ap=ao.Profile and ao.SidebarProfile
local aq=ao.Profile


local ar=aq and(ao.Profile.Sticky~=false)

if ap then
ao.Locked=true
end

al.TabCount=al.TabCount+1

local as=al.TabCount
ao.Index=as


ao.UIElements.Main=ae.NewRoundFrame(ao.UICorner,"Squircle",{
BackgroundTransparency=1,
Size=UDim2.new(1,-7,0,0),
AutomaticSize="Y",
Parent=am.Parent,
ThemeTag={
ImageColor3="TabBackground",
},
ImageTransparency=1,
},{
ae.NewRoundFrame(ao.UICorner,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline"
},{
ag("UIGradient",{
Rotation=80,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
ae.NewRoundFrame(ao.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Frame",
ClipsDescendants=true,
},{
ag("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ag("TextLabel",{
Text=ao.Title,
ThemeTag={
TextColor3="TabTitle"
},
TextTransparency=not ao.Locked and 0.4 or.7,
TextSize=15,
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
TextWrapped=true,
RichText=true,
AutomaticSize="Y",
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
}),
ag("UIPadding",{
PaddingTop=UDim.new(0,2+(Window.UIPadding/2)),
PaddingLeft=UDim.new(0,4+(Window.UIPadding/2)),
PaddingRight=UDim.new(0,4+(Window.UIPadding/2)),
PaddingBottom=UDim.new(0,2+(Window.UIPadding/2)),
})
}),
},true)

local at=0
local au
local av


if ao.Icon and not ap then
au=ae.Image(ao.Icon,ao.Icon..":"..ao.Title,0,Window.Folder,ao.__type,true,ao.IconThemed,"TabIcon")
au.Size=UDim2.new(0,16,0,16)
au.Parent=ao.UIElements.Main.Frame
au.ImageLabel.ImageTransparency=not ao.Locked and 0 or.7
ao.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,-30,0,0)
at=-30
ao.UIElements.Icon=au

av=ae.Image(ao.Icon,ao.Icon..":"..ao.Title,0,Window.Folder,ao.__type,true,ao.IconThemed)
av.Size=UDim2.new(0,16,0,16)
av.ImageLabel.ImageTransparency=not ao.Locked and 0 or.7
at=-30
end


if ao.Image and not ap then
local aw=ae.Image(ao.Image,ao.Title,ao.UICorner,Window.Folder,"TabImage",false)
aw.Size=UDim2.new(1,0,0,100)
aw.Parent=ao.UIElements.Main.Frame
aw.ImageLabel.ImageTransparency=not ao.Locked and 0 or.7
aw.LayoutOrder=-1

ao.UIElements.Main.Frame.UIListLayout.FillDirection="Vertical"
ao.UIElements.Main.Frame.UIListLayout.Padding=UDim.new(0,0)
ao.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,0,0,30)
ao.UIElements.Main.Frame.TextLabel.TextXAlignment="Center"
ao.UIElements.Main.Frame.UIPadding.PaddingTop=UDim.new(0,0)
ao.UIElements.Main.Frame.UIPadding.PaddingLeft=UDim.new(0,0)
ao.UIElements.Main.Frame.UIPadding.PaddingRight=UDim.new(0,0)
ao.UIElements.Main.Frame.UIPadding.PaddingBottom=UDim.new(0,0)

ao.UIElements.Image=aw
end


if ap then
local aw=ao.UIElements.Main.Frame:FindFirstChild"UIListLayout"
if aw then aw:Destroy()end
local ax=ao.UIElements.Main.Frame:FindFirstChild"UIPadding"
if ax then ax:Destroy()end
local ay=ao.UIElements.Main.Frame:FindFirstChild"TextLabel"
if ay then ay:Destroy()end

ao.UIElements.Main.Frame.AutomaticSize=Enum.AutomaticSize.None
ao.UIElements.Main.Frame.Size=UDim2.new(1,0,0,120)

local az=55
if ao.Profile.Banner then
local aA=ae.Image(
ao.Profile.Banner,"SidebarBanner",0,Window.Folder,"ProfileBanner",false
)
aA.Size=UDim2.new(1,0,0,az)
aA.Position=UDim2.new(0,0,0,0)
aA.BackgroundTransparency=1
aA.Parent=ao.UIElements.Main.Frame
aA.ZIndex=1

if aA:FindFirstChild"ImageLabel"then
aA.ImageLabel.ScaleType=Enum.ScaleType.Crop
aA.ImageLabel.Size=UDim2.fromScale(1,1)
end
end


if ao.Profile.Badges then
local aA=ag("Frame",{
Name="SidebarBadgeContainer",
Size=UDim2.new(0,0,0,24),
AutomaticSize=Enum.AutomaticSize.X,
Position=UDim2.new(1,-6,0,az-4),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
Parent=ao.UIElements.Main.Frame,
ZIndex=5
},{
ag("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
HorizontalAlignment=Enum.HorizontalAlignment.Right,
VerticalAlignment=Enum.VerticalAlignment.Center,
Padding=UDim.new(0,4)
})
})

for aB,d in ipairs(ao.Profile.Badges)do
local e=d.Icon or"help-circle"
local f=d.Title~=nil

local g=ag("Frame",{
Name="BadgeWrapper",
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,24),
AutomaticSize=Enum.AutomaticSize.X,
Parent=aA,
})

local h=ae.NewRoundFrame(6,"Squircle",{
ImageColor3=Color3.new(0,0,0),
ImageTransparency=0.4,
Size=UDim2.new(1,0,1,0),
Name="BG",
Parent=g
})

local j=ag("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Parent=g
},{
ag("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
VerticalAlignment=Enum.VerticalAlignment.Center,
HorizontalAlignment=Enum.HorizontalAlignment.Center,
Padding=UDim.new(0,4)
}),
ag("UIPadding",{
PaddingLeft=UDim.new(0,f and 6 or 4),
PaddingRight=UDim.new(0,f and 6 or 4),
})
})

local l=ae.Image(e,"BadgeIcon",0,Window.Folder,"Badge",false)
l.Size=UDim2.new(0,14,0,14)
l.BackgroundTransparency=1
l.Parent=j

local m=l:FindFirstChild"ImageLabel"or l:FindFirstChild"VideoFrame"
if m then
m.Size=UDim2.fromScale(1,1)
m.ImageColor3=Color3.new(1,1,1)
m.BackgroundTransparency=1
end

if f then
ag("TextLabel",{
Text=d.Title,
TextSize=11,
FontFace=Font.new(ae.Font,Enum.FontWeight.SemiBold),
TextColor3=Color3.new(1,1,1),
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.XY,
LayoutOrder=2,
Parent=j
})
end

local p=ag("TextButton",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Text="",
ZIndex=10,
Parent=g
})

if d.Callback then
ae.AddSignal(p.MouseButton1Click,function()
d.Callback()
end)
end

ae.AddSignal(p.MouseEnter,function()
ai(h,0.1,{ImageTransparency=0.2}):Play()
end)
ae.AddSignal(p.MouseLeave,function()
ai(h,0.1,{ImageTransparency=0.4}):Play()
end)

if d.Desc then
local r
local u
local v
local x=false

ae.AddSignal(p.MouseEnter,function()
x=true
u=task.spawn(function()
task.wait(0.35)
if x and not r then
r=aj(d.Desc,al.ToolTipParent)
local function updatePosition()
if r then
r.Container.Position=UDim2.new(0,ad.X,0,ad.Y-20)
end
end
updatePosition()
v=ad.Move:Connect(updatePosition)
r:Open()
end
end)
end)

ae.AddSignal(p.MouseLeave,function()
x=false
if u then task.cancel(u)u=nil end
if v then v:Disconnect()v=nil end
if r then r:Close()r=nil end
end)
end
end
end

local aA=46
local aB=ag("Frame",{
Name="Avatar",
Size=UDim2.new(0,aA,0,aA),
Position=UDim2.new(0,10,0,az-(aA/2)),
BackgroundTransparency=1,
Parent=ao.UIElements.Main.Frame,
ZIndex=2
})

if ao.Profile.Avatar then
local d=ae.Image(
ao.Profile.Avatar,"SidebarAvatar",0,Window.Folder,"ProfileAvatar",false
)
d.Size=UDim2.fromScale(1,1)
d.Parent=aB
d.BackgroundTransparency=1

local e=d:FindFirstChild"ImageLabel"
if e then
e.Size=UDim2.fromScale(1,1)
e.BackgroundTransparency=1
local f=e:FindFirstChildOfClass"UICorner"
if f then f:Destroy()end
ag("UICorner",{CornerRadius=UDim.new(1,0),Parent=e})
end

ag("UIStroke",{
Parent=aB,
Thickness=2.5,
ThemeTag={Color="TabBackground"},
Transparency=0,
ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})
ag("UICorner",{CornerRadius=UDim.new(1,0),Parent=aB})
end

if ao.Profile.Status then
ag("Frame",{
Size=UDim2.new(0,12,0,12),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundColor3=Color3.fromHex"#23a559",
Parent=aB,
ZIndex=3
},{
ag("UICorner",{CornerRadius=UDim.new(1,0)}),
ag("UIStroke",{
Thickness=2,
ThemeTag={Color="TabBackground"}
})
})
end

ag("Frame",{
Size=UDim2.new(1,-(10+aA+8),1,-az-6),
Position=UDim2.new(0,10+aA+8,0,az+5),
BackgroundTransparency=1,
Parent=ao.UIElements.Main.Frame,
ZIndex=2
},{
ag("UIListLayout",{
VerticalAlignment=Enum.VerticalAlignment.Top,
Padding=UDim.new(0,2)
}),
ag("TextLabel",{
Text=ao.Profile.Title or ao.Title,
TextSize=16,
FontFace=Font.new(ae.Font,Enum.FontWeight.Bold),
ThemeTag={TextColor3="TabTitle"},
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,18),
TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,
TextTransparency=not ao.Locked and 0 or.7,
}),
ag("TextLabel",{
Text=ao.Profile.Desc or"User",
TextSize=13,
FontFace=Font.new(ae.Font,Enum.FontWeight.Regular),
ThemeTag={TextColor3="Text"},
TextTransparency=0.5,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,14),
TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd
})
})
end


local aw=0
local ax=0

local ay=150

if ao.ShowTabTitle then
aw=((Window.UIPadding*2.4)+12)
ax=ax-aw
end


if aq and ar then
aw=aw+ay
ax=ax-ay
end


ao.UIElements.ContainerFrame=ag("ScrollingFrame",{
Size=UDim2.new(1,0,1,ax),
Position=UDim2.new(0,0,0,aw),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
},{
ag("UIPadding",{
PaddingTop=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingLeft=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingRight=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingBottom=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
}),
ag("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,ao.Gap),
HorizontalAlignment="Center",
})
})


ao.UIElements.ContainerFrameCanvas=ag("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Visible=false,
Parent=Window.UIElements.MainBar,
ZIndex=5,
},{
ag("Frame",{
Size=UDim2.new(1,0,0,((Window.UIPadding*2.4)+12)),
BackgroundTransparency=1,
Visible=ao.ShowTabTitle or false,
Name="TabTitle"
},{
av,
ag("TextLabel",{
Text=ao.Title,
ThemeTag={
TextColor3="Text"
},
TextSize=20,
TextTransparency=.1,
Size=UDim2.new(1,-at,1,0),
FontFace=Font.new(ae.Font,Enum.FontWeight.SemiBold),
TextTruncate="AtEnd",
RichText=true,
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
}),
ag("UIPadding",{
PaddingTop=UDim.new(0,20),
PaddingLeft=UDim.new(0,20),
PaddingRight=UDim.new(0,20),
PaddingBottom=UDim.new(0,20),
}),
ag("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
ag("Frame",{
Size=UDim2.new(1,0,0,1),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
},
Position=UDim2.new(0,0,0,((Window.UIPadding*2.4)+12)),
Visible=ao.ShowTabTitle or false,
})
})


if aq then
local az=100
local aA=70

local aB=ag("Frame",{
Name="ProfileHeader",
Size=UDim2.new(1,0,0,ay),

Position=UDim2.new(0,0,0,ao.ShowTabTitle and((Window.UIPadding*2.4)+12)or 0),
BackgroundTransparency=1,
ZIndex=2
})


if ar and not ap then
aB.Parent=ao.UIElements.ContainerFrameCanvas
else
aB.Parent=ao.UIElements.ContainerFrame
aB.LayoutOrder=-999
end

local d=ae.NewRoundFrame(12,"Squircle",{
Size=UDim2.new(1,0,0,az),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
ImageColor3=Color3.fromRGB(30,30,30),
Parent=aB,
ClipsDescendants=true
})

if ao.Profile.Banner then
local e=ae.Image(ao.Profile.Banner,"Banner",0,Window.Folder,"ProfileBanner",false)
e.Size=UDim2.new(1,0,1,0)
e.Parent=d
end


if ao.Profile.Badges then
local e=ag("Frame",{
Name="BadgeContainer",
Size=UDim2.new(0,0,0,28),
AutomaticSize=Enum.AutomaticSize.X,
Position=UDim2.new(1,-8,1,-8),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
Parent=d,
ZIndex=5
},{
ag("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
HorizontalAlignment=Enum.HorizontalAlignment.Right,
VerticalAlignment=Enum.VerticalAlignment.Center,
Padding=UDim.new(0,6)
})
})

for f,g in ipairs(ao.Profile.Badges)do
local h=g.Icon or"help-circle"
local j=g.Title~=nil

local l=ag("Frame",{
Name="BadgeWrapper",
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,28),
AutomaticSize=Enum.AutomaticSize.X,
Parent=e,
})

local m=ae.NewRoundFrame(6,"Squircle",{
ImageColor3=Color3.new(0,0,0),
ImageTransparency=0.4,
Size=UDim2.new(1,0,1,0),
Name="BG",
Parent=l
})

local p=ag("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Parent=l
},{
ag("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
VerticalAlignment=Enum.VerticalAlignment.Center,
HorizontalAlignment=Enum.HorizontalAlignment.Center,
Padding=UDim.new(0,4)
}),
ag("UIPadding",{
PaddingLeft=UDim.new(0,j and 8 or 5),
PaddingRight=UDim.new(0,j and 8 or 5),
})
})

local r=ae.Image(h,"BadgeIcon",0,Window.Folder,"Badge",false)
r.Size=UDim2.new(0,16,0,16)
r.BackgroundTransparency=1
r.Parent=p

local u=r:FindFirstChild"ImageLabel"or r:FindFirstChild"VideoFrame"
if u then
u.Size=UDim2.fromScale(1,1)
u.ImageColor3=Color3.new(1,1,1)
u.BackgroundTransparency=1
end

if j then
ag("TextLabel",{
Text=g.Title,
TextSize=12,
FontFace=Font.new(ae.Font,Enum.FontWeight.SemiBold),
TextColor3=Color3.new(1,1,1),
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.XY,
LayoutOrder=2,
Parent=p
})
end

local v=ag("TextButton",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Text="",
ZIndex=10,
Parent=l
})

if g.Callback then
ae.AddSignal(v.MouseButton1Click,function()
g.Callback()
end)
end

ae.AddSignal(v.MouseEnter,function()
ai(m,0.1,{ImageTransparency=0.2}):Play()
end)
ae.AddSignal(v.MouseLeave,function()
ai(m,0.1,{ImageTransparency=0.4}):Play()
end)

if g.Desc then
local x
local z
local A
local B=false

ae.AddSignal(v.MouseEnter,function()
B=true
z=task.spawn(function()
task.wait(0.35)
if B and not x then
x=aj(g.Desc,al.ToolTipParent)
local function updatePosition()
if x then
x.Container.Position=UDim2.new(0,ad.X,0,ad.Y-20)
end
end
updatePosition()
A=ad.Move:Connect(updatePosition)
x:Open()
end
end)
end)

ae.AddSignal(v.MouseLeave,function()
B=false
if z then task.cancel(z)z=nil end
if A then A:Disconnect()A=nil end
if x then x:Close()x=nil end
end)
end
end
end

local e=ag("Frame",{
Size=UDim2.new(0,aA,0,aA),
Position=UDim2.new(0,14,0,az-(aA/2)+5),
BackgroundTransparency=1,
Parent=aB,
ZIndex=2
})

ag("UIStroke",{
Parent=e,
Thickness=4,
ThemeTag={Color="WindowBackground"},
Transparency=0,
ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
})
ag("UICorner",{CornerRadius=UDim.new(1,0),Parent=e})

if ao.Profile.Avatar then
local f=ae.Image(ao.Profile.Avatar,"Avatar",0,Window.Folder,"ProfileAvatar",false)
f.Size=UDim2.fromScale(1,1)
f.BackgroundTransparency=1
f.Parent=e

local g=f:FindFirstChild"ImageLabel"
if g then
g.Size=UDim2.fromScale(1,1)
g.BackgroundTransparency=1
local h=g:FindFirstChildOfClass"UICorner"
if h then h:Destroy()end
ag("UICorner",{CornerRadius=UDim.new(1,0),Parent=g})
end
end

if ao.Profile.Status then
ag("Frame",{
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(1,-3,1,-3),
AnchorPoint=Vector2.new(1,1),
BackgroundColor3=Color3.fromHex"#23a559",
Parent=e,
ZIndex=3
},{
ag("UICorner",{CornerRadius=UDim.new(1,0)}),
ag("UIStroke",{Thickness=3,ThemeTag={Color="WindowBackground"}})
})
end

local f=ag("Frame",{
Name="TextContainer",
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.Y,
Size=UDim2.new(1,-(14+aA+14),0,0),
Position=UDim2.new(0,14+aA+14,0,az+2),
Parent=aB
},{
ag("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,2),
FillDirection=Enum.FillDirection.Vertical,
VerticalAlignment=Enum.VerticalAlignment.Top,
HorizontalAlignment=Enum.HorizontalAlignment.Left
})
})

ag("TextLabel",{
Text=ao.Profile.Title or ao.Title,
TextSize=22,
FontFace=Font.new(ae.Font,Enum.FontWeight.Bold),
ThemeTag={TextColor3="Text"},
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.XY,
TextXAlignment=Enum.TextXAlignment.Left,
Parent=f,
LayoutOrder=1
})

if ao.Profile.Desc then
ag("TextLabel",{
Text=ao.Profile.Desc,
TextSize=13,
FontFace=Font.new(ae.Font,Enum.FontWeight.Regular),
ThemeTag={TextColor3="Text"},
TextTransparency=0.4,
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.XY,
TextXAlignment=Enum.TextXAlignment.Left,
Parent=f,
LayoutOrder=2
})
end
end

ao.UIElements.ContainerFrame.Parent=ao.UIElements.ContainerFrameCanvas

al.Containers[as]=ao.UIElements.ContainerFrameCanvas
al.Tabs[as]=ao

ao.ContainerFrame=ContainerFrameCanvas

ae.AddSignal(ao.UIElements.Main.MouseButton1Click,function()
if not ao.Locked then
al:SelectTab(as)
end
end)

if Window.ScrollBarEnabled then
ak(ao.UIElements.ContainerFrame,ao.UIElements.ContainerFrameCanvas,Window,3)
end

local az
local aA
local aB
local d=false

if ao.Desc and not ap then
ae.AddSignal(ao.UIElements.Main.InputBegan,function()
d=true
aA=task.spawn(function()
task.wait(0.35)
if d and not az then
az=aj(ao.Desc,al.ToolTipParent)
local function updatePosition()
if az then
az.Container.Position=UDim2.new(0,ad.X,0,ad.Y-20)
end
end
updatePosition()
aB=ad.Move:Connect(updatePosition)
az:Open()
end
end)
end)
end

ae.AddSignal(ao.UIElements.Main.MouseEnter,function()
if not ao.Locked then
ai(ao.UIElements.Main.Frame,0.08,{ImageTransparency=.97}):Play()
end
end)
ae.AddSignal(ao.UIElements.Main.InputEnded,function()
if ao.Desc and not ap then
d=false
if aA then task.cancel(aA)aA=nil end
if aB then aB:Disconnect()aB=nil end
if az then az:Close()az=nil end
end

if not ao.Locked then
ai(ao.UIElements.Main.Frame,0.08,{ImageTransparency=1}):Play()
end
end)



function ao.ScrollToTheElement(e,f)
ao.UIElements.ContainerFrame.ScrollingEnabled=false
ai(ao.UIElements.ContainerFrame,.45,
{
CanvasPosition=Vector2.new(
0,

ao.Elements[f].ElementFrame.AbsolutePosition.Y
-ao.UIElements.ContainerFrame.AbsolutePosition.Y
-ao.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
)
},
Enum.EasingStyle.Quint,Enum.EasingDirection.Out
):Play()

task.spawn(function()
task.wait(.48)

if ao.Elements[f].Highlight then
ao.Elements[f]:Highlight()
ao.UIElements.ContainerFrame.ScrollingEnabled=true
end
end)

return ao
end

local e=a.load'U'
e.Load(ao,ao.UIElements.ContainerFrame,e.Elements,Window,ANUI,nil,e,an)

function ao.LockAll(f)
for g,h in next,Window.AllElements do
if h.Tab and h.Tab.Index and h.Tab.Index==ao.Index and h.Lock then
h:Lock()
end
end
end
function ao.UnlockAll(f)
for g,h in next,Window.AllElements do
if h.Tab and h.Tab.Index and h.Tab.Index==ao.Index and h.Unlock then
h:Unlock()
end
end
end
function ao.GetLocked(f)
local g={}
for h,j in next,Window.AllElements do
if j.Tab and j.Tab.Index and j.Tab.Index==ao.Index and j.Locked==true then
table.insert(g,j)
end
end
return g
end
function ao.GetUnlocked(f)
local g={}
for h,j in next,Window.AllElements do
if j.Tab and j.Tab.Index and j.Tab.Index==ao.Index and j.Locked==false then
table.insert(g,j)
end
end
return g
end

function ao.Select(f)
return al:SelectTab(ao.Index)
end

task.spawn(function()
local f=ag("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,-Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
Parent=ao.UIElements.ContainerFrame
},{
ag("UIListLayout",{
Padding=UDim.new(0,8),
SortOrder="LayoutOrder",
VerticalAlignment="Center",
HorizontalAlignment="Center",
FillDirection="Vertical",
}),
ag("ImageLabel",{
Size=UDim2.new(0,48,0,48),
Image=ae.Icon"frown"[1],
ImageRectOffset=ae.Icon"frown"[2].ImageRectPosition,
ImageRectSize=ae.Icon"frown"[2].ImageRectSize,
ThemeTag={
ImageColor3="Icon"
},
BackgroundTransparency=1,
ImageTransparency=.6,
}),
ag("TextLabel",{
AutomaticSize="XY",
Text="This tab is empty",
ThemeTag={
TextColor3="Text"
},
TextSize=18,
TextTransparency=.5,
BackgroundTransparency=1,
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
})
})

local g
g=ae.AddSignal(ao.UIElements.ContainerFrame.ChildAdded,function()
f.Visible=false
g:Disconnect()
end)
end)

return ao
end

function al.OnChange(am,an)
al.OnChangeFunc=an
end

function al.SelectTab(am,an)
if not al.Tabs[an].Locked then
al.SelectedTab=an

for ao,ap in next,al.Tabs do
if not ap.Locked then
ai(ap.UIElements.Main,0.15,{ImageTransparency=1}):Play()
ai(ap.UIElements.Main.Outline,0.15,{ImageTransparency=1}):Play()

if ap.UIElements.Main.Frame:FindFirstChild"TextLabel"then
ai(ap.UIElements.Main.Frame.TextLabel,0.15,{TextTransparency=0.3}):Play()
end

if ap.UIElements.Icon then
ai(ap.UIElements.Icon.ImageLabel,0.15,{ImageTransparency=0.4}):Play()
end
ap.Selected=false
end
end
ai(al.Tabs[an].UIElements.Main,0.15,{ImageTransparency=0.95}):Play()
ai(al.Tabs[an].UIElements.Main.Outline,0.15,{ImageTransparency=0.85}):Play()

if al.Tabs[an].UIElements.Main.Frame:FindFirstChild"TextLabel"then
ai(al.Tabs[an].UIElements.Main.Frame.TextLabel,0.15,{TextTransparency=0}):Play()
end

if al.Tabs[an].UIElements.Icon then
ai(al.Tabs[an].UIElements.Icon.ImageLabel,0.15,{ImageTransparency=0.1}):Play()
end
al.Tabs[an].Selected=true

task.spawn(function()
for ao,ap in next,al.Containers do
ap.AnchorPoint=Vector2.new(0,0.05)
ap.Visible=false
end
al.Containers[an].Visible=true
ai(al.Containers[an],0.15,{AnchorPoint=Vector2.new(0,0)},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()
end)

al.OnChangeFunc(an)
end
end

return al end function a.W()
local aa={}


local ad=a.load'b'
local ae=ad.New
local ag=ad.Tween

local ai=a.load'V'

function aa.New(aj,ak,al,am,an)
local ao={
Title=aj.Title or"Section",
Icon=aj.Icon,
IconThemed=aj.IconThemed,
Opened=aj.Opened or false,

HeaderSize=42,
IconSize=18,

Expandable=false,
}

local ap
if ao.Icon then
ap=ad.Image(
ao.Icon,
ao.Icon,
0,
al,
"Section",
true,
ao.IconThemed
)

ap.Size=UDim2.new(0,ao.IconSize,0,ao.IconSize)
ap.ImageLabel.ImageTransparency=.25
end

local aq=ae("Frame",{
Size=UDim2.new(0,ao.IconSize,0,ao.IconSize),
BackgroundTransparency=1,
Visible=false
},{
ae("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=ad.Icon"chevron-down"[1],
ImageRectSize=ad.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=ad.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.7,
})
})

local ar=ae("Frame",{
Size=UDim2.new(1,0,0,ao.HeaderSize),
BackgroundTransparency=1,
Parent=ak,
ClipsDescendants=true,
},{
ae("TextButton",{
Size=UDim2.new(1,0,0,ao.HeaderSize),
BackgroundTransparency=1,
Text="",
},{
ap,
ae("TextLabel",{
Text=ao.Title,
TextXAlignment="Left",
Size=UDim2.new(
1,
ap and(-ao.IconSize-10)*2
or(-ao.IconSize-10),

1,
0
),
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ad.Font,Enum.FontWeight.SemiBold),
TextSize=14,
BackgroundTransparency=1,
TextTransparency=.7,

TextWrapped=true
}),
ae("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,10)
}),
aq,
ae("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
})
}),
ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=true,
Position=UDim2.new(0,0,0,ao.HeaderSize)
},{
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,an.Gap),
VerticalAlignment="Bottom",
}),
})
})


function ao.Tab(as,at)
if not ao.Expandable then
ao.Expandable=true
aq.Visible=true
end
at.Parent=ar.Content
return ai.New(at,am)
end

function ao.Open(as)
if ao.Expandable then
ao.Opened=true
ag(ar,0.33,{
Size=UDim2.new(1,0,0,ao.HeaderSize+(ar.Content.AbsoluteSize.Y/am))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ag(aq.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function ao.Close(as)
if ao.Expandable then
ao.Opened=false
ag(ar,0.26,{
Size=UDim2.new(1,0,0,ao.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ag(aq.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

ad.AddSignal(ar.TextButton.MouseButton1Click,function()
if ao.Expandable then
if ao.Opened then
ao:Close()
else
ao:Open()
end
end
end)

ad.AddSignal(ar.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if ao.Opened then
ao:Open()
end
end)

if ao.Opened then
task.spawn(function()
task.wait()
ao:Open()
end)
end



return ao
end


return aa end function a.X()
return{
Tab="table-of-contents",
Paragraph="type",
Button="square-mouse-pointer",
Toggle="toggle-right",
Slider="sliders-horizontal",
Keybind="command",
Input="text-cursor-input",
Dropdown="chevrons-up-down",
Code="terminal",
Colorpicker="palette",
}end function a.Y()
local aa=(cloneref or clonereference or function(aa)return aa end)

aa(game:GetService"UserInputService")

local ad={
Margin=8,
Padding=9,
}


local ae=a.load'b'
local ag=ae.New
local ai=ae.Tween


function ad.new(aj,ak,al)
local am={
IconSize=18,
Padding=14,
Radius=22,
Width=400,
MaxHeight=380,

Icons=a.load'X'
}


local an=ag("TextBox",{
Text="",
PlaceholderText="Search...",
ThemeTag={
PlaceholderColor3="Placeholder",
TextColor3="Text",
},
Size=UDim2.new(
1,
-((am.IconSize*2)+(am.Padding*2)),
0,
0
),
AutomaticSize="Y",
ClipsDescendants=true,
ClearTextOnFocus=false,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Regular),
TextSize=18,
})

local ao=ag("ImageLabel",{
Image=ae.Icon"x"[1],
ImageRectSize=ae.Icon"x"[2].ImageRectSize,
ImageRectOffset=ae.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize)
},{
ag("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
Active=true,
ZIndex=999999999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
})
})

local ap=ag("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ElasticBehavior="Never",
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
Visible=false
},{
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
ag("UIPadding",{
PaddingTop=UDim.new(0,am.Padding),
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
PaddingBottom=UDim.new(0,am.Padding),
})
})

local aq=ae.NewRoundFrame(am.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Background",
},
ImageTransparency=0,
},{
ae.NewRoundFrame(am.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,

Visible=false,
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.98,
Name="Frame",
},{
ag("Frame",{
Size=UDim2.new(1,0,0,46),
BackgroundTransparency=1,
},{








ag("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ag("ImageLabel",{
Image=ae.Icon"search"[1],
ImageRectSize=ae.Icon"search"[2].ImageRectSize,
ImageRectOffset=ae.Icon"search"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize)
}),
an,
ao,
ag("UIListLayout",{
Padding=UDim.new(0,am.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ag("UIPadding",{
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
})
})
}),
ag("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Results",
},{
ag("Frame",{
Size=UDim2.new(1,0,0,1),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=.9,
Visible=false,
}),
ap,
ag("UISizeConstraint",{
MaxSize=Vector2.new(am.Width,am.MaxHeight),
}),
}),
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
})
})

local ar=ag("Frame",{
Size=UDim2.new(0,am.Width,0,0),
AutomaticSize="Y",
Parent=ak,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Visible=false,

ZIndex=99999999,
},{
ag("UIScale",{
Scale=.9,
}),
aq,
ae.NewRoundFrame(am.Radius,"SquircleOutline2",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Outline",
},
ImageTransparency=1,
},{
ag("UIGradient",{
Rotation=45,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.55),
NumberSequenceKeypoint.new(0.5,0.8),
NumberSequenceKeypoint.new(1,0.6)
}
})
})
})

local function CreateSearchTab(as,at,au,av,aw,ax)
local ay=ag("TextButton",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=av or nil
},{
ae.NewRoundFrame(am.Radius-11,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),

ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Main"
},{
ae.NewRoundFrame(am.Radius-11,"SquircleOutline2",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Outline",
},
ImageTransparency=1,
Name="Outline",
},{
ag("UIGradient",{
Rotation=65,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.55),
NumberSequenceKeypoint.new(0.5,0.8),
NumberSequenceKeypoint.new(1,0.6)
}
}),
ag("UIPadding",{
PaddingTop=UDim.new(0,am.Padding-2),
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
PaddingBottom=UDim.new(0,am.Padding-2),
}),
ag("ImageLabel",{
Image=ae.Icon(au)[1],
ImageRectSize=ae.Icon(au)[2].ImageRectSize,
ImageRectOffset=ae.Icon(au)[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize)
}),
ag("Frame",{
Size=UDim2.new(1,-am.IconSize-am.Padding,0,0),
BackgroundTransparency=1,
},{
ag("TextLabel",{
Text=as,
ThemeTag={
TextColor3="Text",
},
TextSize=17,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Title"
}),
ag("TextLabel",{
Text=at or"",
Visible=at and true or false,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=.3,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Desc"
})or nil,
ag("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
})
}),
ag("UIListLayout",{
Padding=UDim.new(0,am.Padding),
FillDirection="Horizontal",
})
}),
},true),
ag("Frame",{
Name="ParentContainer",
Size=UDim2.new(1,-am.Padding,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=aw,

},{
ae.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,2,1,0),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=.9,
}),
ag("Frame",{
Size=UDim2.new(1,-am.Padding-2,0,0),
Position=UDim2.new(0,am.Padding+2,0,0),
BackgroundTransparency=1,
},{
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
}),
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
HorizontalAlignment="Right"
})
})



ay.Main.Size=UDim2.new(
1,
0,
0,
ay.Main.Outline.Frame.Desc.Visible and(((am.Padding-2)*2)+ay.Main.Outline.Frame.Title.TextBounds.Y+6+ay.Main.Outline.Frame.Desc.TextBounds.Y)
or(((am.Padding-2)*2)+ay.Main.Outline.Frame.Title.TextBounds.Y)
)

ae.AddSignal(ay.Main.MouseEnter,function()
ai(ay.Main,.04,{ImageTransparency=.95}):Play()
ai(ay.Main.Outline,.04,{ImageTransparency=.7}):Play()
end)
ae.AddSignal(ay.Main.InputEnded,function()
ai(ay.Main,.08,{ImageTransparency=1}):Play()
ai(ay.Main.Outline,.08,{ImageTransparency=1}):Play()
end)
ae.AddSignal(ay.Main.MouseButton1Click,function()
if ax then
ax()
end
end)

return ay
end

local function ContainsText(as,at)
if not at or at==""then
return false
end

if not as or as==""then
return false
end

local au=string.lower(as)
local av=string.lower(at)

return string.find(au,av,1,true)~=nil
end

local function Search(as)
if not as or as==""then
return{}
end

local at={}
for au,av in next,aj.Tabs do
local aw=ContainsText(av.Title or"",as)
local ax={}

for ay,az in next,av.Elements do
if az.__type~="Section"then
local aA=ContainsText(az.Title or"",as)
local aB=ContainsText(az.Desc or"",as)

if aA or aB then
ax[ay]={
Title=az.Title,
Desc=az.Desc,
Original=az,
__type=az.__type,
Index=ay,
}
end
end
end

if aw or next(ax)~=nil then
at[au]={
Tab=av,
Title=av.Title,
Icon=av.Icon,
Elements=ax,
}
end
end
return at
end

function am.Search(as,at)
at=at or""

local au=Search(at)

ap.Visible=true
aq.Frame.Results.Frame.Visible=true
for av,aw in next,ap:GetChildren()do
if aw.ClassName~="UIListLayout"and aw.ClassName~="UIPadding"then
aw:Destroy()
end
end

if au and next(au)~=nil then
for av,aw in next,au do
local ax=am.Icons.Tab
local ay=CreateSearchTab(aw.Title,nil,ax,ap,true,function()
am:Close()
aj:SelectTab(av)
end)
if aw.Elements and next(aw.Elements)~=nil then
for az,aA in next,aw.Elements do
local aB=am.Icons[aA.__type]
CreateSearchTab(aA.Title,aA.Desc,aB,ay:FindFirstChild"ParentContainer"and ay.ParentContainer.Frame or nil,false,function()
am:Close()
aj:SelectTab(av)
if aw.Tab.ScrollToTheElement then

aw.Tab:ScrollToTheElement(aA.Index)
end

end)

end
end
end
elseif at~=""then
ag("TextLabel",{
Size=UDim2.new(1,0,0,70),
BackgroundTransparency=1,
Text="No results found",
TextSize=16,
ThemeTag={
TextColor3="Text",
},
TextTransparency=.2,
BackgroundTransparency=1,
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Parent=ap,
Name="NotFound",
})
else
ap.Visible=false
aq.Frame.Results.Frame.Visible=false
end
end

ae.AddSignal(an:GetPropertyChangedSignal"Text",function()
am:Search(an.Text)
end)

ae.AddSignal(ap.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()

ai(ap,.06,{Size=UDim2.new(
1,
0,
0,
math.clamp(ap.UIListLayout.AbsoluteContentSize.Y+(am.Padding*2),0,am.MaxHeight)
)},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()






end)

function am.Open(as)
task.spawn(function()
aq.Frame.Visible=true
ar.Visible=true
ai(ar.UIScale,.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

function am.Close(as)
task.spawn(function()
al()
aq.Frame.Visible=false
ai(ar.UIScale,.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(.12)
ar.Visible=false
end)
end

ae.AddSignal(ao.TextButton.MouseButton1Click,function()
am:Close()
end)

am:Open()

return am
end

return ad end function a.Z()
local aa=(cloneref or clonereference or function(aa)return aa end)

local ad=aa(game:GetService"UserInputService")
aa(game:GetService"RunService")

local ae=workspace.CurrentCamera

local ag=a.load'q'

local ai=a.load'b'
local aj=ai.New
local ak=ai.Tween


local al=a.load't'.New
local am=a.load'j'.New
local an=a.load'u'.New
local ao=a.load'v'

local ap=a.load'w'



return function(aq)
local ar={
Title=aq.Title or"UI Library",
Author=aq.Author,
Icon=aq.Icon,
IconSize=aq.IconSize or 22,
IconThemed=aq.IconThemed,
Folder=aq.Folder,
Resizable=aq.Resizable~=false,
Background=aq.Background,
BackgroundImageTransparency=aq.BackgroundImageTransparency or 0,
ShadowTransparency=aq.ShadowTransparency or 0.7,
User=aq.User or{},

Size=aq.Size,

MinSize=aq.MinSize or Vector2.new(850,560),
MaxSize=aq.MaxSize or Vector2.new(1050,560),

TopBarButtonIconSize=aq.TopBarButtonIconSize or 16,

ToggleKey=aq.ToggleKey,
ElementsRadius=aq.ElementsRadius,
Radius=aq.Radius or 16,
Transparent=aq.Transparent or false,
HideSearchBar=aq.HideSearchBar~=false,
ScrollBarEnabled=aq.ScrollBarEnabled or false,
SideBarWidth=aq.SideBarWidth or 200,
Acrylic=aq.Acrylic or false,
NewElements=aq.NewElements or false,
IgnoreAlerts=aq.IgnoreAlerts or false,
HidePanelBackground=aq.HidePanelBackground or false,
AutoScale=aq.AutoScale~=false,
OpenButton=aq.OpenButton,

Position=UDim2.new(0.5,0,0.5,0),
UICorner=nil,
UIPadding=14,
UIElements={},
CanDropdown=true,
Closed=false,
Parent=aq.Parent,
Destroyed=false,
IsFullscreen=false,
CanResize=aq.Resizable~=false,
IsOpenButtonEnabled=true,

CurrentConfig=nil,
ConfigManager=nil,
AcrylicPaint=nil,
CurrentTab=nil,
TabModule=nil,

OnOpenCallback=nil,
OnCloseCallback=nil,
OnDestroyCallback=nil,

IsPC=false,

Gap=5,

TopBarButtons={},
AllElements={},

ElementConfig={},

PendingFlags={},

IsToggleDragging=false,
}

ar.UICorner=ar.Radius

ar.ElementConfig={
UIPadding=(ar.NewElements and 10 or 13),
UICorner=ar.ElementsRadius or(ar.NewElements and 23 or 12),
}

local as=ar.Size or UDim2.new(0,580,0,460)
ar.Size=UDim2.new(
as.X.Scale,
math.clamp(as.X.Offset,ar.MinSize.X,ar.MaxSize.X),
as.Y.Scale,
math.clamp(as.Y.Offset,ar.MinSize.Y,ar.MaxSize.Y)
)

if ar.Folder then
if not isfolder("ANUI/"..ar.Folder)then
makefolder("ANUI/"..ar.Folder)
end
if not isfolder("ANUI/"..ar.Folder.."/assets")then
makefolder("ANUI/"..ar.Folder.."/assets")
end
if not isfolder(ar.Folder)then
makefolder(ar.Folder)
end
if not isfolder(ar.Folder.."/assets")then
makefolder(ar.Folder.."/assets")
end
end

local at=aj("UICorner",{
CornerRadius=UDim.new(0,ar.UICorner)
})

if ar.Folder then
ar.ConfigManager=ap:Init(ar)
end


if ar.Acrylic then local
au=ag.AcrylicPaint{UseAcrylic=ar.Acrylic}

ar.AcrylicPaint=au
end

local au=aj("Frame",{
Size=UDim2.new(0,32,0,32),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(.5,.5),
BackgroundTransparency=1,
ZIndex=99,
Active=true
},{
aj("ImageLabel",{
Size=UDim2.new(0,96,0,96),
BackgroundTransparency=1,
Image="rbxassetid://120997033468887",
Position=UDim2.new(0.5,-16,0.5,-16),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
})
})
local av=ai.NewRoundFrame(ar.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=98,
Active=false,
},{
aj("ImageLabel",{
Size=UDim2.new(0,70,0,70),
Image=ai.Icon"expand"[1],
ImageRectOffset=ai.Icon"expand"[2].ImageRectPosition,
ImageRectSize=ai.Icon"expand"[2].ImageRectSize,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})

local aw=ai.NewRoundFrame(ar.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=999,
Active=false,
})










ar.UIElements.SideBar=aj("ScrollingFrame",{
Size=UDim2.new(
1,
ar.ScrollBarEnabled and-3-(ar.UIPadding/2)or 0,
1,
not ar.HideSearchBar and-45 or 0
),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ClipsDescendants=true,
VerticalScrollBarPosition="Left",
},{
aj("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Frame",
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,ar.UIPadding/2),


PaddingBottom=UDim.new(0,ar.UIPadding/2),
}),
aj("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,ar.Gap)
})
}),
aj("UIPadding",{

PaddingLeft=UDim.new(0,ar.UIPadding/2),
PaddingRight=UDim.new(0,ar.UIPadding/2),

}),

})

ar.UIElements.SideBarContainer=aj("Frame",{
Size=UDim2.new(0,ar.SideBarWidth,1,ar.User.Enabled and-94-(ar.UIPadding*2)or-52),
Position=UDim2.new(0,0,0,52),
BackgroundTransparency=1,
Visible=true,
},{
ai.NewRoundFrame(ar.UICorner-(ar.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ZIndex=1,
ImageTransparency=1,
Name="SidebarBackdrop",
}),
aj("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(
1,
0,
1,
not ar.HideSearchBar and-45-ar.UIPadding/2 or 0
),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
}),
ar.UIElements.SideBar,
})

if ar.ScrollBarEnabled then
an(ar.UIElements.SideBar,ar.UIElements.SideBarContainer.Content,ar,3)
end


ar.UIElements.MainBar=aj("Frame",{
Size=UDim2.new(1,-ar.UIElements.SideBarContainer.AbsoluteSize.X,1,-52),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
},{
ai.NewRoundFrame(ar.UICorner-(ar.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ZIndex=3,
ImageTransparency=.95,
Name="Background",
Visible=not ar.HidePanelBackground
}),
aj("UIPadding",{
PaddingTop=UDim.new(0,ar.UIPadding/2),
PaddingLeft=UDim.new(0,ar.UIPadding/2),
PaddingRight=UDim.new(0,ar.UIPadding/2),
PaddingBottom=UDim.new(0,ar.UIPadding/2),
})
})

local function getScaledSidebarWidth()
return ar.UIElements.SideBarContainer.AbsoluteSize.X/(aq.ANUI.UIScale or 1)
end

ar.UIElements.MainBar.Size=UDim2.new(1,-ar.SideBarWidth,1,-52)

ai.AddSignal(ar.UIElements.SideBarContainer:GetPropertyChangedSignal"AbsoluteSize",function()
ar.UIElements.MainBar.Size=UDim2.new(1,-getScaledSidebarWidth(),1,-52)
end)

local ax=aj("ImageLabel",{
Image="rbxassetid://8992230677",
ThemeTag={
ImageColor3="WindowShadow",

},
ImageTransparency=1,
Size=UDim2.new(1,120,1,116),
Position=UDim2.new(0,-60,0,-58),
ScaleType="Slice",
SliceCenter=Rect.new(99,99,99,99),
BackgroundTransparency=1,
ZIndex=-999999999999999,
Name="Blur",
})



if ad.TouchEnabled and not ad.KeyboardEnabled then
ar.IsPC=false
elseif ad.KeyboardEnabled then
ar.IsPC=true
else
ar.IsPC=nil
end










local ay
if ar.User then
local function GetUserThumb()local
az=aa(game:GetService"Players"):GetUserThumbnailAsync(
ar.User.Anonymous and 1 or game.Players.LocalPlayer.UserId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size420x420
)
return az
end


ay=aj("TextButton",{
Size=UDim2.new(0,
(ar.UIElements.SideBarContainer.AbsoluteSize.X)-(ar.UIPadding/2),
0,
42+(ar.UIPadding)
),
Position=UDim2.new(0,ar.UIPadding/2,1,-(ar.UIPadding/2)),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
Visible=ar.User.Enabled or false,
},{
ai.NewRoundFrame(ar.UICorner-(ar.UIPadding/2),"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline"
},{
aj("UIGradient",{
Rotation=78,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
ai.NewRoundFrame(ar.UICorner-(ar.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="UserIcon",
},{
aj("ImageLabel",{
Image=GetUserThumb(),
BackgroundTransparency=1,
Size=UDim2.new(0,42,0,42),
ThemeTag={
BackgroundColor3="Text",
},
BackgroundTransparency=.93,
},{
aj("UICorner",{
CornerRadius=UDim.new(1,0)
})
}),
aj("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
},{
aj("TextLabel",{
Text=ar.User.Anonymous and"Anonymous"or game.Players.LocalPlayer.DisplayName,
TextSize=17,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ai.Font,Enum.FontWeight.SemiBold),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="DisplayName"
}),
aj("TextLabel",{
Text=ar.User.Anonymous and"anonymous"or game.Players.LocalPlayer.Name,
TextSize=15,
TextTransparency=.6,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ai.Font,Enum.FontWeight.Medium),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="UserName"
}),
aj("UIListLayout",{
Padding=UDim.new(0,4),
HorizontalAlignment="Left",
})
}),
aj("UIListLayout",{
Padding=UDim.new(0,ar.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aj("UIPadding",{
PaddingLeft=UDim.new(0,ar.UIPadding/2),
PaddingRight=UDim.new(0,ar.UIPadding/2),
})
})
})


function ar.User.Enable(az)
ar.User.Enabled=true
ak(ar.UIElements.SideBarContainer,.25,{Size=UDim2.new(0,ar.SideBarWidth,1,-94-(ar.UIPadding*2))},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ay.Visible=true
end
function ar.User.Disable(az)
ar.User.Enabled=false
ak(ar.UIElements.SideBarContainer,.25,{Size=UDim2.new(0,ar.SideBarWidth,1,-52)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ay.Visible=false
end
function ar.User.SetAnonymous(az,aA)
if aA~=false then aA=true end
ar.User.Anonymous=aA
ay.UserIcon.ImageLabel.Image=GetUserThumb()
ay.UserIcon.Frame.DisplayName.Text=aA and"Anonymous"or game.Players.LocalPlayer.DisplayName
ay.UserIcon.Frame.UserName.Text=aA and"anonymous"or game.Players.LocalPlayer.Name
end

if ar.User.Enabled then
ar.User:Enable()
else
ar.User:Disable()
end

if ar.User.Callback then
ai.AddSignal(ay.MouseButton1Click,function()
ar.User.Callback()
end)
ai.AddSignal(ay.MouseEnter,function()
ak(ay.UserIcon,0.04,{ImageTransparency=.95}):Play()
ak(ay.Outline,0.04,{ImageTransparency=.85}):Play()
end)
ai.AddSignal(ay.InputEnded,function()
ak(ay.UserIcon,0.04,{ImageTransparency=1}):Play()
ak(ay.Outline,0.04,{ImageTransparency=1}):Play()
end)
end
end

local az
local aA


local aB=false
local d

local e=typeof(ar.Background)=="string"and string.match(ar.Background,"^video:(.+)")or nil
local f=typeof(ar.Background)=="string"and not e and string.match(ar.Background,"^https?://.+")or nil

local function GetImageExtension(g)
local h=g:match"%.(%w+)$"or g:match"%.(%w+)%?"
if h then
h=h:lower()
if h=="jpg"or h=="jpeg"or h=="png"or h=="webp"then
return"."..h
end
end
return".png"
end

if typeof(ar.Background)=="string"and e then
aB=true

if string.find(e,"http")then
local g=ar.Folder.."/assets/."..ai.SanitizeFilename(e)..".webm"
if not isfile(g)then
local h,j=pcall(function()
local h=ai.Request{Url=e,Method="GET",Headers={["User-Agent"]="Roblox/Exploit"}}
writefile(g,h.Body)
end)
if not h then
warn("[ ANUI.Window.Background ] Failed to download video: "..tostring(j))
return
end
end

local h,j=pcall(function()
return getcustomasset(g)
end)
if not h then
warn("[ ANUI.Window.Background ] Failed to load custom asset: "..tostring(j))
return
end
warn"[ ANUI.Window.Background ] VideoFrame may not work with custom video"
e=j
end

d=aj("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=e,
Looped=true,
Volume=0,
},{
aj("UICorner",{
CornerRadius=UDim.new(0,ar.UICorner)
}),
})
d:Play()

elseif f then
local g=ar.Folder.."/assets/."..ai.SanitizeFilename(f)..GetImageExtension(f)
if not isfile(g)then
local h,j=pcall(function()
local h=ai.Request{Url=f,Method="GET",Headers={["User-Agent"]="Roblox/Exploit"}}
writefile(g,h.Body)
end)
if not h then
warn("[ Window.Background ] Failed to download image: "..tostring(j))
return
end
end

local h,j=pcall(function()
return getcustomasset(g)
end)
if not h then
warn("[ Window.Background ] Failed to load custom asset: "..tostring(j))
return
end

d=aj("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=j,
ImageTransparency=0,
ScaleType="Crop",
},{
aj("UICorner",{
CornerRadius=UDim.new(0,ar.UICorner)
}),
})

elseif ar.Background then
d=aj("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=typeof(ar.Background)=="string"and ar.Background or"",
ImageTransparency=1,
ScaleType="Crop",
},{
aj("UICorner",{
CornerRadius=UDim.new(0,ar.UICorner)
}),
})
end


local g=ai.NewRoundFrame(99,"Squircle",{
ImageTransparency=.8,
ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(0,0,0,4),
Position=UDim2.new(0.5,0,1,4),
AnchorPoint=Vector2.new(0.5,0),
},{
aj("TextButton",{
Size=UDim2.new(1,12,1,12),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
ZIndex=99,
Name="Frame",
})
})

function createAuthor(h)
return aj("TextLabel",{
Text=h,
FontFace=Font.new(ai.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
TextTransparency=0.35,
AutomaticSize="XY",
Parent=ar.UIElements.Main and ar.UIElements.Main.Main.Topbar.Left.Title,
TextXAlignment="Left",
TextSize=13,
LayoutOrder=2,
ThemeTag={
TextColor3="WindowTopbarAuthor"
},
Name="Author",
})
end

local h
local j

if ar.Author then
h=createAuthor(ar.Author)
end


local l=aj("TextLabel",{
Text=ar.Title,
FontFace=Font.new(ai.Font,Enum.FontWeight.SemiBold),
BackgroundTransparency=1,
AutomaticSize="XY",
Name="Title",
TextXAlignment="Left",
TextSize=16,
ThemeTag={
TextColor3="WindowTopbarTitle"
}
})

ar.UIElements.Main=aj("Frame",{
Size=ar.Size,
Position=ar.Position,
BackgroundTransparency=1,
Parent=aq.Parent,
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
},{
aq.ANUI.UIScaleObj,
ar.AcrylicPaint and ar.AcrylicPaint.Frame or nil,
ax,
ai.NewRoundFrame(ar.UICorner,"Squircle",{
ImageTransparency=1,
Size=UDim2.new(1,0,1,-240),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Background",
ThemeTag={
ImageColor3="WindowBackground"
},

},{
d,
g,
au,



}),
UIStroke,
at,
av,
aw,
aj("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Main",

Visible=false,
ZIndex=97,
},{
aj("UICorner",{
CornerRadius=UDim.new(0,ar.UICorner)
}),
ar.UIElements.SideBarContainer,
ar.UIElements.MainBar,

ay,

aA,
aj("Frame",{
Size=UDim2.new(1,0,0,52),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(50,50,50),
Name="Topbar"
},{
az,






aj("Frame",{
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
Name="Left"
},{
aj("UIListLayout",{
Padding=UDim.new(0,ar.UIPadding+4),
SortOrder="LayoutOrder",
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aj("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Name="Title",
Size=UDim2.new(0,0,1,0),
LayoutOrder=2,
},{
aj("UIListLayout",{
Padding=UDim.new(0,0),
SortOrder="LayoutOrder",
FillDirection="Vertical",
VerticalAlignment="Center",
}),
l,
h,
}),
aj("UIPadding",{
PaddingLeft=UDim.new(0,4)
})
}),
aj("ScrollingFrame",{
Name="Center",
BackgroundTransparency=1,
AutomaticSize="Y",
ScrollBarThickness=0,
ScrollingDirection="X",
AutomaticCanvasSize="X",
CanvasSize=UDim2.new(0,0,0,0),
Size=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,0,0.5,0),
Visible=false,
},{
aj("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
Padding=UDim.new(0,ar.UIPadding/2)
})
}),
aj("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
Name="Right",
},{
aj("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
SortOrder="LayoutOrder",
}),

}),
aj("UIPadding",{
PaddingTop=UDim.new(0,ar.UIPadding),
PaddingLeft=UDim.new(0,ar.UIPadding),
PaddingRight=UDim.new(0,8),
PaddingBottom=UDim.new(0,ar.UIPadding),
})
})
})
})

ai.AddSignal(ar.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal"AbsoluteSize",function()
local m=0
local p=ar.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X/aq.ANUI.UIScale
if l and h then
m=math.max(l.TextBounds.X/aq.ANUI.UIScale,h.TextBounds.X/aq.ANUI.UIScale)
else
m=l.TextBounds.X/aq.ANUI.UIScale
end
if j then
m=m+(ar.IconSize/aq.ANUI.UIScale)+(ar.UIPadding/aq.ANUI.UIScale)+(4/aq.ANUI.UIScale)
end
ar.UIElements.Main.Main.Topbar.Center.Position=UDim2.new(
0,
m+(ar.UIPadding/aq.ANUI.UIScale),
0.5,
0
)
ar.UIElements.Main.Main.Topbar.Center.Size=UDim2.new(
1,
-m-p-((ar.UIPadding*2)/aq.ANUI.UIScale),
1,
0
)
end)

function ar.CreateTopbarButton(m,p,r,u,v,x)
local z=ai.Image(
r,
r,
0,
ar.Folder,
"WindowTopbarIcon",
true,
x,
"WindowTopbarButtonIcon"
)
z.Size=UDim2.new(0,ar.TopBarButtonIconSize,0,ar.TopBarButtonIconSize)
z.AnchorPoint=Vector2.new(0.5,0.5)
z.Position=UDim2.new(0.5,0,0.5,0)

local A=ai.NewRoundFrame(ar.UICorner-(ar.UIPadding/2),"Squircle",{
Size=UDim2.new(0,36,0,36),
LayoutOrder=v or 999,
Parent=ar.UIElements.Main.Main.Topbar.Right,

ZIndex=9999,
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=1
},{
ai.NewRoundFrame(ar.UICorner-(ar.UIPadding/2),"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline"
},{
aj("UIGradient",{
Rotation=45,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
}),
}),
z
},true)



ar.TopBarButtons[100-v]={
Name=p,
Object=A
}

ai.AddSignal(A.MouseButton1Click,function()
u()
end)
ai.AddSignal(A.MouseEnter,function()
ak(A,.15,{ImageTransparency=.93}):Play()
ak(A.Outline,.15,{ImageTransparency=.75}):Play()

end)
ai.AddSignal(A.MouseLeave,function()
ak(A,.1,{ImageTransparency=1}):Play()
ak(A.Outline,.1,{ImageTransparency=1}):Play()

end)

return A
end



local m=ai.Drag(
ar.UIElements.Main,
{ar.UIElements.Main.Main.Topbar,g.Frame},
function(m,p)
if not ar.Closed then
if m and p==g.Frame then
ak(g,.1,{ImageTransparency=.35}):Play()
else
ak(g,.2,{ImageTransparency=.8}):Play()
end
ar.Position=ar.UIElements.Main.Position
ar.Dragging=m
end
end
)

if not aB and ar.Background and typeof(ar.Background)=="table"then

local p=aj"UIGradient"
for r,u in next,ar.Background do
p[r]=u
end

ar.UIElements.BackgroundGradient=ai.NewRoundFrame(ar.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
Parent=ar.UIElements.Main.Background,
ImageTransparency=ar.Transparent and aq.ANUI.TransparencyValue or 0
},{
p
})
end














ar.OpenButtonMain=a.load'x'.New(ar)


task.spawn(function()
if ar.Icon then

local p=aj("Frame",{
Size=UDim2.new(0,22,0,22),
BackgroundTransparency=1,
Parent=ar.UIElements.Main.Main.Topbar.Left,
})

j=ai.Image(
ar.Icon,
ar.Title,
0,
ar.Folder,
"Window",
true,
ar.IconThemed,
"WindowTopbarIcon"
)
j.Parent=p
j.Size=UDim2.new(0,ar.IconSize,0,ar.IconSize)
j.Position=UDim2.new(0.5,0,0.5,0)
j.AnchorPoint=Vector2.new(0.5,0.5)

ar.OpenButtonMain:SetIcon(ar.Icon)











else
ar.OpenButtonMain:SetIcon(ar.Icon)

end
end)

function ar.SetToggleKey(p,r)
ar.ToggleKey=r
end

function ar.SetTitle(p,r)
ar.Title=r
l.Text=r
end

function ar.SetAuthor(p,r)
ar.Author=r
if not h then
h=createAuthor(ar.Author)
end

h.Text=r
end

function ar.SetBackgroundImage(p,r)
ar.UIElements.Main.Background.ImageLabel.Image=r
end
function ar.SetBackgroundImageTransparency(p,r)
if d and d:IsA"ImageLabel"then
d.ImageTransparency=math.floor(r*10+0.5)/10
end
ar.BackgroundImageTransparency=math.floor(r*10+0.5)/10
end

function ar.SetBackgroundTransparency(p,r)
local u=math.floor(tonumber(r)*10+0.5)/10
aq.ANUI.TransparencyValue=u
ar:ToggleTransparency(u>0)
end




ar.SidebarCollapsed=false

local function updateSidebarToggleIcon()
local p=ar.UIElements.SidebarToggleButtonIcon
if p and p:FindFirstChild"ImageLabel"then
local r=ar.SidebarCollapsed and"chevrons-right"or"chevrons-left"
local u=ai.Icon(r)
if u and u[1]and u[2]then
p.ImageLabel.Image=u[1]
p.ImageLabel.ImageRectOffset=u[2].ImageRectPosition
p.ImageLabel.ImageRectSize=u[2].ImageRectSize
end
end
end

function ar.CollapseSidebar(p)
if ar.SidebarCollapsed then return end
ar.SidebarCollapsed=true
local r=ar.User.Enabled and-94-(ar.UIPadding*2)or-52
ak(ar.UIElements.SideBarContainer,.32,{Size=UDim2.new(0,0,1,r)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ak(ar.UIElements.MainBar,.32,{Size=UDim2.new(1,0,1,-52)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ak(ar.UIElements.SideBarContainer.SidebarBackdrop,.28,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
task.delay(.32,function()
ak(ar.UIElements.SideBarContainer,.16,{Size=UDim2.new(0,8,1,r)},Enum.EasingStyle.Sine,Enum.EasingDirection.Out):Play()
ak(ar.UIElements.MainBar,.16,{Size=UDim2.new(1,-(8/(aq.ANUI.UIScale or 1)),1,-52)},Enum.EasingStyle.Sine,Enum.EasingDirection.Out):Play()
end)
task.delay(.48,function()
ak(ar.UIElements.SideBarContainer,.16,{Size=UDim2.new(0,0,1,r)},Enum.EasingStyle.Sine,Enum.EasingDirection.In):Play()
ak(ar.UIElements.MainBar,.16,{Size=UDim2.new(1,0,1,-52)},Enum.EasingStyle.Sine,Enum.EasingDirection.In):Play()
end)
updateSidebarToggleIcon()
end

function ar.ExpandSidebar(p)
if not ar.SidebarCollapsed then return end
ar.SidebarCollapsed=false
local r=ar.User.Enabled and-94-(ar.UIPadding*2)or-52
ak(ar.UIElements.SideBarContainer,.36,{Size=UDim2.new(0,ar.SideBarWidth,1,r)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ak(ar.UIElements.MainBar,.36,{Size=UDim2.new(1,-ar.SideBarWidth,1,-52)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ak(ar.UIElements.SideBarContainer.SidebarBackdrop,.30,{ImageTransparency=.95},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
task.delay(.36,function()
ak(ar.UIElements.SideBarContainer,.18,{Size=UDim2.new(0,ar.SideBarWidth+10,1,r)},Enum.EasingStyle.Sine,Enum.EasingDirection.Out):Play()
ak(ar.UIElements.MainBar,.18,{Size=UDim2.new(1,-(ar.SideBarWidth+10),1,-52)},Enum.EasingStyle.Sine,Enum.EasingDirection.Out):Play()
end)
task.delay(.54,function()
ak(ar.UIElements.SideBarContainer,.18,{Size=UDim2.new(0,ar.SideBarWidth,1,r)},Enum.EasingStyle.Sine,Enum.EasingDirection.In):Play()
ak(ar.UIElements.MainBar,.18,{Size=UDim2.new(1,-ar.SideBarWidth,1,-52)},Enum.EasingStyle.Sine,Enum.EasingDirection.In):Play()
end)
updateSidebarToggleIcon()
end

function ar.ToggleSidebar(p,r)
if r==nil then
if ar.SidebarCollapsed then
ar:ExpandSidebar()
else
ar:CollapseSidebar()
end
else
if r then
ar:CollapseSidebar()
else
ar:ExpandSidebar()
end
end
end

local p=ar:CreateTopbarButton("Sidebar","chevrons-left",function()
ar:ToggleSidebar()
end,998)
ar.UIElements.SidebarToggleButton=p
ar.UIElements.SidebarToggleButtonIcon=p:FindFirstChild("WindowTopbarButtonIcon",true)
updateSidebarToggleIcon()

ar:CreateTopbarButton("Minimize","minus",function()
ar:Close()






















end,997)

function ar.OnOpen(r,u)
ar.OnOpenCallback=u
end
function ar.OnClose(r,u)
ar.OnCloseCallback=u
end
function ar.OnDestroy(r,u)
ar.OnDestroyCallback=u
end

if aq.ANUI.UseAcrylic then
ar.AcrylicPaint.AddParent(ar.UIElements.Main)
end

function ar.SetIconSize(r,u)
local v
if typeof(u)=="number"then
v=UDim2.new(0,u,0,u)
ar.IconSize=u
elseif typeof(u)=="UDim2"then
v=u
ar.IconSize=u.X.Offset
end

if j then
j.Size=v
end
end

function ar.Open(r)
task.spawn(function()
if ar.OnOpenCallback then
task.spawn(function()
ai.SafeCallback(ar.OnOpenCallback)
end)
end


task.wait(.06)
ar.Closed=false

ak(ar.UIElements.Main.Background,0.2,{
ImageTransparency=ar.Transparent and aq.ANUI.TransparencyValue or 0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if ar.UIElements.BackgroundGradient then
ak(ar.UIElements.BackgroundGradient,0.2,{
ImageTransparency=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

ak(ar.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,0),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()

if d then
if d:IsA"VideoFrame"then
d.Visible=true
else
ak(d,0.2,{
ImageTransparency=ar.BackgroundImageTransparency,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

if ar.OpenButtonMain and ar.IsOpenButtonEnabled then
ar.OpenButtonMain:Visible(false)
end


ak(ax,0.25,{ImageTransparency=ar.ShadowTransparency},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if UIStroke then
ak(UIStroke,0.25,{Transparency=.8},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

task.spawn(function()
task.wait(.3)
ak(g,.45,{Size=UDim2.new(0,200,0,4),ImageTransparency=.8},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
m:Set(true)
task.wait(.45)
if ar.Resizable then
ak(au.ImageLabel,.45,{ImageTransparency=.8},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
ar.CanResize=true
end
end)


ar.CanDropdown=true

ar.UIElements.Main.Visible=true
task.spawn(function()
task.wait(.05)
ar.UIElements.Main:WaitForChild"Main".Visible=true

aq.ANUI:ToggleAcrylic(true)
end)
end)
end
function ar.Close(r)
local u={}

if ar.OnCloseCallback then
task.spawn(function()
ai.SafeCallback(ar.OnCloseCallback)
end)
end

aq.ANUI:ToggleAcrylic(false)

ar.UIElements.Main:WaitForChild"Main".Visible=false

ar.CanDropdown=false
ar.Closed=true

ak(ar.UIElements.Main.Background,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
if ar.UIElements.BackgroundGradient then
ak(ar.UIElements.BackgroundGradient,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end

ak(ar.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,-240),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()


if d then
if d:IsA"VideoFrame"then
d.Visible=false
else
ak(d,0.3,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
ak(ax,0.25,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if UIStroke then
ak(UIStroke,0.25,{Transparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

ak(g,.3,{Size=UDim2.new(0,0,0,4),ImageTransparency=1},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()
ak(au.ImageLabel,.3,{ImageTransparency=1},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
m:Set(false)
ar.CanResize=false

task.spawn(function()
task.wait(0.4)
ar.UIElements.Main.Visible=false

if ar.OpenButtonMain and not ar.Destroyed and ar.IsOpenButtonEnabled then
ar.OpenButtonMain:Edit{OnlyIcon=true}
ar.OpenButtonMain:Visible(true)
end
end)

function u.Destroy(v)
task.spawn(function()
if ar.OnDestroyCallback then
task.spawn(function()
ai.SafeCallback(ar.OnDestroyCallback)
end)
end
if ar.AcrylicPaint and ar.AcrylicPaint.Model then
ar.AcrylicPaint.Model:Destroy()
end
ar.Destroyed=true
task.wait(0.4)
aq.ANUI.ScreenGui:Destroy()
aq.ANUI.NotificationGui:Destroy()
aq.ANUI.DropdownGui:Destroy()

ai.DisconnectAll()

return
end)
end

return u
end
function ar.Destroy(r)
return ar:Close():Destroy()
end
function ar.Toggle(r)
if ar.Closed then
ar:Open()
else
ar:Close()
end
end


function ar.ToggleTransparency(r,u)

ar.Transparent=u
aq.ANUI.Transparent=u

ar.UIElements.Main.Background.ImageTransparency=u and aq.ANUI.TransparencyValue or 0

ar.UIElements.MainBar.Background.ImageTransparency=u and 0.97 or 0.95

end

function ar.LockAll(r)
for u,v in next,ar.AllElements do
if v.Lock then v:Lock()end
end
end
function ar.UnlockAll(r)
for u,v in next,ar.AllElements do
if v.Unlock then v:Unlock()end
end
end
function ar.GetLocked(r)
local u={}

for v,x in next,ar.AllElements do
if x.Locked then table.insert(u,x)end
end

return u
end
function ar.GetUnlocked(r)
local u={}

for v,x in next,ar.AllElements do
if x.Locked==false then table.insert(u,x)end
end

return u
end

function ar.GetUIScale(r,u)
return aq.ANUI.UIScale
end

function ar.SetUIScale(r,u)
aq.ANUI.UIScale=u
ak(aq.ANUI.UIScaleObj,.2,{Scale=u},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return ar
end

function ar.SetToTheCenter(r)
ak(ar.UIElements.Main,0.45,{Position=UDim2.new(0.5,0,0.5,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return ar
end

function ar.SetCurrentConfig(r,u)
ar.CurrentConfig=u
end

do
local r=40
local u=ae.ViewportSize
local v=ar.UIElements.Main.AbsoluteSize

if not ar.IsFullscreen and ar.AutoScale then
local x=u.X-(r*2)
local z=u.Y-(r*2)

local A=x/v.X
local B=z/v.Y

local C=math.min(A,B)

local F=0.3
local G=1.0

local H=math.clamp(C,F,G)

local J=ar:GetUIScale()or 1
local L=0.05

if math.abs(H-J)>L then
ar:SetUIScale(H)
end
end
end


if ar.OpenButtonMain and ar.OpenButtonMain.Button then
ai.AddSignal(ar.OpenButtonMain.Button.TextButton.MouseButton1Click,function()


ar:Open()
end)
end

ai.AddSignal(ad.InputBegan,function(r,u)
if u then return end

if ar.ToggleKey then
if r.KeyCode==ar.ToggleKey then
ar:Toggle()
end
end
end)

task.spawn(function()

ar:Open()
end)

function ar.EditOpenButton(r,u)
return ar.OpenButtonMain:Edit(u)
end

if ar.OpenButton and typeof(ar.OpenButton)=="table"then
ar:EditOpenButton(ar.OpenButton)
end


local r=a.load'V'
local u=a.load'W'
local v=r.Init(ar,aq.ANUI,aq.Parent.Parent.ToolTips)
v:OnChange(function(x)ar.CurrentTab=x end)

ar.TabModule=r

function ar.Tab(x,z)
z.Parent=ar.UIElements.SideBar.Frame
return v.New(z,aq.ANUI.UIScale)
end

function ar.SelectTab(x,z)
v:SelectTab(z)
end

function ar.Section(x,z)
return u.New(z,ar.UIElements.SideBar.Frame,ar.Folder,aq.ANUI.UIScale,ar)
end

function ar.IsResizable(x,z)
ar.Resizable=z
ar.CanResize=z
end

function ar.Divider(x)
local z=aj("Frame",{
Size=UDim2.new(1,0,0,1),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local A=aj("Frame",{
Parent=ar.UIElements.SideBar.Frame,

Size=UDim2.new(1,-7,0,5),
BackgroundTransparency=1,
},{
z
})

return A
end

local x=a.load'l'.Init(ar,nil)
function ar.Dialog(z,A)
local B={
Title=A.Title or"Dialog",
Width=A.Width or 320,
Content=A.Content,
Buttons=A.Buttons or{},

TextPadding=10,
}
local C=x.Create(false)

C.UIElements.Main.Size=UDim2.new(0,B.Width,0,0)

local F=aj("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=C.UIElements.Main
},{
aj("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,C.UIPadding),
VerticalAlignment="Center"
}),
aj("UIPadding",{
PaddingTop=UDim.new(0,B.TextPadding/2),
PaddingLeft=UDim.new(0,B.TextPadding/2),
PaddingRight=UDim.new(0,B.TextPadding/2),
})
})

local G
if A.Icon then
G=ai.Image(
A.Icon,
B.Title..":"..A.Icon,
0,
ar,
"Dialog",
true,
A.IconThemed
)
G.Size=UDim2.new(0,22,0,22)
G.Parent=F
end

C.UIElements.UIListLayout=aj("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
Parent=C.UIElements.Main
})

aj("UISizeConstraint",{
MinSize=Vector2.new(180,20),
MaxSize=Vector2.new(400,math.huge),
Parent=C.UIElements.Main,
})


C.UIElements.Title=aj("TextLabel",{
Text=B.Title,
TextSize=20,
FontFace=Font.new(ai.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
TextWrapped=true,
RichText=true,
Size=UDim2.new(1,G and-26-C.UIPadding or 0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=F
})
if B.Content then
aj("TextLabel",{
Text=B.Content,
TextSize=18,
TextTransparency=.4,
TextWrapped=true,
RichText=true,
FontFace=Font.new(ai.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
LayoutOrder=2,
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=C.UIElements.Main
},{
aj("UIPadding",{
PaddingLeft=UDim.new(0,B.TextPadding/2),
PaddingRight=UDim.new(0,B.TextPadding/2),
PaddingBottom=UDim.new(0,B.TextPadding/2),
})
})
end

local H=aj("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
})

local J=aj("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="None",
BackgroundTransparency=1,
Parent=C.UIElements.Main,
LayoutOrder=4,
},{
H,






})


local L={}

for M,N in next,B.Buttons do
local O=am(N.Title,N.Icon,N.Callback,N.Variant,J,C,false)
table.insert(L,O)
end

local function CheckButtonsOverflow()
H.FillDirection=Enum.FillDirection.Horizontal
H.HorizontalAlignment=Enum.HorizontalAlignment.Right
H.VerticalAlignment=Enum.VerticalAlignment.Center
J.AutomaticSize=Enum.AutomaticSize.None

for M,N in ipairs(L)do
N.Size=UDim2.new(0,0,1,0)
N.AutomaticSize=Enum.AutomaticSize.X
end

wait()

local M=H.AbsoluteContentSize.X/aq.ANUI.UIScale
local N=J.AbsoluteSize.X/aq.ANUI.UIScale

if M>N then
H.FillDirection=Enum.FillDirection.Vertical
H.HorizontalAlignment=Enum.HorizontalAlignment.Right
H.VerticalAlignment=Enum.VerticalAlignment.Bottom
J.AutomaticSize=Enum.AutomaticSize.Y

for O,P in ipairs(L)do
P.Size=UDim2.new(1,0,0,40)
P.AutomaticSize=Enum.AutomaticSize.None
end
else
local O=N-M
if O>0 then
local P
local Q=math.huge

for R,S in ipairs(L)do
local T=S.AbsoluteSize.X/aq.ANUI.UIScale
if T<Q then
Q=T
P=S
end
end

if P then
P.Size=UDim2.new(0,Q+O,1,0)
P.AutomaticSize=Enum.AutomaticSize.None
end
end
end
end

ai.AddSignal(C.UIElements.Main:GetPropertyChangedSignal"AbsoluteSize",CheckButtonsOverflow)
CheckButtonsOverflow()

wait()
C:Open()

return C
end


ar:CreateTopbarButton("Close","x",function()
if not ar.IgnoreAlerts then
ar:SetToTheCenter()
ar:Dialog{

Title="Close Window",
Content="Do you want to close this window? You will not be able to open it again.",
Buttons={
{
Title="Cancel",

Callback=function()end,
Variant="Secondary",
},
{
Title="Close",

Callback=function()ar:Destroy()end,
Variant="Primary",
}
}
}
else
ar:Destroy()
end
end,999)

function ar.Tag(z,A)
if ar.UIElements.Main.Main.Topbar.Center.Visible==false then ar.UIElements.Main.Main.Topbar.Center.Visible=true end
return ao:New(A,ar.UIElements.Main.Main.Topbar.Center)
end


local function startResizing(z)
if ar.CanResize then
isResizing=true
av.Active=true
initialSize=ar.UIElements.Main.Size
initialInputPosition=z.Position


ak(au.ImageLabel,0.1,{ImageTransparency=.35}):Play()

ai.AddSignal(z.Changed,function()
if z.UserInputState==Enum.UserInputState.End then
isResizing=false
av.Active=false


ak(au.ImageLabel,0.17,{ImageTransparency=.8}):Play()
end
end)
end
end

ai.AddSignal(au.InputBegan,function(z)
if z.UserInputType==Enum.UserInputType.MouseButton1 or z.UserInputType==Enum.UserInputType.Touch then
if ar.CanResize then
startResizing(z)
end
end
end)

ai.AddSignal(ad.InputChanged,function(z)
if z.UserInputType==Enum.UserInputType.MouseMovement or z.UserInputType==Enum.UserInputType.Touch then
if isResizing and ar.CanResize then
local A=z.Position-initialInputPosition
local B=UDim2.new(0,initialSize.X.Offset+A.X*2,0,initialSize.Y.Offset+A.Y*2)

B=UDim2.new(
B.X.Scale,
math.clamp(B.X.Offset,ar.MinSize.X,ar.MaxSize.X),
B.Y.Scale,
math.clamp(B.Y.Offset,ar.MinSize.Y,ar.MaxSize.Y)
)

ak(ar.UIElements.Main,0,{
Size=B
}):Play()

ar.Size=B
end
end
end)




local z=0
local A=0.4
local B
local C=0

function onDoubleClick()
ar:SetToTheCenter()
end

g.Frame.MouseButton1Up:Connect(function()
local F=tick()
local G=ar.Position

C=C+1

if C==1 then
z=F
B=G

task.spawn(function()
task.wait(A)
if C==1 then
C=0
B=nil
end
end)

elseif C==2 then
if F-z<=A and G==B then
onDoubleClick()
end

C=0
B=nil
z=0
else
C=1
z=F
B=G
end
end)





if not ar.HideSearchBar then
local F=a.load'Y'
local G=false





















local H=al("Search","search",ar.UIElements.SideBarContainer,true)
H.Size=UDim2.new(1,-ar.UIPadding/2,0,39)
H.Position=UDim2.new(0,ar.UIPadding/2,0,ar.UIPadding/2)

ai.AddSignal(H.MouseButton1Click,function()
if G then return end

F.new(ar.TabModule,ar.UIElements.Main,function()

G=false
if ar.Resizable then
ar.CanResize=true
end

ak(aw,0.1,{ImageTransparency=1}):Play()
aw.Active=false
end)
ak(aw,0.1,{ImageTransparency=.65}):Play()
aw.Active=true

G=true
ar.CanResize=false
end)
end




function ar.DisableTopbarButtons(F,G)
for H,J in next,G do
for L,M in next,ar.TopBarButtons do
if M.Name==J then
M.Object.Visible=false
end
end
end
end

return ar
end end end

local aa={
Window=nil,
Theme=nil,
Creator=a.load'b',
LocalizationModule=a.load'c',
NotificationModule=a.load'd',
Themes=nil,
Transparent=false,

TransparencyValue=.15,

UIScale=1,

ConfigManager=nil,
Version="0.0.0",

Services=a.load'h',

OnThemeChangeFunction=nil,

cloneref=nil,
UIScaleObj=nil,
}


local ad=(cloneref or clonereference or function(ad)return ad end)

aa.cloneref=ad

local ae=ad(game:GetService"HttpService")
local ag=ad(game:GetService"Players")
local ai=ad(game:GetService"CoreGui")local aj=

ag.LocalPlayer or nil

local ak=ae:JSONDecode(a.load'i')
if ak then
aa.Version=ak.version
end

local al=a.load'm'local am=

aa.Services


local an=aa.Creator

local ao=an.New local ap=
an.Tween


local aq=a.load'q'


local ar=protectgui or(syn and syn.protect_gui)or function()end

local as=gethui and gethui()or(ai or game.Players.LocalPlayer:WaitForChild"PlayerGui")

local at=ao("UIScale",{
Scale=aa.Scale,
})

aa.UIScaleObj=at

aa.ScreenGui=ao("ScreenGui",{
Name="ANUI",
Parent=as,
IgnoreGuiInset=true,
ScreenInsets="None",
},{

ao("Folder",{
Name="Window"
}),






ao("Folder",{
Name="KeySystem"
}),
ao("Folder",{
Name="Popups"
}),
ao("Folder",{
Name="ToolTips"
})
})

aa.NotificationGui=ao("ScreenGui",{
Name="ANUI/Notifications",
Parent=as,
IgnoreGuiInset=true,
})
aa.DropdownGui=ao("ScreenGui",{
Name="ANUI/Dropdowns",
Parent=as,
IgnoreGuiInset=true,
})
ar(aa.ScreenGui)
ar(aa.NotificationGui)
ar(aa.DropdownGui)

an.Init(aa)


function aa.SetParent(au,av)
aa.ScreenGui.Parent=av
aa.NotificationGui.Parent=av
aa.DropdownGui.Parent=av
end
math.clamp(aa.TransparencyValue,0,1)

local au=aa.NotificationModule.Init(aa.NotificationGui)

function aa.Notify(av,aw)
aw.Holder=au.Frame
aw.Window=aa.Window

return aa.NotificationModule.New(aw)
end

function aa.SetNotificationLower(av,aw)
au.SetLower(aw)
end

function aa.SetFont(av,aw)
an.UpdateFont(aw)
end

function aa.OnThemeChange(av,aw)
aa.OnThemeChangeFunction=aw
end

function aa.AddTheme(av,aw)
aa.Themes[aw.Name]=aw
return aw
end

function aa.SetTheme(av,aw)
if aa.Themes[aw]then
aa.Theme=aa.Themes[aw]
an.SetTheme(aa.Themes[aw])

if aa.OnThemeChangeFunction then
aa.OnThemeChangeFunction(aw)
end


return aa.Themes[aw]
end
return nil
end

function aa.GetThemes(av)
return aa.Themes
end
function aa.GetCurrentTheme(av)
return aa.Theme.Name
end
function aa.GetTransparency(av)
return aa.Transparent or false
end
function aa.GetWindowSize(av)
return Window.UIElements.Main.Size
end
function aa.Localization(av,aw)
return aa.LocalizationModule:New(aw,an)
end

function aa.SetLanguage(av,aw)
if an.Localization then
return an.SetLanguage(aw)
end
return false
end

function aa.ToggleAcrylic(av,aw)
if aa.Window and aa.Window.AcrylicPaint and aa.Window.AcrylicPaint.Model then
aa.Window.Acrylic=aw
aa.Window.AcrylicPaint.Model.Transparency=aw and 0.98 or 1
if aw then
aq.Enable()
else
aq.Disable()
end
end
end



function aa.Gradient(av,aw,ax)
local ay={}
local az={}

for aA,aB in next,aw do
local d=tonumber(aA)
if d then
d=math.clamp(d/100,0,1)
table.insert(ay,ColorSequenceKeypoint.new(d,aB.Color))
table.insert(az,NumberSequenceKeypoint.new(d,aB.Transparency or 0))
end
end

table.sort(ay,function(aA,aB)return aA.Time<aB.Time end)
table.sort(az,function(aA,aB)return aA.Time<aB.Time end)


if#ay<2 then
error"ColorSequence requires at least 2 keypoints"
end


local aA={
Color=ColorSequence.new(ay),
Transparency=NumberSequence.new(az),
}

if ax then
for aB,d in pairs(ax)do
aA[aB]=d
end
end

return aA
end


function aa.Popup(av,aw)
aw.ANUI=aa
return a.load'r'.new(aw)
end


aa.Themes=a.load's'(aa)

an.Themes=aa.Themes


aa:SetTheme"Dark"
aa:SetLanguage(an.Language)


function aa.CreateWindow(av,aw)
local ax=a.load'Z'

if not isfolder"ANUI"then
makefolder"ANUI"
end
if aw.Folder then
makefolder(aw.Folder)
else
makefolder(aw.Title)
end

aw.ANUI=aa
aw.Parent=aa.ScreenGui.Window

if aa.Window then
warn"You cannot create more than one window"
return
end

local ay=true

local az=aa.Themes[aw.Theme or"Dark"]


an.SetTheme(az)


local aA=gethwid or function()
return ag.LocalPlayer.UserId
end

local aB=aA()

if aw.KeySystem then
ay=false

local function loadKeysystem()
al.new(aw,aB,function(d)ay=d end)
end

local d=(aw.Folder or"Temp").."/"..aB..".key"

if aw.KeySystem.KeyValidator then
if aw.KeySystem.SaveKey and isfile(d)then
local e=readfile(d)
local f=aw.KeySystem.KeyValidator(e)

if f then
ay=true
else
loadKeysystem()
end
else
loadKeysystem()
end
elseif not aw.KeySystem.API then
if aw.KeySystem.SaveKey and isfile(d)then
local e=readfile(d)
local f=(type(aw.KeySystem.Key)=="table")
and table.find(aw.KeySystem.Key,e)
or tostring(aw.KeySystem.Key)==tostring(e)

if f then
ay=true
else
loadKeysystem()
end
else
loadKeysystem()
end
else
if isfile(d)then
local e=readfile(d)
local f=false

for g,h in next,aw.KeySystem.API do
local j=aa.Services[h.Type]
if j then
local l={}
for m,p in next,j.Args do
table.insert(l,h[p])
end

local m=j.New(table.unpack(l))
local p=m.Verify(e)
if p then
f=true
break
end
end
end

ay=f
if not f then loadKeysystem()end
else
loadKeysystem()
end
end

repeat task.wait()until ay
end

local d=ax(aw)

aa.Transparent=aw.Transparent
aa.Window=d

if aw.Acrylic then
aq.init()
end













return d
end

return aa