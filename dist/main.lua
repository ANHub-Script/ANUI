--[[
     _      ___         ____  ______
    | | /| / (_)__  ___/ / / / /  _/
    | |/ |/ / / _ \/ _  / /_/ // /  
    |__/|__/_/_//_/\_,_/\____/___/
    
    v1.0.149  |  2025-12-04  |  Roblox UI Library for scripts
    
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
    "version": "1.0.149",
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

local ae=(cloneref or clonereference or function(ae)return ae end)


ae(game:GetService"UserInputService")


local function Color3ToHSB(af)
local ag,ah,ai=af.R,af.G,af.B
local aj=math.max(ag,ah,ai)
local ak=math.min(ag,ah,ai)
local al=aj-ak

local am=0
if al~=0 then
if aj==ag then
am=(ah-ai)/al%6
elseif aj==ah then
am=(ai-ag)/al+2
else
am=(ag-ah)/al+4
end
am=am*60
else
am=0
end

local an=(aj==0)and 0 or(al/aj)
local ao=aj

return{
h=math.floor(am+0.5),
s=an,
b=ao
}
end

local function GetPerceivedBrightness(af)
local ag=af.R
local ah=af.G
local ai=af.B
return 0.299*ag+0.587*ah+0.114*ai
end

local function GetTextColorForHSB(af)
local ag=Color3ToHSB(af)local
ah, ai, aj=ag.h, ag.s, ag.b
if GetPerceivedBrightness(af)>0.5 then
return Color3.fromHSV(ah/360,0,0.05)
else
return Color3.fromHSV(ah/360,0,0.98)
end
end


local function getElementPosition(af,ag)
if type(ag)~="number"or ag~=math.floor(ag)then
return nil,1
end






local ah=#af


if ah==0 or ag<1 or ag>ah then
return nil,2
end

local function isDelimiter(ai)
if ai==nil then return true end
local aj=ai.__type
return aj=="Divider"or aj=="Space"or aj=="Section"or aj=="Code"or aj=="Paragraph"
end

if isDelimiter(af[ag])then
return nil,3
end

local function calculate(ai,aj)
if aj==1 then return"Squircle"end
if ai==1 then return"Squircle-TL-TR"end
if ai==aj then return"Squircle-BL-BR"end
return"Square"
end

local ai=1
local aj=0

for ak=1,ah do
local al=af[ak]
if isDelimiter(al)then
if ag>=ai and ag<=ak-1 then
local am=ag-ai+1
return calculate(am,aj)
end
ai=ak+1
aj=0
else
aj=aj+1
end
end


if ag>=ai and ag<=ah then
local ak=ag-ai+1
return calculate(ak,aj)
end

return nil,4
end


return function(af)
local ag={
Title=af.Title,
Desc=af.Desc or nil,
Hover=af.Hover,
Thumbnail=af.Thumbnail,
ThumbnailSize=af.ThumbnailSize or 80,
Image=af.Image,
IconThemed=af.IconThemed or false,
ImageSize=af.ImageSize or 30,
Color=af.Color,
Scalable=af.Scalable,
Parent=af.Parent,
Justify=af.Justify or"Between",
UIPadding=af.Window.ElementConfig.UIPadding,
UICorner=af.Window.ElementConfig.UICorner,
UIElements={},

Index=af.Index
}

local ah=ag.ImageSize
local ai=ag.ThumbnailSize
local aj=true


local ak=0

local al
local am
if ag.Thumbnail then
al=aa.Image(
ag.Thumbnail,
ag.Title,
af.Window.NewElements and ag.UICorner-11 or(ag.UICorner-4),
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
al.Size=UDim2.new(1,0,0,ai)
end
if ag.Image then
am=aa.Image(
ag.Image,
ag.Title,
af.Window.NewElements and ag.UICorner-11 or(ag.UICorner-4),
af.Window.Folder,
"Image",
ag.IconThemed,
not ag.Color and true or false,
"ElementIcon"
)
if typeof(ag.Color)=="string"then
am.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
elseif typeof(ag.Color)=="Color3"then
am.ImageLabel.ImageColor3=GetTextColorForHSB(ag.Color)
end

am.Size=UDim2.new(0,ah,0,ah)

ak=ah
end

local function CreateText(an,ao)
local ap=typeof(ag.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
or typeof(ag.Color)=="Color3"
and GetTextColorForHSB(ag.Color)

return ab("TextLabel",{
BackgroundTransparency=1,
Text=an or"",
TextSize=ao=="Desc"and 15 or 17,
TextXAlignment="Left",
ThemeTag={
TextColor3=not ag.Color and("Element"..ao)or nil,
},
TextColor3=ag.Color and ap or nil,
TextTransparency=ao=="Desc"and.3 or 0,
TextWrapped=true,
Size=UDim2.new(ag.Justify=="Between"and 1 or 0,0,0,0),
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
FontFace=Font.new(aa.Font,ao=="Desc"and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold)
})
end

local an=CreateText(ag.Title,"Title")
local ao=CreateText(ag.Desc,"Desc")
if not ag.Desc or ag.Desc==""then
ao.Visible=false
end

ag.UIElements.Container=ab("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ab("UIListLayout",{
Padding=UDim.new(0,ag.UIPadding),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment=ag.Justify=="Between"and"Left"or"Center",
}),
al,
ab("Frame",{
Size=UDim2.new(
ag.Justify=="Between"and 1 or 0,
ag.Justify=="Between"and-af.TextOffset or 0,
0,
0
),
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
BackgroundTransparency=1,
Name="TitleFrame",
},{
ab("UIListLayout",{
Padding=UDim.new(0,ag.UIPadding),
FillDirection="Horizontal",
VerticalAlignment=(af.ElementTable and af.ElementTable.__type=="Dropdown")and"Center"
or((am and af.ElementTable and af.ElementTable.__type=="Toggle")and"Center"
or(af.Window.NewElements and(ag.Justify=="Between"and"Top"or"Center")or"Center")),
HorizontalAlignment=ag.Justify~="Between"and ag.Justify or"Center",
}),
am,
ab("Frame",{
BackgroundTransparency=1,
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
Size=UDim2.new(
ag.Justify=="Between"and 1 or 0,
ag.Justify=="Between"and(am and-ak-ag.UIPadding or-ak)or 0,
1,
0
),
Name="TitleFrame",
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,af.Window.NewElements and ag.UIPadding/2 or 0),
PaddingLeft=UDim.new(0,af.Window.NewElements and ag.UIPadding/2 or 0),
PaddingRight=UDim.new(0,af.Window.NewElements and ag.UIPadding/2 or 0),
PaddingBottom=UDim.new(0,af.Window.NewElements and ag.UIPadding/2 or 0),
}),
ab("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
an,
ao
}),
})
})






local ap=aa.Image(
"lock",
"lock",
0,
af.Window.Folder,
"Lock",
false
)
ap.Size=UDim2.new(0,20,0,20)
ap.ImageLabel.ImageColor3=Color3.new(1,1,1)
ap.ImageLabel.ImageTransparency=.4

local aq=ab("TextLabel",{
Text="Locked",
TextSize=18,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
AutomaticSize="XY",
BackgroundTransparency=1,
TextColor3=Color3.new(1,1,1),
TextTransparency=.05,
})

local ar=ab("Frame",{
Size=UDim2.new(1,ag.UIPadding*2,1,ag.UIPadding*2),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ZIndex=9999999,
})

local as,at=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=.25,
ImageColor3=Color3.new(0,0,0),
Visible=false,
Active=false,
Parent=ar,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
ap,aq
},nil,true)

local au,av=ac(ag.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=ar,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
},nil,true)

local aw,ax=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=ar,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
},nil,true)


local ay,az=ac(ag.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=ar,
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

local aA,aB=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=ar,
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

local d,e=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=ag.Color and.05 or.93,



Parent=af.Parent,
ThemeTag={
ImageColor3=not ag.Color and"ElementBackground"or nil
},
ImageColor3=ag.Color and
(
typeof(ag.Color)=="string"
and Color3.fromHex(aa.Colors[ag.Color])
or typeof(ag.Color)=="Color3"
and ag.Color
)or nil
},{
ag.UIElements.Container,
ar,
ab("UIPadding",{
PaddingTop=UDim.new(0,ag.UIPadding),
PaddingLeft=UDim.new(0,ag.UIPadding),
PaddingRight=UDim.new(0,ag.UIPadding),
PaddingBottom=UDim.new(0,ag.UIPadding),
}),
},true,true)

ag.UIElements.Main=d
ag.UIElements.Locked=as

if ag.Hover then
aa.AddSignal(d.MouseEnter,function()
if aj then
ad(d,.12,{ImageTransparency=ag.Color and.15 or.9}):Play()
ad(aA,.12,{ImageTransparency=.9}):Play()
ad(ay,.12,{ImageTransparency=.8}):Play()
aa.AddSignal(d.MouseMoved,function(f,g)
aA.HoverGradient.Offset=Vector2.new(((f-d.AbsolutePosition.X)/d.AbsoluteSize.X)-0.5,0)
ay.HoverGradient.Offset=Vector2.new(((f-d.AbsolutePosition.X)/d.AbsoluteSize.X)-0.5,0)
end)
end
end)
aa.AddSignal(d.InputEnded,function()
if aj then
ad(d,.12,{ImageTransparency=ag.Color and.05 or.93}):Play()
ad(aA,.12,{ImageTransparency=1}):Play()
ad(ay,.12,{ImageTransparency=1}):Play()
end
end)
end

function ag.SetTitle(f,g)
ag.Title=g
an.Text=g
end

function ag.SetDesc(f,g)
ag.Desc=g
ao.Text=g or""
if not g then
ao.Visible=false
elseif not ao.Visible then
ao.Visible=true
end
end


function ag.Colorize(f,g,h)
if ag.Color then
g[h]=typeof(ag.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
or typeof(ag.Color)=="Color3"
and GetTextColorForHSB(ag.Color)
or nil
end
end

if af.ElementTable then
aa.AddSignal(an:GetPropertyChangedSignal"Text",function()
if ag.Title~=an.Text then
ag:SetTitle(an.Text)
af.ElementTable.Title=an.Text
end
end)
aa.AddSignal(ao:GetPropertyChangedSignal"Text",function()
if ag.Desc~=ao.Text then
ag:SetDesc(ao.Text)
af.ElementTable.Desc=ao.Text
end
end)
end





function ag.SetThumbnail(f,g,h)
ag.Thumbnail=g
if h then
ag.ThumbnailSize=h
ai=h
end

if al then
if g then
al:Destroy()
al=aa.Image(
g,
ag.Title,
ag.UICorner-3,
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
al.Size=UDim2.new(1,0,0,ai)
al.Parent=ag.UIElements.Container
local j=ag.UIElements.Container:FindFirstChild"UIListLayout"
if j then
al.LayoutOrder=-1
end
else
al.Visible=false
end
else
if g then
al=aa.Image(
g,
ag.Title,
ag.UICorner-3,
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
al.Size=UDim2.new(1,0,0,ai)
al.Parent=ag.UIElements.Container
local j=ag.UIElements.Container:FindFirstChild"UIListLayout"
if j then
al.LayoutOrder=-1
end
end
end
end

function ag.SetImage(f,g,h)
ag.Image=g
if h then
ag.ImageSize=h
ah=h
end

local j=am
if g then
local l=aa.Image(
g,
ag.Title,
ag.UICorner-3,
af.Window.Folder,
"Image",
not ag.Color and true or false
)
if typeof(ag.Color)=="string"and l.ImageLabel then
l.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
elseif typeof(ag.Color)=="Color3"and l.ImageLabel then
l.ImageLabel.ImageColor3=GetTextColorForHSB(ag.Color)
end
l.Visible=true
l.Size=UDim2.new(0,ah,0,ah)
ak=ah
if j and j.Parent then j:Destroy()end
l.Parent=ag.UIElements.Container.TitleFrame
am=l
else
if am then
am.Visible=false
end
ak=0
end

ag.UIElements.Container.TitleFrame.TitleFrame.Size=UDim2.new(1,-ak,1,0)
end

function ag.Destroy(f)
d:Destroy()
end


function ag.Lock(f)
aj=false
as.Active=true
as.Visible=true
end

function ag.Unlock(f)
aj=true
as.Active=false
as.Visible=false
end

function ag.Highlight(f)
local g=ab("UIGradient",{
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
Parent=au
})

local h=ab("UIGradient",{
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
Parent=aw
})

au.ImageTransparency=0.65
aw.ImageTransparency=0.88

ad(g,0.75,{
Offset=Vector2.new(1,0)
}):Play()

ad(h,0.75,{
Offset=Vector2.new(1,0)
}):Play()


task.spawn(function()
task.wait(.75)
au.ImageTransparency=1
aw.ImageTransparency=1
g:Destroy()
h:Destroy()
end)
end


function ag.UpdateShape(f)
if af.Window.NewElements then
local g

local h=af.ParentType or(af.ParentConfig and af.ParentConfig.ParentType)
if h=="Group"or h=="Paragraph"then
g="Squircle"
else
g=getElementPosition(f.Elements,ag.Index)
end

if g and d then
e:SetType(g)
at:SetType(g)
ax:SetType(g)
av:SetType(g.."-Outline")
aB:SetType(g)
az:SetType(g.."-Outline")
end
end
end





return ag
end end function a.A()

local aa=a.load'b'
local ab=aa.New

local ac={}

local ad=a.load'j'.New

function ac.New(ae,af)
af.Hover=false
af.TextOffset=0
af.ParentConfig=af
af.IsButtons=af.Buttons and#af.Buttons>0 and true or false

local ag={
__type="Paragraph",
Title=af.Title or"Paragraph",
Desc=af.Desc or nil,

Locked=af.Locked or false,
Elements={}
}
local ah=a.load'z'(af)

ag.ParagraphFrame=ah
if af.Buttons and#af.Buttons>0 then
local ai=ab("Frame",{
Size=UDim2.new(1,0,0,38),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ah.UIElements.Container
},{
ab("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
})
})


for aj,ak in next,af.Buttons do
local al=ad(ak.Title,ak.Icon,ak.Callback,"White",ai,nil,nil,af.Window.NewElements and 12 or 10)
al.Size=UDim2.new(1,0,0,38)

end
end

local ai=af.ElementsModule
if ai then
ai.Load(
ag,
ah.UIElements.Container,
ai.Elements,
af.Window,
af.ANUI,
nil,
ai,
af.UIScale,
af.Tab
)
end

return ag.__type,ag

end

return ac end function a.B()
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
local aa=a.load'b'local ab=
aa.New local ac=
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
ai.ToggleFrame=a.load'z'{
Title=ai.Title,
Desc=ai.Desc,
Image=ai.Image,
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

local aj=true

if ai.Value==nil then
ai.Value=false
end



function ai.Lock(ak)
ai.Locked=true
aj=false
return ai.ToggleFrame:Lock()
end
function ai.Unlock(ak)
ai.Locked=false
aj=true
return ai.ToggleFrame:Unlock()
end

if ai.Locked then
ai:Lock()
end

local ak=ai.Value

local al,am
if ai.Type=="Toggle"then
al,am=ad(ak,ai.Icon,ai.IconSize,ai.ToggleFrame.UIElements.Main,ai.Callback,ah.Window.NewElements,ah)
elseif ai.Type=="Checkbox"then
al,am=ae(ak,ai.Icon,ai.IconSize,ai.ToggleFrame.UIElements.Main,ai.Callback,ah)
else
error("Unknown Toggle Type: "..tostring(ai.Type))
end

al.AnchorPoint=Vector2.new(1,ah.Window.NewElements and 0 or 0.5)
al.Position=UDim2.new(1,0,ah.Window.NewElements and 0 or 0.5,0)

function ai.Set(an,ao,ap,aq)
if aj then
am:Set(ao,ap,aq or false)
ak=ao
ai.Value=ao
end
end

ai:Set(ak,false,ah.Window.NewElements)


if ah.Window.NewElements and am.Animate then
aa.AddSignal(ai.ToggleFrame.UIElements.Main.InputBegan,function(an)
if an.UserInputType==Enum.UserInputType.MouseButton1 or an.UserInputType==Enum.UserInputType.Touch then
am:Animate(an,ai)
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
local ac=aa.New
local ad=aa.Tween

local ae=(cloneref or clonereference or function(ae)return ae end)


local af={}

local ag=false

function af.New(ah,ai)
local aj={
__type="Slider",
Title=ai.Title or"Slider",
Desc=ai.Desc or nil,
Locked=ai.Locked or nil,
Value=ai.Value or{
Min=ai.Min or 0,
Max=ai.Max or 100,
Default=ai.Default or 0
},
Step=ai.Step or 1,
Callback=ai.Callback or function()end,
UIElements={},
IsFocusing=false,

Width=130,
TextBoxWidth=30,
ThumbSize=13,
}
local ak
local al
local am
local an=aj.Value.Default or aj.Value.Min or 0

local ao=an
local ap=(an-(aj.Value.Min or 0))/((aj.Value.Max or 100)-(aj.Value.Min or 0))

local aq=true
local ar=aj.Step%1~=0

local function FormatValue(as)
if ar then
return string.format("%.2f",as)
else
return tostring(math.floor(as+0.5))
end
end

local function CalculateValue(as)
if ar then
return math.floor(as/aj.Step+0.5)*aj.Step
else
return math.floor(as/aj.Step+0.5)*aj.Step
end
end

aj.SliderFrame=a.load'z'{
Title=aj.Title,
Desc=aj.Desc,
Parent=ai.Parent,
TextOffset=aj.Width,
Hover=false,
Tab=ai.Tab,
Index=ai.Index,
Window=ai.Window,
ElementTable=aj,
ParentConfig=ai,
ParentType=ai.ParentType,
}

aj.UIElements.SliderIcon=aa.NewRoundFrame(99,"Squircle",{
ImageTransparency=.95,
Size=UDim2.new(1,-aj.TextBoxWidth-8,0,4),
Name="Frame",
ThemeTag={
ImageColor3="Text",
},
},{
aa.NewRoundFrame(99,"Squircle",{
Name="Frame",
Size=UDim2.new(ap,0,1,0),
ImageTransparency=.1,
ThemeTag={
ImageColor3="Button",
},
},{
aa.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,ai.Window.NewElements and(aj.ThumbSize*1.75)or(aj.ThumbSize+2),0,aj.ThumbSize+2),
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Text",
},
Name="Thumb",
})
})
})

aj.UIElements.SliderContainer=ac("Frame",{
Size=UDim2.new(0,aj.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,ai.Window.NewElements and-20 or 0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Parent=aj.SliderFrame.UIElements.Main,
},{
ac("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aj.UIElements.SliderIcon,
ac("TextBox",{
Size=UDim2.new(0,aj.TextBoxWidth,0,0),
TextXAlignment="Left",
Text=FormatValue(an),
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

function aj.Lock(as)
aj.Locked=true
aq=false
return aj.SliderFrame:Lock()
end
function aj.Unlock(as)
aj.Locked=false
aq=true
return aj.SliderFrame:Unlock()
end

if aj.Locked then
aj:Lock()
end


local as=ai.Tab.UIElements.ContainerFrame

function aj.Set(at,au,av)
if aq then
if not aj.IsFocusing and not ag and(not av or(av.UserInputType==Enum.UserInputType.MouseButton1 or av.UserInputType==Enum.UserInputType.Touch))then
au=math.clamp(au,aj.Value.Min or 0,aj.Value.Max or 100)

local aw=math.clamp((au-(aj.Value.Min or 0))/((aj.Value.Max or 100)-(aj.Value.Min or 0)),0,1)
au=CalculateValue((aj.Value.Min or 0)+aw*((aj.Value.Max or 100)-(aj.Value.Min or 0)))

if au~=ao then
ad(aj.UIElements.SliderIcon.Frame,0.05,{Size=UDim2.new(aw,0,1,0)}):Play()
aj.UIElements.SliderContainer.TextBox.Text=FormatValue(au)
aj.Value.Default=FormatValue(au)
ao=au
aa.SafeCallback(aj.Callback,FormatValue(au))
end

if av then
ak=(av.UserInputType==Enum.UserInputType.Touch)
as.ScrollingEnabled=false
ag=true
al=ae(game:GetService"RunService").RenderStepped:Connect(function()
local ax=ak and av.Position.X or ae(game:GetService"UserInputService"):GetMouseLocation().X
local ay=math.clamp((ax-aj.UIElements.SliderIcon.AbsolutePosition.X)/aj.UIElements.SliderIcon.AbsoluteSize.X,0,1)
au=CalculateValue((aj.Value.Min or 0)+ay*((aj.Value.Max or 100)-(aj.Value.Min or 0)))

if au~=ao then
ad(aj.UIElements.SliderIcon.Frame,0.05,{Size=UDim2.new(ay,0,1,0)}):Play()
aj.UIElements.SliderContainer.TextBox.Text=FormatValue(au)
aj.Value.Default=FormatValue(au)
ao=au
aa.SafeCallback(aj.Callback,FormatValue(au))
end
end)
am=ae(game:GetService"UserInputService").InputEnded:Connect(function(ax)
if(ax.UserInputType==Enum.UserInputType.MouseButton1 or ax.UserInputType==Enum.UserInputType.Touch)and av==ax then
al:Disconnect()
am:Disconnect()
ag=false
as.ScrollingEnabled=true

ad(aj.UIElements.SliderIcon.Frame.Thumb,.2,{Size=UDim2.new(0,ai.Window.NewElements and(aj.ThumbSize*1.75)or(aj.ThumbSize+2),0,aj.ThumbSize+2)},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end
end)
end
end
end
end

function aj.SetMax(at,au)
aj.Value.Max=au

local av=tonumber(aj.Value.Default)or ao
if av>au then
aj:Set(au)
else
local aw=math.clamp((av-(aj.Value.Min or 0))/(au-(aj.Value.Min or 0)),0,1)
ad(aj.UIElements.SliderIcon.Frame,0.1,{Size=UDim2.new(aw,0,1,0)}):Play()
end
end

function aj.SetMin(at,au)
aj.Value.Min=au

local av=tonumber(aj.Value.Default)or ao
if av<au then
aj:Set(au)
else
local aw=math.clamp((av-au)/((aj.Value.Max or 100)-au),0,1)
ad(aj.UIElements.SliderIcon.Frame,0.1,{Size=UDim2.new(aw,0,1,0)}):Play()
end
end

aa.AddSignal(aj.UIElements.SliderContainer.TextBox.FocusLost,function(at)
if at then
local au=tonumber(aj.UIElements.SliderContainer.TextBox.Text)
if au then
aj:Set(au)
else
aj.UIElements.SliderContainer.TextBox.Text=FormatValue(ao)
end
end
end)

aa.AddSignal(aj.UIElements.SliderContainer.InputBegan,function(at)
aj:Set(an,at)

if at.UserInputType==Enum.UserInputType.MouseButton1 or at.UserInputType==Enum.UserInputType.Touch then
ad(aj.UIElements.SliderIcon.Frame.Thumb,.24,{Size=UDim2.new(0,(ai.Window.NewElements and(aj.ThumbSize*1.75)or(aj.ThumbSize))+8,0,aj.ThumbSize+8)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end)

return aj.__type,aj
end

return af end function a.G()
local aa=(cloneref or clonereference or function(aa)return aa end)

local ac=aa(game:GetService"UserInputService")

local ad=a.load'b'
local ae=ad.New local af=
ad.Tween

local ag={
UICorner=6,
UIPadding=8,
}

local ah=a.load't'.New

function ag.New(ai,aj)
local ak={
__type="Keybind",
Title=aj.Title or"Keybind",
Desc=aj.Desc or nil,
Locked=aj.Locked or false,
Value=aj.Value or"F",
Callback=aj.Callback or function()end,
CanChange=aj.CanChange or true,
Picking=false,
UIElements={},
}

local al=true

ak.KeybindFrame=a.load'z'{
Title=ak.Title,
Desc=ak.Desc,
Parent=aj.Parent,
TextOffset=85,
Hover=ak.CanChange,
Tab=aj.Tab,
Index=aj.Index,
Window=aj.Window,
ElementTable=ak,
ParentConfig=aj,
ParentType=aj.ParentType,
}

ak.UIElements.Keybind=ah(ak.Value,nil,ak.KeybindFrame.UIElements.Main)

ak.UIElements.Keybind.Size=UDim2.new(
0,24
+ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
ak.UIElements.Keybind.AnchorPoint=Vector2.new(1,0.5)
ak.UIElements.Keybind.Position=UDim2.new(1,0,0.5,0)

ae("UIScale",{
Parent=ak.UIElements.Keybind,
Scale=.85,
})

ad.AddSignal(ak.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal"TextBounds",function()
ak.UIElements.Keybind.Size=UDim2.new(
0,24
+ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
end)

function ak.Lock(am)
ak.Locked=true
al=false
return ak.KeybindFrame:Lock()
end
function ak.Unlock(am)
ak.Locked=false
al=true
return ak.KeybindFrame:Unlock()
end

function ak.Set(am,an)
ak.Value=an
ak.UIElements.Keybind.Frame.Frame.TextLabel.Text=an
end

if ak.Locked then
ak:Lock()
end

ad.AddSignal(ak.KeybindFrame.UIElements.Main.MouseButton1Click,function()
if al then
if ak.CanChange then
ak.Picking=true
ak.UIElements.Keybind.Frame.Frame.TextLabel.Text="..."

task.wait(0.2)

local am
am=ac.InputBegan:Connect(function(an)
local ao

if an.UserInputType==Enum.UserInputType.Keyboard then
ao=an.KeyCode.Name
elseif an.UserInputType==Enum.UserInputType.MouseButton1 then
ao="MouseLeft"
elseif an.UserInputType==Enum.UserInputType.MouseButton2 then
ao="MouseRight"
end

local ap
ap=ac.InputEnded:Connect(function(aq)
if aq.KeyCode.Name==ao or ao=="MouseLeft"and aq.UserInputType==Enum.UserInputType.MouseButton1 or ao=="MouseRight"and aq.UserInputType==Enum.UserInputType.MouseButton2 then
ak.Picking=false

ak.UIElements.Keybind.Frame.Frame.TextLabel.Text=ao
ak.Value=ao

am:Disconnect()
ap:Disconnect()
end
end)
end)
end
end
end)

ad.AddSignal(ac.InputBegan,function(am,an)
if ac:GetFocusedTextBox()then
return
end

if not al then
return
end

if am.UserInputType==Enum.UserInputType.Keyboard then
if am.KeyCode.Name==ak.Value then
ad.SafeCallback(ak.Callback,am.KeyCode.Name)
end
elseif am.UserInputType==Enum.UserInputType.MouseButton1 and ak.Value=="MouseLeft"then
ad.SafeCallback(ak.Callback,"MouseLeft")
elseif am.UserInputType==Enum.UserInputType.MouseButton2 and ak.Value=="MouseRight"then
ad.SafeCallback(ak.Callback,"MouseRight")
end
end)

return ak.__type,ak
end

return ag end function a.H()
local aa=a.load'b'
local ac=aa.New local ad=
aa.Tween

local ae={
UICorner=8,
UIPadding=8,
}local af=a.load'j'


.New
local ag=a.load'k'.New

function ae.New(ah,ai)
local aj={
__type="Input",
Title=ai.Title or"Input",
Desc=ai.Desc or nil,
Type=ai.Type or"Input",
Locked=ai.Locked or false,
InputIcon=ai.InputIcon or false,
Placeholder=ai.Placeholder or"Enter Text...",
Value=ai.Value or"",
Callback=ai.Callback or function()end,
ClearTextOnFocus=ai.ClearTextOnFocus or false,
UIElements={},

Width=150,
}

local ak=true

aj.InputFrame=a.load'z'{
Title=aj.Title,
Desc=aj.Desc,
Parent=ai.Parent,
TextOffset=aj.Width,
Hover=false,
Tab=ai.Tab,
Index=ai.Index,
Window=ai.Window,
ElementTable=aj,
ParentConfig=ai,
ParentType=ai.ParentType,
}

local al=ag(
aj.Placeholder,
aj.InputIcon,
aj.Type=="Textarea"and aj.InputFrame.UIElements.Container or aj.InputFrame.UIElements.Main,
aj.Type,
function(al)
aj:Set(al,true)
end,
nil,
ai.Window.NewElements and 12 or 10,
aj.ClearTextOnFocus
)

if aj.Type=="Input"then
al.Size=UDim2.new(0,aj.Width,0,36)
al.Position=UDim2.new(1,0,ai.Window.NewElements and 0 or 0.5,0)
al.AnchorPoint=Vector2.new(1,ai.Window.NewElements and 0 or 0.5)
else
al.Size=UDim2.new(1,0,0,148)
end

ac("UIScale",{
Parent=al,
Scale=1,
})

function aj.Lock(am)
aj.Locked=true
ak=false
return aj.InputFrame:Lock()
end
function aj.Unlock(am)
aj.Locked=false
ak=true
return aj.InputFrame:Unlock()
end


function aj.Set(am,an,ao)
if ak then
aj.Value=an
aa.SafeCallback(aj.Callback,an)

if not ao then
al.Frame.Frame.TextBox.Text=an
end
end
end

function aj.SetPlaceholder(am,an)
al.Frame.Frame.TextBox.PlaceholderText=an
aj.Placeholder=an
end

aj:Set(aj.Value)

if aj.Locked then
aj:Lock()
end

return aj.__type,aj
end

return ae end function a.I()
local aa=a.load'b'
local ac=aa.New

local ae={}

function ae.New(af,ag)
local ah=ac("Frame",{
Size=ag.ParentType~="Group"and UDim2.new(1,0,0,1)or UDim2.new(0,1,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local ai=ac("Frame",{
Parent=ag.Parent,
Size=ag.ParentType~="Group"and UDim2.new(1,-7,0,7)or UDim2.new(0,7,1,-7),
BackgroundTransparency=1,
},{
ah
})

return"Divider",{__type="Divider",ElementFrame=ai}
end

return ae end function a.J()
local aa={}

local ac=(cloneref or clonereference or function(ac)return ac end)

local ae=ac(game:GetService"UserInputService")
local af=ac(game:GetService"Players").LocalPlayer:GetMouse()
local ag=ac(game:GetService"Workspace").CurrentCamera

local ah=workspace.CurrentCamera

local ai=a.load'k'.New

local aj=a.load'b'
local ak=aj.New
local al=aj.Tween

function aa.New(am,an,ao,ap,aq)
local ar={}

if not an.Callback then
aq="Menu"
end

an.UIElements.UIListLayout=ak("UIListLayout",{
Padding=UDim.new(0,ao.MenuPadding/1.5),
FillDirection="Vertical",
HorizontalAlignment="Center",
})

an.UIElements.Menu=aj.NewRoundFrame(ao.MenuCorner,"Squircle",{
ThemeTag={
ImageColor3="Background",
},
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
},{
ak("UIPadding",{
PaddingTop=UDim.new(0,ao.MenuPadding),
PaddingLeft=UDim.new(0,ao.MenuPadding),
PaddingRight=UDim.new(0,ao.MenuPadding),
PaddingBottom=UDim.new(0,ao.MenuPadding),
}),
ak("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ao.MenuPadding)
}),
ak("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,an.SearchBarEnabled and-ao.MenuPadding-ao.SearchBarHeight),
Name="Frame",
ClipsDescendants=true,
LayoutOrder=999,
},{
ak("UICorner",{
CornerRadius=UDim.new(0,ao.MenuCorner-ao.MenuPadding),
}),
ak("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
ScrollBarThickness=0,
ScrollingDirection="Y",
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
ScrollBarImageTransparency=1,
},{
an.UIElements.UIListLayout,
})
})
})

an.UIElements.MenuCanvas=ak("Frame",{
Size=UDim2.new(0,an.MenuWidth,0,300),
BackgroundTransparency=1,
Position=UDim2.new(-10,0,-10,0),
Visible=false,
Active=false,

Parent=am.ANUI.DropdownGui,
AnchorPoint=Vector2.new(1,0),
},{
an.UIElements.Menu,
ak("UISizeConstraint",{
MinSize=Vector2.new(170,0),
MaxSize=Vector2.new(300,400),
})
})

local function RecalculateCanvasSize()
an.UIElements.Menu.Frame.ScrollingFrame.CanvasSize=UDim2.fromOffset(0,an.UIElements.UIListLayout.AbsoluteContentSize.Y)
end

local function RecalculateListSize()
local as=ah.ViewportSize.Y*0.6

local at=an.UIElements.UIListLayout.AbsoluteContentSize.Y
local au=an.SearchBarEnabled and(ao.SearchBarHeight+(ao.MenuPadding*3))or(ao.MenuPadding*2)
local av=(at)+au

if av>as then
an.UIElements.MenuCanvas.Size=UDim2.fromOffset(
an.UIElements.MenuCanvas.AbsoluteSize.X,
as
)
else
an.UIElements.MenuCanvas.Size=UDim2.fromOffset(
an.UIElements.MenuCanvas.AbsoluteSize.X,
av
)
end
end

function UpdatePosition()
local as=an.UIElements.Dropdown or an.DropdownFrame.UIElements.Main
local at=an.UIElements.MenuCanvas

local au=ag.ViewportSize.Y-(as.AbsolutePosition.Y+as.AbsoluteSize.Y)-ao.MenuPadding-54
local av=at.AbsoluteSize.Y+ao.MenuPadding

local aw=-54
if au<av then
aw=av-au-54
end

at.Position=UDim2.new(
0,
as.AbsolutePosition.X+as.AbsoluteSize.X,
0,
as.AbsolutePosition.Y+as.AbsoluteSize.Y-aw+(ao.MenuPadding*2)
)
end

local as

function ar.Display(at)
local au=an.Values
local av=""

if an.Multi then
local aw={}
if typeof(an.Value)=="table"then
for ax,ay in ipairs(an.Value)do
local az=typeof(ay)=="table"and ay.Title or ay
aw[az]=true
end
end

for ax,ay in ipairs(au)do
local az=typeof(ay)=="table"and ay.Title or ay
if aw[az]then
av=av..az..", "
end
end

if#av>0 then
av=av:sub(1,#av-2)
end
else
av=typeof(an.Value)=="table"and an.Value.Title or an.Value or""
end

if an.UIElements.Dropdown then
an.UIElements.Dropdown.Frame.Frame.TextLabel.Text=(av==""and"--"or av)
end
end

local function Callback(at)
ar:Display()
if an.Callback then
task.spawn(function()
aj.SafeCallback(an.Callback,an.Value)
end)
else
task.spawn(function()
aj.SafeCallback(at)
end)
end
end

function ar.LockValues(at,au)
if not au then return end

for av,aw in next,an.Tabs do
if aw and aw.UIElements and aw.UIElements.TabItem then
local ax=aw.Name
local ay=false

for az,aA in next,au do
if ax==aA then
ay=true
break
end
end

if ay then
al(aw.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
al(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
al(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.6}):Play()
if aw.UIElements.TabIcon then
al(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.6}):Play()
end

aw.UIElements.TabItem.Active=false
aw.Locked=true
else
if aw.Selected then
al(aw.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
al(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
al(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aw.UIElements.TabIcon then
al(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
else
al(aw.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
al(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
al(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=aq=="Dropdown"and 0.4 or 0.05}):Play()
if aw.UIElements.TabIcon then
al(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=aq=="Dropdown"and 0.2 or 0}):Play()
end
end

aw.UIElements.TabItem.Active=true
aw.Locked=false
end
end
end
end

function ar.Refresh(at,au)
for av,aw in next,an.UIElements.Menu.Frame.ScrollingFrame:GetChildren()do
if not aw:IsA"UIListLayout"then
aw:Destroy()
end
end

an.Tabs={}

if an.SearchBarEnabled then
if not as then
as=ai("Search...","search",an.UIElements.Menu,nil,function(av)
for aw,ax in next,an.Tabs do
if string.find(string.lower(ax.Name),string.lower(av),1,true)then
ax.UIElements.TabItem.Visible=true
else
ax.UIElements.TabItem.Visible=false
end
RecalculateListSize()
RecalculateCanvasSize()
end
end,true)
as.Size=UDim2.new(1,0,0,ao.SearchBarHeight)
as.Position=UDim2.new(0,0,0,0)
as.Name="SearchBar"
end
end

for av,aw in next,au do
if(aw.Type~="Divider")then
local ax={
Name=typeof(aw)=="table"and aw.Title or aw,
Desc=typeof(aw)=="table"and aw.Desc or nil,
Icon=typeof(aw)=="table"and aw.Icon or nil,
Images=typeof(aw)=="table"and aw.Images or nil,
Original=aw,
Selected=false,
Locked=typeof(aw)=="table"and aw.Locked or false,
UIElements={},
}
local ay
if ax.Icon then
ay=aj.Image(
ax.Icon,
ax.Icon,
0,
am.Window.Folder,
"Dropdown",
true
)
ay.Size=UDim2.new(0,ao.TabIcon,0,ao.TabIcon)
ay.ImageLabel.ImageTransparency=aq=="Dropdown"and.2 or 0
ax.UIElements.TabIcon=ay
end
ax.UIElements.TabItem=aj.NewRoundFrame(ao.MenuCorner-ao.MenuPadding,"Squircle",{
Size=UDim2.new(1,0,0,36),
AutomaticSize=((ax.Desc or(ax.Images and#ax.Images>0))and"Y")or nil,
ImageTransparency=1,
Parent=an.UIElements.Menu.Frame.ScrollingFrame,
ImageColor3=Color3.new(1,1,1),
Active=not ax.Locked,
},{
aj.NewRoundFrame(ao.MenuCorner-ao.MenuPadding,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
Name="Highlight",
},{
ak("UIGradient",{
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
ak("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Frame",
},{
ak("UIListLayout",{
Padding=UDim.new(0,ao.TabPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ak("UIPadding",{
PaddingTop=UDim.new(0,ao.TabPadding),
PaddingLeft=UDim.new(0,ao.TabPadding),
PaddingRight=UDim.new(0,ao.TabPadding),
PaddingBottom=UDim.new(0,ao.TabPadding),
}),
ak("UICorner",{
CornerRadius=UDim.new(0,ao.MenuCorner-ao.MenuPadding)
}),
ay,
ak("Frame",{
Size=UDim2.new(1,ay and-ao.TabPadding-ao.TabIcon or 0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Name="Title",
},{
ak("TextLabel",{
Text=ax.Name,
TextXAlignment="Left",
FontFace=Font.new(aj.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text"
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=aq=="Dropdown"and.4 or.05,
LayoutOrder=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
}),
ak("TextLabel",{
Text=ax.Desc or"",
TextXAlignment="Left",
FontFace=Font.new(aj.Font,Enum.FontWeight.Regular),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text"
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=aq=="Dropdown"and.6 or.35,
LayoutOrder=2,
AutomaticSize="Y",
TextWrapped=true,
Size=UDim2.new(1,0,0,0),
Visible=ax.Desc and true or false,
Name="Desc",
}),
ak("ScrollingFrame",{
Size=UDim2.new(1,0,0,70),
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.None,
AutomaticCanvasSize=Enum.AutomaticSize.X,
ScrollingDirection=Enum.ScrollingDirection.X,
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
Visible=(ax.Images and#ax.Images>0)and true or false,
LayoutOrder=3,
Name="Images",
},{
ak("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,an.ImagePadding or ao.TabPadding/3),
VerticalAlignment="Center",
}),
ak("UIPadding",{
PaddingLeft=UDim.new(0,2),
PaddingRight=UDim.new(0,2),
PaddingTop=UDim.new(0,2),
PaddingBottom=UDim.new(0,2),
})
}),
ak("UIListLayout",{
Padding=UDim.new(0,ao.TabPadding/3),
FillDirection="Vertical",
}),
})
})
},true)

if ax.Images and#ax.Images>0 then
local az=ax.UIElements.TabItem.Frame.Title:FindFirstChild"Images"
if az then
for aA,aB in ipairs(ax.Images)do
local d=false
if typeof(aB)=="table"and(aB.Quantity or aB.Gradient or aB.Card)then
d=true
end

if d then
local e=aB.Size or an.ImageSize or UDim2.new(0,60,0,60)
local f=aB.Title or ax.Name
local g=aB.Quantity or""
local h=aB.Rate or""
local j=aB.Image or""
local l=aB.Gradient

local m
if typeof(l)=="ColorSequence"then
m=l
elseif typeof(l)=="Color3"then
m=ColorSequence.new(l)
else
m=ColorSequence.new(Color3.fromRGB(80,80,80))
end


local p
if typeof(l)=="ColorSequence"and l.Keypoints[1]then
p=l.Keypoints[1].Value
elseif typeof(l)=="Color3"then
p=l
else
p=Color3.fromRGB(80,80,80)
end

local r=3




aj.NewRoundFrame(8,"Squircle",{
Size=e,
Parent=az,
ImageColor3=p,
ClipsDescendants=true,
},{

ak("ImageLabel",{
Image="rbxassetid://5554236805",
ScaleType=Enum.ScaleType.Slice,
SliceCenter=Rect.new(23,23,277,277),
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ImageColor3=Color3.new(0,0,0),
ImageTransparency=0.4,
ZIndex=2,
}),


aj.NewRoundFrame(8,"Squircle",{
Size=UDim2.new(1,-r*2,1,-r*2),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageColor3=Color3.new(1,1,1),
ClipsDescendants=true,
ZIndex=3,
},{

ak("UIGradient",{
Color=m,
Rotation=45,
}),


ak("ImageLabel",{
Image=j,
Size=UDim2.new(0.65,0,0.65,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.45,0),
BackgroundTransparency=1,
ScaleType="Fit",
ZIndex=4,
}),


ak("TextLabel",{
Text=g,
Size=UDim2.new(0.5,0,0,12),
Position=UDim2.new(0,4,0,2),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(aj.Font,Enum.FontWeight.Bold),
TextSize=10,
TextStrokeTransparency=0,
TextStrokeColor3=Color3.new(0,0,0),
ZIndex=5,
}),


ak("TextLabel",{
Text=h,
Size=UDim2.new(0.5,-4,0,12),
Position=UDim2.new(1,-4,0,2),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Right,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(aj.Font,Enum.FontWeight.Bold),
TextSize=10,
TextStrokeTransparency=0,
TextStrokeColor3=Color3.new(0,0,0),
ZIndex=5,
}),


ak("Frame",{
Size=UDim2.new(1,0,0,20),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.4,
BorderSizePixel=0,
ZIndex=6,
},{

ak("TextLabel",{
Text=f,
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Center,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(aj.Font,Enum.FontWeight.Bold),
TextSize=9,
TextWrapped=true,
TextTruncate="AtEnd",
ZIndex=7,
}),
})
})
})
else
local e
if typeof(aB)=="table"then
e=aB.Image or aB.Icon or aB.Id or aB
else
e=aB
end
local f=aj.Image(
e,
tostring(e)..":"..ax.Name,
6,
am.Window.Folder,
"Dropdown",
false
)
f.Size=an.ImageSize or UDim2.new(0,30,0,30)
f.Parent=az
end
end
end
end

if ax.Locked then
ax.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0.6
if ax.UIElements.TabIcon then
ax.UIElements.TabIcon.ImageLabel.ImageTransparency=0.6
end
end

if an.Multi and typeof(an.Value)=="string"then
for az,aA in next,an.Values do
if typeof(aA)=="table"then
if aA.Title==an.Value then an.Value={aA}end
else
if aA==an.Value then an.Value={an.Value}end
end
end
end

if an.Multi then
local az=false
if typeof(an.Value)=="table"then
for aA,aB in ipairs(an.Value)do
local d=typeof(aB)=="table"and aB.Title or aB
if d==ax.Name then
az=true
break
end
end
end
ax.Selected=az
else
local az=typeof(an.Value)=="table"and an.Value.Title or an.Value
ax.Selected=az==ax.Name
end

if ax.Selected and not ax.Locked then
ax.UIElements.TabItem.ImageTransparency=.95
ax.UIElements.TabItem.Highlight.ImageTransparency=.75
ax.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0
if ax.UIElements.TabIcon then
ax.UIElements.TabIcon.ImageLabel.ImageTransparency=0
end
end

an.Tabs[av]=ax

ar:Display()

if aq=="Dropdown"then
aj.AddSignal(ax.UIElements.TabItem.MouseButton1Click,function()
if ax.Locked then return end

if an.Multi then
if not ax.Selected then
ax.Selected=true
al(ax.UIElements.TabItem,0.1,{ImageTransparency=.95}):Play()
al(ax.UIElements.TabItem.Highlight,0.1,{ImageTransparency=.75}):Play()
al(ax.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if ax.UIElements.TabIcon then
al(ax.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
table.insert(an.Value,ax.Original)
else
if not an.AllowNone and#an.Value==1 then
return
end
ax.Selected=false
al(ax.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
al(ax.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
al(ax.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=.4}):Play()
if ax.UIElements.TabIcon then
al(ax.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=.2}):Play()
end

for az,aA in next,an.Value do
if typeof(aA)=="table"and(aA.Title==ax.Name)or(aA==ax.Name)then
table.remove(an.Value,az)
break
end
end
end
else
for az,aA in next,an.Tabs do
al(aA.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
al(aA.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
al(aA.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=.4}):Play()
if aA.UIElements.TabIcon then
al(aA.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=.2}):Play()
end
aA.Selected=false
end
ax.Selected=true
al(ax.UIElements.TabItem,0.1,{ImageTransparency=.95}):Play()
al(ax.UIElements.TabItem.Highlight,0.1,{ImageTransparency=.75}):Play()
al(ax.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if ax.UIElements.TabIcon then
al(ax.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
an.Value=ax.Original
end
Callback()
end)
elseif aq=="Menu"then
if not ax.Locked then
aj.AddSignal(ax.UIElements.TabItem.MouseEnter,function()
al(ax.UIElements.TabItem,0.08,{ImageTransparency=.95}):Play()
end)
aj.AddSignal(ax.UIElements.TabItem.InputEnded,function()
al(ax.UIElements.TabItem,0.08,{ImageTransparency=1}):Play()
end)
end
aj.AddSignal(ax.UIElements.TabItem.MouseButton1Click,function()
if ax.Locked then return end
Callback(aw.Callback or function()end)
end)
end

RecalculateCanvasSize()
RecalculateListSize()
else a.load'I'
:New{Parent=an.UIElements.Menu.Frame.ScrollingFrame}
end
end

local av=an.MenuWidth or 0
if av==0 then
for aw,ax in next,an.Tabs do
if ax.UIElements.TabItem.Frame.UIListLayout then
av=math.max(av,ax.UIElements.TabItem.Frame.UIListLayout.AbsoluteContentSize.X)
end
end
end

an.UIElements.MenuCanvas.Size=UDim2.new(0,av+6+6+5+5+18+6+6,an.UIElements.MenuCanvas.Size.Y.Scale,an.UIElements.MenuCanvas.Size.Y.Offset)
Callback()

an.Values=au
end

ar:Refresh(an.Values)

function ar.Select(at,au)
if au then
an.Value=au
else
if an.Multi then
an.Value={}
else
an.Value=nil
end
end
ar:Refresh(an.Values)
end

RecalculateListSize()
RecalculateCanvasSize()

function ar.Open(at)
if ap then
an.UIElements.Menu.Visible=true
an.UIElements.MenuCanvas.Visible=true
an.UIElements.MenuCanvas.Active=true
an.UIElements.Menu.Size=UDim2.new(
1,0,
0,0
)
al(an.UIElements.Menu,0.1,{
Size=UDim2.new(
1,0,
1,0
),
ImageTransparency=0.05
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(.1)
an.Opened=true
end)

UpdatePosition()
end
end

function ar.Close(at)
an.Opened=false

al(an.UIElements.Menu,0.25,{
Size=UDim2.new(
1,0,
0,0
),
ImageTransparency=1,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(.1)
an.UIElements.Menu.Visible=false
end)

task.spawn(function()
task.wait(.25)
an.UIElements.MenuCanvas.Visible=false
an.UIElements.MenuCanvas.Active=false
end)
end

aj.AddSignal((an.UIElements.Dropdown and an.UIElements.Dropdown.MouseButton1Click or an.DropdownFrame.UIElements.Main.MouseButton1Click),function()
ar:Open()
end)

aj.AddSignal(ae.InputBegan,function(at)
if at.UserInputType==Enum.UserInputType.MouseButton1 or at.UserInputType==Enum.UserInputType.Touch then
local au=an.UIElements.MenuCanvas
local av,aw=au.AbsolutePosition,au.AbsoluteSize

local ax=an.UIElements.Dropdown or an.DropdownFrame.UIElements.Main
local ay=ax.AbsolutePosition
local az=ax.AbsoluteSize

local aA=
af.X>=ay.X and
af.X<=ay.X+az.X and
af.Y>=ay.Y and
af.Y<=ay.Y+az.Y

local aB=
af.X>=av.X and
af.X<=av.X+aw.X and
af.Y>=av.Y and
af.Y<=av.Y+aw.Y

if am.Window.CanDropdown and an.Opened and not aA and not aB then
ar:Close()
end
end
end)

aj.AddSignal(
an.UIElements.Dropdown and an.UIElements.Dropdown:GetPropertyChangedSignal"AbsolutePosition"or
an.DropdownFrame.UIElements.Main:GetPropertyChangedSignal"AbsolutePosition",
UpdatePosition
)

return ar
end

return aa end function a.K()
local aa=(cloneref or clonereference or function(aa)return aa end)

aa(game:GetService"UserInputService")
aa(game:GetService"Players").LocalPlayer:GetMouse()local ac=
aa(game:GetService"Workspace").CurrentCamera

local ae=a.load'b'
local af=ae.New local ag=
ae.Tween

local ah=a.load't'.New local ai=a.load'k'
.New
local aj=a.load'J'.New local ak=

workspace.CurrentCamera

local al={
UICorner=10,
UIPadding=12,
MenuCorner=15,
MenuPadding=5,
TabPadding=10,
SearchBarHeight=39,
TabIcon=18,
}

function al.New(am,an)
local ao={
__type="Dropdown",
Title=an.Title or"Dropdown",
Desc=an.Desc or nil,
Locked=an.Locked or false,
Values=an.Values or{},
MenuWidth=an.MenuWidth,
Value=an.Value,
AllowNone=an.AllowNone,
SearchBarEnabled=an.SearchBarEnabled or false,
Multi=an.Multi,
Callback=an.Callback or nil,

UIElements={},

Opened=false,
Tabs={},

Width=150,
}

if ao.Multi and not ao.Value then
ao.Value={}
end

local ap=true

ao.DropdownFrame=a.load'z'{
Title=ao.Title,
Desc=ao.Desc,
Image=an.Image,
ImageSize=an.ImageSize,
IconThemed=an.IconThemed,
Color=an.Color,
Parent=an.Parent,
TextOffset=ao.Callback and ao.Width or 20,
Hover=not ao.Callback and true or false,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=ao,
ParentConfig=an,
ParentType=an.ParentType,
}


if ao.Callback then
ao.UIElements.Dropdown=ah("",nil,ao.DropdownFrame.UIElements.Main,nil,an.Window.NewElements and 12 or 10)

ao.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate="AtEnd"
ao.UIElements.Dropdown.Frame.Frame.TextLabel.Size=UDim2.new(1,ao.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset-18-12-12,0,0)

ao.UIElements.Dropdown.Size=UDim2.new(0,ao.Width,0,36)
ao.UIElements.Dropdown.Position=UDim2.new(1,0,an.Window.NewElements and 0 or 0.5,0)
ao.UIElements.Dropdown.AnchorPoint=Vector2.new(1,an.Window.NewElements and 0 or 0.5)
end



function ao.SetMainImage(aq,ar)
if ao.DropdownFrame and ao.DropdownFrame.SetImage then
ao.DropdownFrame:SetImage(ar)
end
end


function ao.SetValueImage(aq,ar)
if ao.UIElements.Dropdown then
local as=ao.UIElements.Dropdown.Frame.Frame

local at=as:FindFirstChild"TextLabel"
local au=as:FindFirstChild"DynamicValueIcon"

if ar and ar~=""then
if not au then
au=af("ImageLabel",{
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

local av=ae.Icon(ar)
if av then
au.Image=av[1]
au.ImageRectSize=av[2].ImageRectSize
au.ImageRectOffset=av[2].ImageRectPosition
else
au.Image=ar
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


function ao.SetValueIcon(aq,ar)
ao:SetValueImage(ar)
end

ao.DropdownMenu=aj(an,ao,al,ap,"Dropdown")

ao.Display=ao.DropdownMenu.Display
ao.Refresh=ao.DropdownMenu.Refresh
ao.Select=ao.DropdownMenu.Select
ao.Open=ao.DropdownMenu.Open
ao.Close=ao.DropdownMenu.Close














af("ImageLabel",{
Image=ae.Icon"chevrons-up-down"[1],
ImageRectOffset=ae.Icon"chevrons-up-down"[2].ImageRectPosition,
ImageRectSize=ae.Icon"chevrons-up-down"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(
1,
ao.UIElements.Dropdown and-12 or 0,
0.5,
0
),
ThemeTag={
ImageColor3="Icon"
},
AnchorPoint=Vector2.new(1,0.5),
Parent=ao.UIElements.Dropdown and ao.UIElements.Dropdown.Frame or ao.DropdownFrame.UIElements.Main
})

function ao.Lock(aq)
ao.Locked=true
ap=false
return ao.DropdownFrame:Lock()
end
function ao.Unlock(aq)
ao.Locked=false
ap=true
return ao.DropdownFrame:Unlock()
end

if ao.Locked then
ao:Lock()
end local aq=


ao.UIElements.Dropdown and ao.UIElements.Dropdown.MouseButton1Click or ao.DropdownFrame.UIElements.Main.MouseButton1Click





local ar=ao.Open local as=
ao.Close






local function ForceUpwardsPosition()
local at=ao.UIElements.Dropdown or ao.DropdownFrame.UIElements.Main
local au=ao.UIElements.MenuCanvas



local av=at.AbsolutePosition.Y-au.AbsoluteSize.Y-5

au.Position=UDim2.new(
0,
at.AbsolutePosition.X+at.AbsoluteSize.X,
0,
av
)
end


ae.AddSignal(ao.UIElements.MenuCanvas:GetPropertyChangedSignal"AbsoluteSize",function()
if ao.Opened then ForceUpwardsPosition()end
end)
ae.AddSignal(ao.UIElements.MenuCanvas:GetPropertyChangedSignal"AbsolutePosition",function()


end)


ao.Open=function()
ar()

task.spawn(function()
RunService.RenderStepped:Wait()
ForceUpwardsPosition()
end)
end








ao.Open=function()
if ao.Opened then

ao.Close()
else

ar()
task.spawn(function()

RunService.RenderStepped:Wait()
ForceUpwardsPosition()
end)
end
end

return ao.__type,ao
end

return al end function a.L()






local aa={}
local ae={
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

local af={
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

local function createKeywordSet(ah)
local aj={}
for ak,al in ipairs(ah)do
aj[al]=true
end
return aj
end

local ah=createKeywordSet(ae.lua)
local aj=createKeywordSet(ae.rbx)
local ak=createKeywordSet(ae.operators)

local function getHighlight(al,am)
local an=al[am]

if af[an.."_color"]then
return af[an.."_color"]
end

if tonumber(an)then
return af.numbers
elseif an=="nil"then
return af.null
elseif an:sub(1,2)=="--"then
return af.comment
elseif ak[an]then
return af.operator
elseif ah[an]then
return af.lua
elseif aj[an]then
return af.rbx
elseif an:sub(1,1)=="\""or an:sub(1,1)=="\'"then
return af.str
elseif an=="true"or an=="false"then
return af.boolean
end

if al[am+1]=="("then
if al[am-1]==":"then
return af.self_call
end

return af.call
end

if al[am-1]=="."then
if al[am-2]=="Enum"then
return af.rbx
end

return af.local_property
end
end

function aa.run(al)
local am={}
local an=""

local ao=false
local ap=false
local ar=false

for as=1,#al do
local at=al:sub(as,as)

if ap then
if at=="\n"and not ar then
table.insert(am,an)
table.insert(am,at)
an=""

ap=false
elseif al:sub(as-1,as)=="]]"and ar then
an=an.."]"

table.insert(am,an)
an=""

ap=false
ar=false
else
an=an..at
end
elseif ao then
if at==ao and al:sub(as-1,as-1)~="\\"or at=="\n"then
an=an..at
ao=false
else
an=an..at
end
else
if al:sub(as,as+1)=="--"then
table.insert(am,an)
an="-"
ap=true
ar=al:sub(as+2,as+3)=="[["
elseif at=="\""or at=="\'"then
table.insert(am,an)
an=at
ao=at
elseif ak[at]then
table.insert(am,an)
table.insert(am,at)
an=""
elseif at:match"[%w_]"then
an=an..at
else
table.insert(am,an)
table.insert(am,at)
an=""
end
end
end

table.insert(am,an)

local as={}

for at,au in ipairs(am)do
local av=getHighlight(am,at)

if av then
local aw=string.format("<font color = \"#%s\">%s</font>",av:ToHex(),au:gsub("<","&lt;"):gsub(">","&gt;"))

table.insert(as,aw)
else
table.insert(as,au)
end
end

return table.concat(as)
end

return aa end function a.M()
local aa={}

local ae=a.load'b'
local af=ae.New
local ah=ae.Tween

local aj=a.load'L'

function aa.New(ak,al,am,an,ao)
local ap={
Radius=12,
Padding=10
}

local ar=af("TextLabel",{
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
af("UIPadding",{
PaddingTop=UDim.new(0,ap.Padding+3),
PaddingLeft=UDim.new(0,ap.Padding+3),
PaddingRight=UDim.new(0,ap.Padding+3),
PaddingBottom=UDim.new(0,ap.Padding+3),
})
})
ar.Font="Code"

local as=af("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticCanvasSize="X",
ScrollingDirection="X",
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
},{
ar
})

local at=af("TextButton",{
BackgroundTransparency=1,
Size=UDim2.new(0,30,0,30),
Position=UDim2.new(1,-ap.Padding/2,0,ap.Padding/2),
AnchorPoint=Vector2.new(1,0),
Visible=an and true or false,
},{
ae.NewRoundFrame(ap.Radius-4,"Squircle",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Button",
},{
af("UIScale",{
Scale=1,
}),
af("ImageLabel",{
Image=ae.Icon"copy"[1],
ImageRectSize=ae.Icon"copy"[2].ImageRectSize,
ImageRectOffset=ae.Icon"copy"[2].ImageRectPosition,
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Size=UDim2.new(0,12,0,12),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.1,
})
})
})

ae.AddSignal(at.MouseEnter,function()
ah(at.Button,.05,{ImageTransparency=.95}):Play()
ah(at.Button.UIScale,.05,{Scale=.9}):Play()
end)
ae.AddSignal(at.InputEnded,function()
ah(at.Button,.08,{ImageTransparency=1}):Play()
ah(at.Button.UIScale,.08,{Scale=1}):Play()
end)

local au=ae.NewRoundFrame(ap.Radius,"Squircle",{



ImageColor3=Color3.fromHex"#212121",
ImageTransparency=.035,
Size=UDim2.new(1,0,0,20+(ap.Padding*2)),
AutomaticSize="Y",
Parent=am,
},{
ae.NewRoundFrame(ap.Radius,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.955,
}),
af("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
},{
ae.NewRoundFrame(ap.Radius,"Squircle-TL-TR",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.96,
Size=UDim2.new(1,0,0,20+(ap.Padding*2)),
Visible=al and true or false
},{
af("ImageLabel",{
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Image="rbxassetid://132464694294269",



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.2,
}),
af("TextLabel",{
Text=al,



TextColor3=Color3.fromHex"#ffffff",
TextTransparency=.2,
TextSize=16,
AutomaticSize="Y",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
BackgroundTransparency=1,
TextTruncate="AtEnd",
Size=UDim2.new(1,at and-20-(ap.Padding*2),0,0)
}),
af("UIPadding",{

PaddingLeft=UDim.new(0,ap.Padding+3),
PaddingRight=UDim.new(0,ap.Padding+3),

}),
af("UIListLayout",{
Padding=UDim.new(0,ap.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
as,
af("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
})
}),
at,
})

ap.CodeFrame=au

ae.AddSignal(ar:GetPropertyChangedSignal"TextBounds",function()
as.Size=UDim2.new(1,0,0,(ar.TextBounds.Y/(ao or 1))+((ap.Padding+3)*2))
end)

function ap.Set(av)
ar.Text=aj.run(av)
end

function ap.Destroy()
au:Destroy()
ap=nil
end

ap.Set(ak)

ae.AddSignal(at.MouseButton1Click,function()
if an then
an()
local av=ae.Icon"check"
at.Button.ImageLabel.Image=av[1]
at.Button.ImageLabel.ImageRectSize=av[2].ImageRectSize
at.Button.ImageLabel.ImageRectOffset=av[2].ImageRectPosition

task.wait(1)
local aw=ae.Icon"copy"
at.Button.ImageLabel.Image=aw[1]
at.Button.ImageLabel.ImageRectSize=aw[2].ImageRectSize
at.Button.ImageLabel.ImageRectOffset=aw[2].ImageRectPosition
end
end)
return ap
end


return aa end function a.N()
local aa=a.load'b'local ae=
aa.New


local af=a.load'M'

local ah={}

function ah.New(aj,ak)
local al={
__type="Code",
Title=ak.Title,
Code=ak.Code,
OnCopy=ak.OnCopy,
}

local am=not al.Locked











local an=af.New(al.Code,al.Title,ak.Parent,function()
if am then
local an=al.Title or"code"
local ao,ap=pcall(function()
toclipboard(al.Code)

if al.OnCopy then al.OnCopy()end
end)
if not ao then
ak.ANUI:Notify{
Title="Error",
Content="The "..an.." is not copied. Error: "..ap,
Icon="x",
Duration=5,
}
end
end
end,ak.ANUI.UIScale,al)

function al.SetCode(ao,ap)
an.Set(ap)
al.Code=ap
end

function al.Destroy(ao)
an.Destroy()
al=nil
end

al.ElementFrame=an.CodeFrame

return al.__type,al
end

return ah end function a.O()
local aa=a.load'b'
local ae=aa.New local af=
aa.Tween

local ah=(cloneref or clonereference or function(ah)return ah end)

local aj=ah(game:GetService"UserInputService")
ah(game:GetService"TouchInputService")
local ak=ah(game:GetService"RunService")
local al=ah(game:GetService"Players")

local am=ak.RenderStepped
local an=al.LocalPlayer
local ao=an:GetMouse()

local ap=a.load'j'.New
local ar=a.load'k'.New

local as={
UICorner=9,

}

function as.Colorpicker(at,au,av,aw)
local ax={
__type="Colorpicker",
Title=au.Title,
Desc=au.Desc,
Default=au.Default,
Callback=au.Callback,
Transparency=au.Transparency,
UIElements=au.UIElements,

TextPadding=10,
}

function ax.SetHSVFromRGB(ay,az)
local aA,aB,d=Color3.toHSV(az)
ax.Hue=aA
ax.Sat=aB
ax.Vib=d
end

ax:SetHSVFromRGB(ax.Default)

local ay=a.load'l'.Init(av)
local az=ay.Create()

ax.ColorpickerFrame=az

az.UIElements.Main.Size=UDim2.new(1,0,0,0)



local aA,aB,d=ax.Hue,ax.Sat,ax.Vib

ax.UIElements.Title=ae("TextLabel",{
Text=ax.Title,
TextSize=20,
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=az.UIElements.Main
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,ax.TextPadding/2),
PaddingLeft=UDim.new(0,ax.TextPadding/2),
PaddingRight=UDim.new(0,ax.TextPadding/2),
PaddingBottom=UDim.new(0,ax.TextPadding/2),
})
})





local e=ae("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=HueDragHolder,
BackgroundColor3=ax.Default
},{
ae("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ae("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

ax.UIElements.SatVibMap=ae("ImageLabel",{
Size=UDim2.fromOffset(160,158),
Position=UDim2.fromOffset(0,40+ax.TextPadding),
Image="rbxassetid://4155801252",
BackgroundColor3=Color3.fromHSV(aA,1,1),
BackgroundTransparency=0,
Parent=az.UIElements.Main,
},{
ae("UICorner",{
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
ae("UIGradient",{
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

e,
})

ax.UIElements.Inputs=ae("Frame",{
AutomaticSize="XY",
Size=UDim2.new(0,0,0,0),
Position=UDim2.fromOffset(ax.Transparency and 240 or 210,40+ax.TextPadding),
BackgroundTransparency=1,
Parent=az.UIElements.Main
},{
ae("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Vertical",
})
})





local f=ae("Frame",{
BackgroundColor3=ax.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=ax.Transparency,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ae("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(85,208+ax.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=az.UIElements.Main,
},{
ae("UICorner",{
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
ae("UIGradient",{
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







f,
})

local g=ae("Frame",{
BackgroundColor3=ax.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=0,
ZIndex=9,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ae("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,208+ax.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=az.UIElements.Main,
},{
ae("UICorner",{
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
ae("UIGradient",{
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
g,
})

local h={}

for j=0,1,0.1 do
table.insert(h,ColorSequenceKeypoint.new(j,Color3.fromHSV(j,1,1)))
end

local j=ae("UIGradient",{
Color=ColorSequence.new(h),
Rotation=90,
})

local l=ae("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
})

local m=ae("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=l,


BackgroundColor3=ax.Default
},{
ae("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ae("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

local p=ae("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(180,40+ax.TextPadding),
Parent=az.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
j,
l,
})


function CreateNewInput(r,u)
local v=ar(r,nil,ax.UIElements.Inputs)

ae("TextLabel",{
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
Parent=v.Frame,
Text=r,
})

ae("UIScale",{
Parent=v,
Scale=.85,
})

v.Frame.Frame.TextBox.Text=u
v.Size=UDim2.new(0,150,0,42)

return v
end

local function ToRGB(r)
return{
R=math.floor(r.R*255),
G=math.floor(r.G*255),
B=math.floor(r.B*255)
}
end

local r=CreateNewInput("Hex","#"..ax.Default:ToHex())

local u=CreateNewInput("Red",ToRGB(ax.Default).R)
local v=CreateNewInput("Green",ToRGB(ax.Default).G)
local x=CreateNewInput("Blue",ToRGB(ax.Default).B)
local z
if ax.Transparency then
z=CreateNewInput("Alpha",((1-ax.Transparency)*100).."%")
end

local A=ae("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="Y",
Position=UDim2.new(0,0,0,254+ax.TextPadding),
BackgroundTransparency=1,
Parent=az.UIElements.Main,
LayoutOrder=4,
},{
ae("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
}),






})

local B={
{
Title="Cancel",
Variant="Secondary",
Callback=function()end
},
{
Title="Apply",
Icon="chevron-right",
Variant="Primary",
Callback=function()aw(Color3.fromHSV(ax.Hue,ax.Sat,ax.Vib),ax.Transparency)end
}
}

for C,F in next,B do
local G=ap(F.Title,F.Icon,F.Callback,F.Variant,A,az,false)
G.Size=UDim2.new(0.5,-3,0,40)
G.AutomaticSize="None"
end



local C,F,G
if ax.Transparency then
local H=ae("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.fromOffset(0,0),
BackgroundTransparency=1,
})

F=ae("ImageLabel",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
ThemeTag={
BackgroundColor3="Text",
},
Parent=H,

},{
ae("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ae("UICorner",{
CornerRadius=UDim.new(1,0),
})

})

G=ae("Frame",{
Size=UDim2.fromScale(1,1),
},{
ae("UIGradient",{
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
},
Rotation=270,
}),
ae("UICorner",{
CornerRadius=UDim.new(0,6),
}),
})

C=ae("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(210,40+ax.TextPadding),
Parent=az.UIElements.Main,
BackgroundTransparency=1,
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
ae("ImageLabel",{
Image="rbxassetid://14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
G,
H,
})
end

function ax.Round(H,J,L)
if L==0 then
return math.floor(J)
end
J=tostring(J)
return J:find"%."and tonumber(J:sub(1,J:find"%."+L))or J
end


function ax.Update(H,J,L)
if J then aA,aB,d=Color3.toHSV(J)else aA,aB,d=ax.Hue,ax.Sat,ax.Vib end

ax.UIElements.SatVibMap.BackgroundColor3=Color3.fromHSV(aA,1,1)
e.Position=UDim2.new(aB,0,1-d,0)
e.BackgroundColor3=Color3.fromHSV(aA,aB,d)
g.BackgroundColor3=Color3.fromHSV(aA,aB,d)
m.BackgroundColor3=Color3.fromHSV(aA,1,1)
m.Position=UDim2.new(0.5,0,aA,0)

r.Frame.Frame.TextBox.Text="#"..Color3.fromHSV(aA,aB,d):ToHex()
u.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(aA,aB,d)).R
v.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(aA,aB,d)).G
x.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(aA,aB,d)).B

if L or ax.Transparency then
g.BackgroundTransparency=ax.Transparency or L
G.BackgroundColor3=Color3.fromHSV(aA,aB,d)
F.BackgroundColor3=Color3.fromHSV(aA,aB,d)
F.BackgroundTransparency=ax.Transparency or L
F.Position=UDim2.new(0.5,0,1-ax.Transparency or L,0)
z.Frame.Frame.TextBox.Text=ax:Round((1-ax.Transparency or L)*100,0).."%"
end
end

ax:Update(ax.Default,ax.Transparency)




local function GetRGB()
local H=Color3.fromHSV(ax.Hue,ax.Sat,ax.Vib)
return{R=math.floor(H.r*255),G=math.floor(H.g*255),B=math.floor(H.b*255)}
end



local function clamp(H,J,L)
return math.clamp(tonumber(H)or 0,J,L)
end

aa.AddSignal(r.Frame.Frame.TextBox.FocusLost,function(H)
if H then
local J=r.Frame.Frame.TextBox.Text:gsub("#","")
local L,M=pcall(Color3.fromHex,J)
if L and typeof(M)=="Color3"then
ax.Hue,ax.Sat,ax.Vib=Color3.toHSV(M)
ax:Update()
ax.Default=M
end
end
end)

local function updateColorFromInput(H,J)
aa.AddSignal(H.Frame.Frame.TextBox.FocusLost,function(L)
if L then
local M=H.Frame.Frame.TextBox
local N=GetRGB()
local O=clamp(M.Text,0,255)
M.Text=tostring(O)

N[J]=O
local P=Color3.fromRGB(N.R,N.G,N.B)
ax.Hue,ax.Sat,ax.Vib=Color3.toHSV(P)
ax:Update()
end
end)
end

updateColorFromInput(u,"R")
updateColorFromInput(v,"G")
updateColorFromInput(x,"B")

if ax.Transparency then
aa.AddSignal(z.Frame.Frame.TextBox.FocusLost,function(H)
if H then
local J=z.Frame.Frame.TextBox
local L=clamp(J.Text,0,100)
J.Text=tostring(L)

ax.Transparency=1-L*0.01
ax:Update(nil,ax.Transparency)
end
end)
end



local H=ax.UIElements.SatVibMap
aa.AddSignal(H.InputBegan,function(J)
if J.UserInputType==Enum.UserInputType.MouseButton1 or J.UserInputType==Enum.UserInputType.Touch then
while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local L=H.AbsolutePosition.X
local M=L+H.AbsoluteSize.X
local N=math.clamp(ao.X,L,M)

local O=H.AbsolutePosition.Y
local P=O+H.AbsoluteSize.Y
local Q=math.clamp(ao.Y,O,P)

ax.Sat=(N-L)/(M-L)
ax.Vib=1-((Q-O)/(P-O))
ax:Update()

am:Wait()
end
end
end)

aa.AddSignal(p.InputBegan,function(J)
if J.UserInputType==Enum.UserInputType.MouseButton1 or J.UserInputType==Enum.UserInputType.Touch then
while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local L=p.AbsolutePosition.Y
local M=L+p.AbsoluteSize.Y
local N=math.clamp(ao.Y,L,M)

ax.Hue=((N-L)/(M-L))
ax:Update()

am:Wait()
end
end
end)

if ax.Transparency then
aa.AddSignal(C.InputBegan,function(J)
if J.UserInputType==Enum.UserInputType.MouseButton1 or J.UserInputType==Enum.UserInputType.Touch then
while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local L=C.AbsolutePosition.Y
local M=L+C.AbsoluteSize.Y
local N=math.clamp(ao.Y,L,M)

ax.Transparency=1-((N-L)/(M-L))
ax:Update()

am:Wait()
end
end
end)
end

return ax
end

function as.New(at,au)
local av={
__type="Colorpicker",
Title=au.Title or"Colorpicker",
Desc=au.Desc or nil,
Locked=au.Locked or false,
Default=au.Default or Color3.new(1,1,1),
Callback=au.Callback or function()end,

UIScale=au.UIScale,
Transparency=au.Transparency,
UIElements={}
}

local aw=true



av.ColorpickerFrame=a.load'z'{
Title=av.Title,
Desc=av.Desc,
Parent=au.Parent,
TextOffset=40,
Hover=false,
Tab=au.Tab,
Index=au.Index,
Window=au.Window,
ElementTable=av,
ParentConfig=au,
}

av.UIElements.Colorpicker=aa.NewRoundFrame(as.UICorner,"Squircle",{
ImageTransparency=0,
Active=true,
ImageColor3=av.Default,
Parent=av.ColorpickerFrame.UIElements.Main,
Size=UDim2.new(0,26,0,26),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
ZIndex=2
},nil,true)


function av.Lock(ax)
av.Locked=true
aw=false
return av.ColorpickerFrame:Lock()
end
function av.Unlock(ax)
av.Locked=false
aw=true
return av.ColorpickerFrame:Unlock()
end

if av.Locked then
av:Lock()
end


function av.Update(ax,ay,az)
av.UIElements.Colorpicker.ImageTransparency=az or 0
av.UIElements.Colorpicker.ImageColor3=ay
av.Default=ay
if az then
av.Transparency=az
end
end

function av.Set(ax,ay,az)
return av:Update(ay,az)
end

aa.AddSignal(av.UIElements.Colorpicker.MouseButton1Click,function()
if aw then
as:Colorpicker(av,au.Window,function(ax,ay)
av:Update(ax,ay)
av.Default=ax
av.Transparency=ay
aa.SafeCallback(av.Callback,ax,ay)
end).ColorpickerFrame:Open()
end
end)

return av.__type,av
end

return as end function a.P()
local aa=a.load'b'
local ae=aa.New
local af=aa.Tween

local ah={}

function ah.New(aj,ak)
local al={
__type="Section",
Title=ak.Title or"Section",
Icon=ak.Icon,
TextXAlignment=ak.TextXAlignment or"Left",
TextSize=ak.TextSize or 19,
Box=ak.Box or false,
FontWeight=ak.FontWeight or Enum.FontWeight.SemiBold,
TextTransparency=ak.TextTransparency or 0.05,
Opened=ak.Opened or false,
UIElements={},

HeaderSize=42,
IconSize=20,
Padding=10,

Elements={},

Expandable=false,
}

local am


function al.SetIcon(an,ao)
al.Icon=ao or nil
if am then am:Destroy()end
if ao then
am=aa.Image(
ao,
ao..":"..al.Title,
0,
ak.Window.Folder,
al.__type,
true
)
am.Size=UDim2.new(0,al.IconSize,0,al.IconSize)
end
end

local an=ae("Frame",{
Size=UDim2.new(0,al.IconSize,0,al.IconSize),
BackgroundTransparency=1,
Visible=false
},{
ae("ImageLabel",{
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


if al.Icon then
al:SetIcon(al.Icon)
end

local ao=ae("TextLabel",{
BackgroundTransparency=1,
TextXAlignment=al.TextXAlignment,
AutomaticSize="Y",
TextSize=al.TextSize,
TextTransparency=al.TextTransparency,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(aa.Font,al.FontWeight),


Text=al.Title,
Size=UDim2.new(
1,
0,
0,
0
),
TextWrapped=true,
})


local function UpdateTitleSize()
local ap=0
if am then
ap=ap-(al.IconSize+8)
end
if an.Visible then
ap=ap-(al.IconSize+8)
end
ao.Size=UDim2.new(1,ap,0,0)
end


local ap=aa.NewRoundFrame(ak.Window.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Parent=ak.Parent,
ClipsDescendants=true,
AutomaticSize="Y",
ImageTransparency=al.Box and.93 or 1,
ThemeTag={
ImageColor3="Text",
},
},{
ae("TextButton",{
Size=UDim2.new(1,0,0,Expandable and 0 or al.HeaderSize),
BackgroundTransparency=1,
AutomaticSize=Expandable and nil or"Y",
Text="",
Name="Top",
},{
al.Box and ae("UIPadding",{
PaddingLeft=UDim.new(0,ak.Window.ElementConfig.UIPadding),
PaddingRight=UDim.new(0,ak.Window.ElementConfig.UIPadding),
})or nil,
am,
ao,
ae("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
an,
}),
ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=false,
Position=UDim2.new(0,0,0,al.HeaderSize)
},{
al.Box and ae("UIPadding",{
PaddingLeft=UDim.new(0,ak.Window.ElementConfig.UIPadding),
PaddingRight=UDim.new(0,ak.Window.ElementConfig.UIPadding),
PaddingBottom=UDim.new(0,ak.Window.ElementConfig.UIPadding),
})or nil,
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ak.Tab.Gap),
VerticalAlignment="Top",
}),
})
})

al.ElementFrame=ap







local ar=ak.ElementsModule

ar.Load(al,ap.Content,ar.Elements,ak.Window,ak.ANUI,function()
if not al.Expandable then
al.Expandable=true
an.Visible=true
UpdateTitleSize()
end
end,ar,ak.UIScale,ak.Tab)


UpdateTitleSize()

function al.SetTitle(as,at)
ao.Text=at
end

function al.Destroy(as)
for at,au in next,al.Elements do
au:Destroy()
end








ap:Destroy()
end

function al.Open(as)
if al.Expandable then
al.Opened=true
af(ap,0.33,{
Size=UDim2.new(1,0,0,al.HeaderSize+(ap.Content.AbsoluteSize.Y/ak.UIScale))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

af(an.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function al.Close(as)
if al.Expandable then
al.Opened=false
af(ap,0.26,{
Size=UDim2.new(1,0,0,al.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
af(an.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

aa.AddSignal(ap.Top.MouseButton1Click,function()
if al.Expandable then
if al.Opened then
al:Close()
else
al:Open()
end
end
end)

aa.AddSignal(ap.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if al.Opened then
al:Open()
end
end)

task.spawn(function()
task.wait(0.02)
if al.Expandable then








ap.Size=UDim2.new(1,0,0,al.HeaderSize)
ap.AutomaticSize="None"
ap.Top.Size=UDim2.new(1,0,0,al.HeaderSize)
ap.Top.AutomaticSize="None"
ap.Content.Visible=true
end
if al.Opened then
al:Open()
end

end)

return al.__type,al
end

return ah end function a.Q()
local aa=a.load'b'
local ae=aa.New

local af={}

function af.New(ah,aj)
local ak=ae("Frame",{
Parent=aj.Parent,
Size=aj.ParentType~="Group"and UDim2.new(1,-7,0,7*(aj.Columns or 1))or UDim2.new(0,7*(aj.Columns or 1),0,0),
BackgroundTransparency=1,
})

return"Space",{__type="Space",ElementFrame=ak}
end

return af end function a.R()
local aa=a.load'b'
local ae=aa.New

local af={}

local function ParseAspectRatio(ah)
if type(ah)=="string"then
local aj,ak=ah:match"(%d+):(%d+)"
if aj and ak then
return tonumber(aj)/tonumber(ak)
end
elseif type(ah)=="number"then
return ah
end
return nil
end

function af.New(ah,aj)
local ak={
__type="Image",
Image=aj.Image or"",
AspectRatio=aj.AspectRatio or"16:9",
Radius=aj.Radius or aj.Window.ElementConfig.UICorner,
}
local al=aa.Image(
ak.Image,
ak.Image,
ak.Radius,
aj.Window.Folder,
"Image",
false
)
al.Parent=aj.Parent
al.Size=UDim2.new(1,0,0,0)
al.BackgroundTransparency=1












local am=ParseAspectRatio(ak.AspectRatio)
local an

if am then
an=ae("UIAspectRatioConstraint",{
Parent=al,
AspectRatio=am,
AspectType="ScaleWithParentSize",
DominantAxis="Width"
})
end

function ak.Destroy(ao)
al:Destroy()
end

return ak.__type,ak
end

return af end function a.S()
local aa=a.load'b'
local ae=aa.New

local af={}

function af.New(ah,aj)
local ak={
__type="Group",
Elements={}
}

local al=ae("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=aj.Parent,
},{
ae("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Center",
VerticalAlignment="Center",
Padding=UDim.new(0,aj.Tab and aj.Tab.Gap or((aj.Window and aj.Window.NewElements)and 1 or 6))
}),
})

ak.GroupFrame=al

local am=aj.ElementsModule
am.Load(
ak,
al,
am.Elements,
aj.Window,
aj.ANUI,
function(an,ao)
local ap=aj.Tab and aj.Tab.Gap or((aj.Window and aj.Window.NewElements)and 1 or 6)

local ar={}
local as=0

for at,au in next,ao do
if au.__type=="Space"then
as=as+(au.ElementFrame.Size.X.Offset or 6)
elseif au.__type=="Divider"then
as=as+(au.ElementFrame.Size.X.Offset or 1)
else
table.insert(ar,au)
end
end

local at=#ar
if at==0 then return end

local au=al.AbsoluteSize.X
local av
if au and au>0 then
local aw=ap*(at-1)
local ax=math.max(au-aw-as,0)
av=(ax/au)/at
else
av=1/at
end

for aw,ax in next,ar do
if ax.ElementFrame then
ax.ElementFrame.Size=UDim2.new(av,0,1,0)
end
end
end,
am,
aj.UIScale,
aj.Tab
)



return ak.__type,ak
end

return af end function a.T()

local aa=a.load'b'
local ae=aa.New
local af=aa.Tween

local ah={}

function ah.New(aj,ak)
local al={
__type="Category",
Title=ak.Title,
Desc=ak.Desc,
Options=ak.Options or{},
Default=ak.Default,
Callback=ak.Callback or function()end,
Parent=ak.Parent,
UIElements={},
}



local am=ae("Frame",{
Size=UDim2.new(1,0,0,45),
BackgroundTransparency=1,
Parent=ak.Parent,
})


local an=ae("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScrollingDirection=Enum.ScrollingDirection.X,
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize=Enum.AutomaticSize.X,
Parent=am,
},{
ae("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,8),
VerticalAlignment=Enum.VerticalAlignment.Center,
}),
ae("UIPadding",{
PaddingLeft=UDim.new(0,2),
PaddingRight=UDim.new(0,2),
})
})

local ao={}

local function UpdateVisuals(ap)
for ar,as in pairs(ao)do
local at=(ar==ap)
local au=aa.Theme

local av=aa.GetThemeProperty(at and"Toggle"or"Button",au)
local aw=aa.GetThemeProperty("Text",au)
local ax=at and 0 or 0.5

af(as.Background,0.2,{ImageColor3=av}):Play()
af(as.Title,0.2,{TextTransparency=ax,TextColor3=aw}):Play()

if as.Icon then
af(as.Icon.ImageLabel,0.2,{ImageTransparency=ax,ImageColor3=aw}):Play()
end
end
end

for ap,ar in ipairs(al.Options)do
local as=(type(ar)=="table"and ar.Title)or ar
local at=(type(ar)=="table"and ar.Icon)or nil

local au=ae("TextButton",{
AutoButtonColor=false,
Size=UDim2.new(0,0,0,32),
AutomaticSize=Enum.AutomaticSize.X,
BackgroundTransparency=1,
Text="",
Parent=an,
LayoutOrder=ap
})

local av=aa.NewRoundFrame(8,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={ImageColor3="Button"},
Name="Background",
Parent=au
},{
ae("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
VerticalAlignment=Enum.VerticalAlignment.Center,
Padding=UDim.new(0,6),
HorizontalAlignment=Enum.HorizontalAlignment.Center,
}),
ae("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
})
})

local aw
if at then
aw=aa.Image(at,"Icon",0,ak.Window.Folder,"Icon",false)
aw.Size=UDim2.new(0,18,0,18)
aw.BackgroundTransparency=1
aw.ImageLabel.ImageTransparency=0.5
aw.Parent=av
end

local ax=ae("TextLabel",{
Text=as,
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
TextSize=14,
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.XY,
ThemeTag={TextColor3="Text"},
TextTransparency=0.5,
Parent=av
})

ao[as]={
Frame=au,
Background=av,
Title=ax,
Icon=aw
}

aa.AddSignal(au.MouseButton1Click,function()
UpdateVisuals(as)
if al.Callback then
al.Callback(as)
end
end)
end

if al.Default then
UpdateVisuals(al.Default)
elseif al.Options[1]then
local ap=al.Options[1]
local ar=(type(ap)=="table"and ap.Title)or ap
UpdateVisuals(ar)
end


al.ElementFrame=am
return al.__type,al
end

return ah end function a.U()
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
Load=function(aa,ae,af,ah,aj,ak,al,am,an)
for ao,ap in next,af do
aa[ao]=function(ar,as)
as=as or{}
as.Tab=an or aa
as.ParentType=aa.__type
as.ParentTable=aa
as.Index=#aa.Elements+1
as.GlobalIndex=#ah.AllElements+1
as.Parent=ae
as.Window=ah
as.ANUI=aj
as.UIScale=am
as.ElementsModule=al local

at, au=ap:New(as)

if as.Flag and typeof(as.Flag)=="string"then
if ah.CurrentConfig then
ah.CurrentConfig:Register(as.Flag,au)

if ah.PendingConfigData and ah.PendingConfigData[as.Flag]then
local av=ah.PendingConfigData[as.Flag]

local aw=ah.ConfigManager
if aw.Parser[av.__type]then
task.defer(function()
local ax,ay=pcall(function()
aw.Parser[av.__type].Load(au,av)
end)

if ax then
ah.PendingConfigData[as.Flag]=nil
else
warn("[ ANUI ] Failed to apply pending config for '"..as.Flag.."': "..tostring(ay))
end
end)
end
end
else
ah.PendingFlags=ah.PendingFlags or{}
ah.PendingFlags[as.Flag]=au
end
end

local av
for aw,ax in pairs(au)do
if typeof(ax)=="table"and aw:match"Frame$"then
av=ax
break
end
end

if av then
au.ElementFrame=av.UIElements.Main
function au.SetTitle(aw,ax)
av:SetTitle(ax)
end
function au.SetDesc(aw,ax)
av:SetDesc(ax)
end
function au.SetImage(aw,ax,ay)
av:SetImage(ax,ay)
end
function au.SetIcon(aw,ax,ay)
av:SetImage(ax,ay)
end
function au.Highlight(aw)
av:Highlight()
end
function au.Destroy(aw)
av:Destroy()

table.remove(ah.AllElements,as.GlobalIndex)
table.remove(aa.Elements,as.Index)
table.remove(an.Elements,as.Index)
aa:UpdateAllElementShapes(aa)
end
end



ah.AllElements[as.Index]=au
aa.Elements[as.Index]=au
if an then an.Elements[as.Index]=au end

if ah.NewElements then
aa:UpdateAllElementShapes(aa)
end

if ak then
ak(au,aa.Elements)
end
return au
end
end
function aa.UpdateAllElementShapes(ao,ap)
for ar,as in next,ap.Elements do
local at
for au,av in pairs(as)do
if typeof(av)=="table"and au:match"Frame$"then
at=av
break
end
end

if at then

at.Index=ar
if at.UpdateShape then

at.UpdateShape(ap)
end
end
end
end
end,

}end function a.V()

local aa=(cloneref or clonereference or function(aa)return aa end)

aa(game:GetService"UserInputService")
local ae=game.Players.LocalPlayer:GetMouse()

local af=a.load'b'
local ah=af.New
local aj=af.Tween

local ak=a.load'y'.New
local al=a.load'u'.New



local am={
Tabs={},
Containers={},
SelectedTab=nil,
TabCount=0,
ToolTipParent=nil,
TabHighlight=nil,

OnChangeFunc=function(am)end
}

function am.Init(an,ao,ap,ar)
Window=an
ANUI=ao
am.ToolTipParent=ap
am.TabHighlight=ar
return am
end

function am.New(an,ao)
local ap={
__type="Tab",
Title=an.Title or"Tab",
Desc=an.Desc,
Icon=an.Icon,
Image=an.Image,
IconThemed=an.IconThemed,
Locked=an.Locked,
ShowTabTitle=an.ShowTabTitle,

Profile=an.Profile,
SidebarProfile=an.SidebarProfile,

Selected=false,
Index=nil,
Parent=an.Parent,
UIElements={},
Elements={},
ContainerFrame=nil,
UICorner=Window.UICorner-(Window.UIPadding/2),

Gap=Window.NewElements and 1 or 6,
}

local ar=ap.Profile and ap.SidebarProfile
local as=ap.Profile


local at=as and(ap.Profile.Sticky~=false)

if ar then
ap.Locked=true
end

am.TabCount=am.TabCount+1

local au=am.TabCount
ap.Index=au


ap.UIElements.Main=af.NewRoundFrame(ap.UICorner,"Squircle",{
BackgroundTransparency=1,
Size=UDim2.new(1,-7,0,0),
AutomaticSize="Y",
Parent=an.Parent,
ThemeTag={
ImageColor3="TabBackground",
},
ImageTransparency=1,
},{
af.NewRoundFrame(ap.UICorner,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline"
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
af.NewRoundFrame(ap.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Frame",
ClipsDescendants=true,
},{
ah("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ah("TextLabel",{
Text=ap.Title,
ThemeTag={
TextColor3="TabTitle"
},
TextTransparency=not ap.Locked and 0.4 or.7,
TextSize=15,
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(af.Font,Enum.FontWeight.Medium),
TextWrapped=true,
RichText=true,
AutomaticSize="Y",
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
}),
ah("UIPadding",{
PaddingTop=UDim.new(0,2+(Window.UIPadding/2)),
PaddingLeft=UDim.new(0,4+(Window.UIPadding/2)),
PaddingRight=UDim.new(0,4+(Window.UIPadding/2)),
PaddingBottom=UDim.new(0,2+(Window.UIPadding/2)),
})
}),
},true)

local av=0
local aw
local ax


if ap.Icon and not ar then
aw=af.Image(ap.Icon,ap.Icon..":"..ap.Title,0,Window.Folder,ap.__type,true,ap.IconThemed,"TabIcon")
aw.Size=UDim2.new(0,16,0,16)
aw.Parent=ap.UIElements.Main.Frame
aw.ImageLabel.ImageTransparency=not ap.Locked and 0 or.7
ap.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,-30,0,0)
av=-30
ap.UIElements.Icon=aw

ax=af.Image(ap.Icon,ap.Icon..":"..ap.Title,0,Window.Folder,ap.__type,true,ap.IconThemed)
ax.Size=UDim2.new(0,16,0,16)
ax.ImageLabel.ImageTransparency=not ap.Locked and 0 or.7
av=-30
end


if ap.Image and not ar then
local ay=af.Image(ap.Image,ap.Title,ap.UICorner,Window.Folder,"TabImage",false)
ay.Size=UDim2.new(1,0,0,100)
ay.Parent=ap.UIElements.Main.Frame
ay.ImageLabel.ImageTransparency=not ap.Locked and 0 or.7
ay.LayoutOrder=-1

ap.UIElements.Main.Frame.UIListLayout.FillDirection="Vertical"
ap.UIElements.Main.Frame.UIListLayout.Padding=UDim.new(0,0)
ap.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,0,0,30)
ap.UIElements.Main.Frame.TextLabel.TextXAlignment="Center"
ap.UIElements.Main.Frame.UIPadding.PaddingTop=UDim.new(0,0)
ap.UIElements.Main.Frame.UIPadding.PaddingLeft=UDim.new(0,0)
ap.UIElements.Main.Frame.UIPadding.PaddingRight=UDim.new(0,0)
ap.UIElements.Main.Frame.UIPadding.PaddingBottom=UDim.new(0,0)

ap.UIElements.Image=ay
end


if ar then
local ay=ap.UIElements.Main.Frame:FindFirstChild"UIListLayout"
if ay then ay:Destroy()end
local az=ap.UIElements.Main.Frame:FindFirstChild"UIPadding"
if az then az:Destroy()end
local aA=ap.UIElements.Main.Frame:FindFirstChild"TextLabel"
if aA then aA:Destroy()end

ap.UIElements.Main.Frame.AutomaticSize=Enum.AutomaticSize.None
ap.UIElements.Main.Frame.Size=UDim2.new(1,0,0,120)

local aB=55
if ap.Profile.Banner then
local d=af.Image(
ap.Profile.Banner,"SidebarBanner",0,Window.Folder,"ProfileBanner",false
)
d.Size=UDim2.new(1,0,0,aB)
d.Position=UDim2.new(0,0,0,0)
d.BackgroundTransparency=1
d.Parent=ap.UIElements.Main.Frame
d.ZIndex=1

if d:FindFirstChild"ImageLabel"then
d.ImageLabel.ScaleType=Enum.ScaleType.Crop
d.ImageLabel.Size=UDim2.fromScale(1,1)
end
end


if ap.Profile.Badges then
local d=ah("Frame",{
Name="SidebarBadgeContainer",
Size=UDim2.new(0,0,0,24),
AutomaticSize=Enum.AutomaticSize.X,
Position=UDim2.new(1,-6,0,aB-4),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
Parent=ap.UIElements.Main.Frame,
ZIndex=5
},{
ah("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
HorizontalAlignment=Enum.HorizontalAlignment.Right,
VerticalAlignment=Enum.VerticalAlignment.Center,
Padding=UDim.new(0,4)
})
})

for e,f in ipairs(ap.Profile.Badges)do
local g=f.Icon or"help-circle"
local h=f.Title~=nil

local j=ah("Frame",{
Name="BadgeWrapper",
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,24),
AutomaticSize=Enum.AutomaticSize.X,
Parent=d,
})

local l=af.NewRoundFrame(6,"Squircle",{
ImageColor3=Color3.new(0,0,0),
ImageTransparency=0.4,
Size=UDim2.new(1,0,1,0),
Name="BG",
Parent=j
})

local m=ah("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Parent=j
},{
ah("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
VerticalAlignment=Enum.VerticalAlignment.Center,
HorizontalAlignment=Enum.HorizontalAlignment.Center,
Padding=UDim.new(0,4)
}),
ah("UIPadding",{
PaddingLeft=UDim.new(0,h and 6 or 4),
PaddingRight=UDim.new(0,h and 6 or 4),
})
})

local p=af.Image(g,"BadgeIcon",0,Window.Folder,"Badge",false)
p.Size=UDim2.new(0,14,0,14)
p.BackgroundTransparency=1
p.Parent=m

local r=p:FindFirstChild"ImageLabel"or p:FindFirstChild"VideoFrame"
if r then
r.Size=UDim2.fromScale(1,1)
r.ImageColor3=Color3.new(1,1,1)
r.BackgroundTransparency=1
end

if h then
ah("TextLabel",{
Text=f.Title,
TextSize=11,
FontFace=Font.new(af.Font,Enum.FontWeight.SemiBold),
TextColor3=Color3.new(1,1,1),
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.XY,
LayoutOrder=2,
Parent=m
})
end

local u=ah("TextButton",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Text="",
ZIndex=10,
Parent=j
})

if f.Callback then
af.AddSignal(u.MouseButton1Click,function()
f.Callback()
end)
end

af.AddSignal(u.MouseEnter,function()
aj(l,0.1,{ImageTransparency=0.2}):Play()
end)
af.AddSignal(u.MouseLeave,function()
aj(l,0.1,{ImageTransparency=0.4}):Play()
end)

if f.Desc then
local v
local x
local z
local A=false

af.AddSignal(u.MouseEnter,function()
A=true
x=task.spawn(function()
task.wait(0.35)
if A and not v then
v=ak(f.Desc,am.ToolTipParent)
local function updatePosition()
if v then
v.Container.Position=UDim2.new(0,ae.X,0,ae.Y-20)
end
end
updatePosition()
z=ae.Move:Connect(updatePosition)
v:Open()
end
end)
end)

af.AddSignal(u.MouseLeave,function()
A=false
if x then task.cancel(x)x=nil end
if z then z:Disconnect()z=nil end
if v then v:Close()v=nil end
end)
end
end
end

local d=46
local e=ah("Frame",{
Name="Avatar",
Size=UDim2.new(0,d,0,d),
Position=UDim2.new(0,10,0,aB-(d/2)),
BackgroundTransparency=1,
Parent=ap.UIElements.Main.Frame,
ZIndex=2
})

if ap.Profile.Avatar then
local f=af.Image(
ap.Profile.Avatar,"SidebarAvatar",0,Window.Folder,"ProfileAvatar",false
)
f.Size=UDim2.fromScale(1,1)
f.Parent=e
f.BackgroundTransparency=1

local g=f:FindFirstChild"ImageLabel"
if g then
g.Size=UDim2.fromScale(1,1)
g.BackgroundTransparency=1
local h=g:FindFirstChildOfClass"UICorner"
if h then h:Destroy()end
ah("UICorner",{CornerRadius=UDim.new(1,0),Parent=g})
end

ah("UIStroke",{
Parent=e,
Thickness=2.5,
ThemeTag={Color="TabBackground"},
Transparency=0,
ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})
ah("UICorner",{CornerRadius=UDim.new(1,0),Parent=e})
end

if ap.Profile.Status then
ah("Frame",{
Size=UDim2.new(0,12,0,12),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundColor3=Color3.fromHex"#23a559",
Parent=e,
ZIndex=3
},{
ah("UICorner",{CornerRadius=UDim.new(1,0)}),
ah("UIStroke",{
Thickness=2,
ThemeTag={Color="TabBackground"}
})
})
end

ah("Frame",{
Size=UDim2.new(1,-(10+d+8),1,-aB-6),
Position=UDim2.new(0,10+d+8,0,aB+5),
BackgroundTransparency=1,
Parent=ap.UIElements.Main.Frame,
ZIndex=2
},{
ah("UIListLayout",{
VerticalAlignment=Enum.VerticalAlignment.Top,
Padding=UDim.new(0,2)
}),
ah("TextLabel",{
Text=ap.Profile.Title or ap.Title,
TextSize=16,
FontFace=Font.new(af.Font,Enum.FontWeight.Bold),
ThemeTag={TextColor3="TabTitle"},
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,18),
TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,
TextTransparency=not ap.Locked and 0 or.7,
}),
ah("TextLabel",{
Text=ap.Profile.Desc or"User",
TextSize=13,
FontFace=Font.new(af.Font,Enum.FontWeight.Regular),
ThemeTag={TextColor3="Text"},
TextTransparency=0.5,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,14),
TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd
})
})
end


local ay=0
local az=0

local aA=150

if ap.ShowTabTitle then
ay=((Window.UIPadding*2.4)+12)
az=az-ay
end


if as and at then
ay=ay+aA
az=az-aA
end


ap.UIElements.ContainerFrame=ah("ScrollingFrame",{
Size=UDim2.new(1,0,1,az),
Position=UDim2.new(0,0,0,ay),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
},{
ah("UIPadding",{
PaddingTop=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingLeft=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingRight=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingBottom=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
}),
ah("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,ap.Gap),
HorizontalAlignment="Center",
})
})


ap.UIElements.ContainerFrameCanvas=ah("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Visible=false,
Parent=Window.UIElements.MainBar,
ZIndex=5,
},{
ah("Frame",{
Size=UDim2.new(1,0,0,((Window.UIPadding*2.4)+12)),
BackgroundTransparency=1,
Visible=ap.ShowTabTitle or false,
Name="TabTitle"
},{
ax,
ah("TextLabel",{
Text=ap.Title,
ThemeTag={
TextColor3="Text"
},
TextSize=20,
TextTransparency=.1,
Size=UDim2.new(1,-av,1,0),
FontFace=Font.new(af.Font,Enum.FontWeight.SemiBold),
TextTruncate="AtEnd",
RichText=true,
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
}),
ah("UIPadding",{
PaddingTop=UDim.new(0,20),
PaddingLeft=UDim.new(0,20),
PaddingRight=UDim.new(0,20),
PaddingBottom=UDim.new(0,20),
}),
ah("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
ah("Frame",{
Size=UDim2.new(1,0,0,1),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
},
Position=UDim2.new(0,0,0,((Window.UIPadding*2.4)+12)),
Visible=ap.ShowTabTitle or false,
})
})


if as then
local aB=100
local d=70

local e=ah("Frame",{
Name="ProfileHeader",
Size=UDim2.new(1,0,0,aA),

Position=UDim2.new(0,0,0,ap.ShowTabTitle and((Window.UIPadding*2.4)+12)or 0),
BackgroundTransparency=1,
ZIndex=2
})


if at and not ar then
e.Parent=ap.UIElements.ContainerFrameCanvas
else
e.Parent=ap.UIElements.ContainerFrame
e.LayoutOrder=-999
end

local f=af.NewRoundFrame(12,"Squircle",{
Size=UDim2.new(1,0,0,aB),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
ImageColor3=Color3.fromRGB(30,30,30),
Parent=e,
ClipsDescendants=true
})

if ap.Profile.Banner then
local g=af.Image(ap.Profile.Banner,"Banner",0,Window.Folder,"ProfileBanner",false)
g.Size=UDim2.new(1,0,1,0)
g.Parent=f
end


if ap.Profile.Badges then
local g=ah("Frame",{
Name="BadgeContainer",
Size=UDim2.new(0,0,0,28),
AutomaticSize=Enum.AutomaticSize.X,
Position=UDim2.new(1,-8,1,-8),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
Parent=f,
ZIndex=5
},{
ah("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
HorizontalAlignment=Enum.HorizontalAlignment.Right,
VerticalAlignment=Enum.VerticalAlignment.Center,
Padding=UDim.new(0,6)
})
})

for h,j in ipairs(ap.Profile.Badges)do
local l=j.Icon or"help-circle"
local m=j.Title~=nil

local p=ah("Frame",{
Name="BadgeWrapper",
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,28),
AutomaticSize=Enum.AutomaticSize.X,
Parent=g,
})

local r=af.NewRoundFrame(6,"Squircle",{
ImageColor3=Color3.new(0,0,0),
ImageTransparency=0.4,
Size=UDim2.new(1,0,1,0),
Name="BG",
Parent=p
})

local u=ah("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Parent=p
},{
ah("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
VerticalAlignment=Enum.VerticalAlignment.Center,
HorizontalAlignment=Enum.HorizontalAlignment.Center,
Padding=UDim.new(0,4)
}),
ah("UIPadding",{
PaddingLeft=UDim.new(0,m and 8 or 5),
PaddingRight=UDim.new(0,m and 8 or 5),
})
})

local v=af.Image(l,"BadgeIcon",0,Window.Folder,"Badge",false)
v.Size=UDim2.new(0,16,0,16)
v.BackgroundTransparency=1
v.Parent=u

local x=v:FindFirstChild"ImageLabel"or v:FindFirstChild"VideoFrame"
if x then
x.Size=UDim2.fromScale(1,1)
x.ImageColor3=Color3.new(1,1,1)
x.BackgroundTransparency=1
end

if m then
ah("TextLabel",{
Text=j.Title,
TextSize=12,
FontFace=Font.new(af.Font,Enum.FontWeight.SemiBold),
TextColor3=Color3.new(1,1,1),
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.XY,
LayoutOrder=2,
Parent=u
})
end

local z=ah("TextButton",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Text="",
ZIndex=10,
Parent=p
})

if j.Callback then
af.AddSignal(z.MouseButton1Click,function()
j.Callback()
end)
end

af.AddSignal(z.MouseEnter,function()
aj(r,0.1,{ImageTransparency=0.2}):Play()
end)
af.AddSignal(z.MouseLeave,function()
aj(r,0.1,{ImageTransparency=0.4}):Play()
end)

if j.Desc then
local A
local B
local C
local F=false

af.AddSignal(z.MouseEnter,function()
F=true
B=task.spawn(function()
task.wait(0.35)
if F and not A then
A=ak(j.Desc,am.ToolTipParent)
local function updatePosition()
if A then
A.Container.Position=UDim2.new(0,ae.X,0,ae.Y-20)
end
end
updatePosition()
C=ae.Move:Connect(updatePosition)
A:Open()
end
end)
end)

af.AddSignal(z.MouseLeave,function()
F=false
if B then task.cancel(B)B=nil end
if C then C:Disconnect()C=nil end
if A then A:Close()A=nil end
end)
end
end
end

local g=ah("Frame",{
Size=UDim2.new(0,d,0,d),
Position=UDim2.new(0,14,0,aB-(d/2)+5),
BackgroundTransparency=1,
Parent=e,
ZIndex=2
})

ah("UIStroke",{
Parent=g,
Thickness=4,
ThemeTag={Color="WindowBackground"},
Transparency=0,
ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
})
ah("UICorner",{CornerRadius=UDim.new(1,0),Parent=g})

if ap.Profile.Avatar then
local h=af.Image(ap.Profile.Avatar,"Avatar",0,Window.Folder,"ProfileAvatar",false)
h.Size=UDim2.fromScale(1,1)
h.BackgroundTransparency=1
h.Parent=g

local j=h:FindFirstChild"ImageLabel"
if j then
j.Size=UDim2.fromScale(1,1)
j.BackgroundTransparency=1
local l=j:FindFirstChildOfClass"UICorner"
if l then l:Destroy()end
ah("UICorner",{CornerRadius=UDim.new(1,0),Parent=j})
end
end

if ap.Profile.Status then
ah("Frame",{
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(1,-3,1,-3),
AnchorPoint=Vector2.new(1,1),
BackgroundColor3=Color3.fromHex"#23a559",
Parent=g,
ZIndex=3
},{
ah("UICorner",{CornerRadius=UDim.new(1,0)}),
ah("UIStroke",{Thickness=3,ThemeTag={Color="WindowBackground"}})
})
end

local h=ah("Frame",{
Name="TextContainer",
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.Y,
Size=UDim2.new(1,-(14+d+14),0,0),
Position=UDim2.new(0,14+d+14,0,aB+2),
Parent=e
},{
ah("UIListLayout",{
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,2),
FillDirection=Enum.FillDirection.Vertical,
VerticalAlignment=Enum.VerticalAlignment.Top,
HorizontalAlignment=Enum.HorizontalAlignment.Left
})
})

ah("TextLabel",{
Text=ap.Profile.Title or ap.Title,
TextSize=22,
FontFace=Font.new(af.Font,Enum.FontWeight.Bold),
ThemeTag={TextColor3="Text"},
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.XY,
TextXAlignment=Enum.TextXAlignment.Left,
Parent=h,
LayoutOrder=1
})

if ap.Profile.Desc then
ah("TextLabel",{
Text=ap.Profile.Desc,
TextSize=13,
FontFace=Font.new(af.Font,Enum.FontWeight.Regular),
ThemeTag={TextColor3="Text"},
TextTransparency=0.4,
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.XY,
TextXAlignment=Enum.TextXAlignment.Left,
Parent=h,
LayoutOrder=2
})
end
end

ap.UIElements.ContainerFrame.Parent=ap.UIElements.ContainerFrameCanvas

am.Containers[au]=ap.UIElements.ContainerFrameCanvas
am.Tabs[au]=ap

ap.ContainerFrame=ContainerFrameCanvas

af.AddSignal(ap.UIElements.Main.MouseButton1Click,function()
if not ap.Locked then
am:SelectTab(au)
end
end)

if Window.ScrollBarEnabled then
al(ap.UIElements.ContainerFrame,ap.UIElements.ContainerFrameCanvas,Window,3)
end

local aB
local d
local e
local f=false

if ap.Desc and not ar then
af.AddSignal(ap.UIElements.Main.InputBegan,function()
f=true
d=task.spawn(function()
task.wait(0.35)
if f and not aB then
aB=ak(ap.Desc,am.ToolTipParent)
local function updatePosition()
if aB then
aB.Container.Position=UDim2.new(0,ae.X,0,ae.Y-20)
end
end
updatePosition()
e=ae.Move:Connect(updatePosition)
aB:Open()
end
end)
end)
end

af.AddSignal(ap.UIElements.Main.MouseEnter,function()
if not ap.Locked then
aj(ap.UIElements.Main.Frame,0.08,{ImageTransparency=.97}):Play()
end
end)
af.AddSignal(ap.UIElements.Main.InputEnded,function()
if ap.Desc and not ar then
f=false
if d then task.cancel(d)d=nil end
if e then e:Disconnect()e=nil end
if aB then aB:Close()aB=nil end
end

if not ap.Locked then
aj(ap.UIElements.Main.Frame,0.08,{ImageTransparency=1}):Play()
end
end)



function ap.ScrollToTheElement(g,h)
ap.UIElements.ContainerFrame.ScrollingEnabled=false
aj(ap.UIElements.ContainerFrame,.45,
{
CanvasPosition=Vector2.new(
0,

ap.Elements[h].ElementFrame.AbsolutePosition.Y
-ap.UIElements.ContainerFrame.AbsolutePosition.Y
-ap.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
)
},
Enum.EasingStyle.Quint,Enum.EasingDirection.Out
):Play()

task.spawn(function()
task.wait(.48)

if ap.Elements[h].Highlight then
ap.Elements[h]:Highlight()
ap.UIElements.ContainerFrame.ScrollingEnabled=true
end
end)

return ap
end

local g=a.load'U'
g.Load(ap,ap.UIElements.ContainerFrame,g.Elements,Window,ANUI,nil,g,ao)

function ap.LockAll(h)
for j,l in next,Window.AllElements do
if l.Tab and l.Tab.Index and l.Tab.Index==ap.Index and l.Lock then
l:Lock()
end
end
end
function ap.UnlockAll(h)
for j,l in next,Window.AllElements do
if l.Tab and l.Tab.Index and l.Tab.Index==ap.Index and l.Unlock then
l:Unlock()
end
end
end
function ap.GetLocked(h)
local j={}
for l,m in next,Window.AllElements do
if m.Tab and m.Tab.Index and m.Tab.Index==ap.Index and m.Locked==true then
table.insert(j,m)
end
end
return j
end
function ap.GetUnlocked(h)
local j={}
for l,m in next,Window.AllElements do
if m.Tab and m.Tab.Index and m.Tab.Index==ap.Index and m.Locked==false then
table.insert(j,m)
end
end
return j
end

function ap.Select(h)
return am:SelectTab(ap.Index)
end

task.spawn(function()
local h=ah("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,-Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
Parent=ap.UIElements.ContainerFrame
},{
ah("UIListLayout",{
Padding=UDim.new(0,8),
SortOrder="LayoutOrder",
VerticalAlignment="Center",
HorizontalAlignment="Center",
FillDirection="Vertical",
}),
ah("ImageLabel",{
Size=UDim2.new(0,48,0,48),
Image=af.Icon"frown"[1],
ImageRectOffset=af.Icon"frown"[2].ImageRectPosition,
ImageRectSize=af.Icon"frown"[2].ImageRectSize,
ThemeTag={
ImageColor3="Icon"
},
BackgroundTransparency=1,
ImageTransparency=.6,
}),
ah("TextLabel",{
AutomaticSize="XY",
Text="This tab is empty",
ThemeTag={
TextColor3="Text"
},
TextSize=18,
TextTransparency=.5,
BackgroundTransparency=1,
FontFace=Font.new(af.Font,Enum.FontWeight.Medium),
})
})

local j
j=af.AddSignal(ap.UIElements.ContainerFrame.ChildAdded,function()
h.Visible=false
j:Disconnect()
end)
end)

return ap
end

function am.OnChange(an,ao)
am.OnChangeFunc=ao
end

function am.SelectTab(an,ao)
if not am.Tabs[ao].Locked then
am.SelectedTab=ao

for ap,ar in next,am.Tabs do
if not ar.Locked then
aj(ar.UIElements.Main,0.15,{ImageTransparency=1}):Play()
aj(ar.UIElements.Main.Outline,0.15,{ImageTransparency=1}):Play()

if ar.UIElements.Main.Frame:FindFirstChild"TextLabel"then
aj(ar.UIElements.Main.Frame.TextLabel,0.15,{TextTransparency=0.3}):Play()
end

if ar.UIElements.Icon then
aj(ar.UIElements.Icon.ImageLabel,0.15,{ImageTransparency=0.4}):Play()
end
ar.Selected=false
end
end
aj(am.Tabs[ao].UIElements.Main,0.15,{ImageTransparency=0.95}):Play()
aj(am.Tabs[ao].UIElements.Main.Outline,0.15,{ImageTransparency=0.85}):Play()

if am.Tabs[ao].UIElements.Main.Frame:FindFirstChild"TextLabel"then
aj(am.Tabs[ao].UIElements.Main.Frame.TextLabel,0.15,{TextTransparency=0}):Play()
end

if am.Tabs[ao].UIElements.Icon then
aj(am.Tabs[ao].UIElements.Icon.ImageLabel,0.15,{ImageTransparency=0.1}):Play()
end
am.Tabs[ao].Selected=true

task.spawn(function()
for ap,ar in next,am.Containers do
ar.AnchorPoint=Vector2.new(0,0.05)
ar.Visible=false
end
am.Containers[ao].Visible=true
aj(am.Containers[ao],0.15,{AnchorPoint=Vector2.new(0,0)},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()
end)

am.OnChangeFunc(ao)
end
end

return am end function a.W()
local aa={}


local ae=a.load'b'
local af=ae.New
local ah=ae.Tween

local aj=a.load'V'

function aa.New(ak,al,am,an,ao)
local ap={
Title=ak.Title or"Section",
Icon=ak.Icon,
IconThemed=ak.IconThemed,
Opened=ak.Opened or false,

HeaderSize=42,
IconSize=18,

Expandable=false,
}

local ar
if ap.Icon then
ar=ae.Image(
ap.Icon,
ap.Icon,
0,
am,
"Section",
true,
ap.IconThemed
)

ar.Size=UDim2.new(0,ap.IconSize,0,ap.IconSize)
ar.ImageLabel.ImageTransparency=.25
end

local as=af("Frame",{
Size=UDim2.new(0,ap.IconSize,0,ap.IconSize),
BackgroundTransparency=1,
Visible=false
},{
af("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=ae.Icon"chevron-down"[1],
ImageRectSize=ae.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=ae.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.7,
})
})

local at=af("Frame",{
Size=UDim2.new(1,0,0,ap.HeaderSize),
BackgroundTransparency=1,
Parent=al,
ClipsDescendants=true,
},{
af("TextButton",{
Size=UDim2.new(1,0,0,ap.HeaderSize),
BackgroundTransparency=1,
Text="",
},{
ar,
af("TextLabel",{
Text=ap.Title,
TextXAlignment="Left",
Size=UDim2.new(
1,
ar and(-ap.IconSize-10)*2
or(-ap.IconSize-10),

1,
0
),
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ae.Font,Enum.FontWeight.SemiBold),
TextSize=14,
BackgroundTransparency=1,
TextTransparency=.7,

TextWrapped=true
}),
af("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,10)
}),
as,
af("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
})
}),
af("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=true,
Position=UDim2.new(0,0,0,ap.HeaderSize)
},{
af("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ao.Gap),
VerticalAlignment="Bottom",
}),
})
})


function ap.Tab(au,av)
if not ap.Expandable then
ap.Expandable=true
as.Visible=true
end
av.Parent=at.Content
return aj.New(av,an)
end

function ap.Open(au)
if ap.Expandable then
ap.Opened=true
ah(at,0.33,{
Size=UDim2.new(1,0,0,ap.HeaderSize+(at.Content.AbsoluteSize.Y/an))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ah(as.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function ap.Close(au)
if ap.Expandable then
ap.Opened=false
ah(at,0.26,{
Size=UDim2.new(1,0,0,ap.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ah(as.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

ae.AddSignal(at.TextButton.MouseButton1Click,function()
if ap.Expandable then
if ap.Opened then
ap:Close()
else
ap:Open()
end
end
end)

ae.AddSignal(at.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if ap.Opened then
ap:Open()
end
end)

if ap.Opened then
task.spawn(function()
task.wait()
ap:Open()
end)
end



return ap
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

local ae={
Margin=8,
Padding=9,
}


local af=a.load'b'
local ah=af.New
local aj=af.Tween


function ae.new(ak,al,am)
local an={
IconSize=18,
Padding=14,
Radius=22,
Width=400,
MaxHeight=380,

Icons=a.load'X'
}


local ao=ah("TextBox",{
Text="",
PlaceholderText="Search...",
ThemeTag={
PlaceholderColor3="Placeholder",
TextColor3="Text",
},
Size=UDim2.new(
1,
-((an.IconSize*2)+(an.Padding*2)),
0,
0
),
AutomaticSize="Y",
ClipsDescendants=true,
ClearTextOnFocus=false,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(af.Font,Enum.FontWeight.Regular),
TextSize=18,
})

local ap=ah("ImageLabel",{
Image=af.Icon"x"[1],
ImageRectSize=af.Icon"x"[2].ImageRectSize,
ImageRectOffset=af.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.1,
Size=UDim2.new(0,an.IconSize,0,an.IconSize)
},{
ah("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
Active=true,
ZIndex=999999999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
})
})

local ar=ah("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ElasticBehavior="Never",
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
Visible=false
},{
ah("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
ah("UIPadding",{
PaddingTop=UDim.new(0,an.Padding),
PaddingLeft=UDim.new(0,an.Padding),
PaddingRight=UDim.new(0,an.Padding),
PaddingBottom=UDim.new(0,an.Padding),
})
})

local as=af.NewRoundFrame(an.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Background",
},
ImageTransparency=0,
},{
af.NewRoundFrame(an.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,

Visible=false,
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.98,
Name="Frame",
},{
ah("Frame",{
Size=UDim2.new(1,0,0,46),
BackgroundTransparency=1,
},{








ah("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ah("ImageLabel",{
Image=af.Icon"search"[1],
ImageRectSize=af.Icon"search"[2].ImageRectSize,
ImageRectOffset=af.Icon"search"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.1,
Size=UDim2.new(0,an.IconSize,0,an.IconSize)
}),
ao,
ap,
ah("UIListLayout",{
Padding=UDim.new(0,an.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ah("UIPadding",{
PaddingLeft=UDim.new(0,an.Padding),
PaddingRight=UDim.new(0,an.Padding),
})
})
}),
ah("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Results",
},{
ah("Frame",{
Size=UDim2.new(1,0,0,1),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=.9,
Visible=false,
}),
ar,
ah("UISizeConstraint",{
MaxSize=Vector2.new(an.Width,an.MaxHeight),
}),
}),
ah("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
})
})

local at=ah("Frame",{
Size=UDim2.new(0,an.Width,0,0),
AutomaticSize="Y",
Parent=al,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Visible=false,

ZIndex=99999999,
},{
ah("UIScale",{
Scale=.9,
}),
as,
af.NewRoundFrame(an.Radius,"SquircleOutline2",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Outline",
},
ImageTransparency=1,
},{
ah("UIGradient",{
Rotation=45,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.55),
NumberSequenceKeypoint.new(0.5,0.8),
NumberSequenceKeypoint.new(1,0.6)
}
})
})
})

local function CreateSearchTab(au,av,aw,ax,ay,az)
local aA=ah("TextButton",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ax or nil
},{
af.NewRoundFrame(an.Radius-11,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),

ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Main"
},{
af.NewRoundFrame(an.Radius-11,"SquircleOutline2",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Outline",
},
ImageTransparency=1,
Name="Outline",
},{
ah("UIGradient",{
Rotation=65,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.55),
NumberSequenceKeypoint.new(0.5,0.8),
NumberSequenceKeypoint.new(1,0.6)
}
}),
ah("UIPadding",{
PaddingTop=UDim.new(0,an.Padding-2),
PaddingLeft=UDim.new(0,an.Padding),
PaddingRight=UDim.new(0,an.Padding),
PaddingBottom=UDim.new(0,an.Padding-2),
}),
ah("ImageLabel",{
Image=af.Icon(aw)[1],
ImageRectSize=af.Icon(aw)[2].ImageRectSize,
ImageRectOffset=af.Icon(aw)[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.1,
Size=UDim2.new(0,an.IconSize,0,an.IconSize)
}),
ah("Frame",{
Size=UDim2.new(1,-an.IconSize-an.Padding,0,0),
BackgroundTransparency=1,
},{
ah("TextLabel",{
Text=au,
ThemeTag={
TextColor3="Text",
},
TextSize=17,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(af.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Title"
}),
ah("TextLabel",{
Text=av or"",
Visible=av and true or false,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=.3,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(af.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Desc"
})or nil,
ah("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
})
}),
ah("UIListLayout",{
Padding=UDim.new(0,an.Padding),
FillDirection="Horizontal",
})
}),
},true),
ah("Frame",{
Name="ParentContainer",
Size=UDim2.new(1,-an.Padding,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=ay,

},{
af.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,2,1,0),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=.9,
}),
ah("Frame",{
Size=UDim2.new(1,-an.Padding-2,0,0),
Position=UDim2.new(0,an.Padding+2,0,0),
BackgroundTransparency=1,
},{
ah("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
}),
ah("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
HorizontalAlignment="Right"
})
})



aA.Main.Size=UDim2.new(
1,
0,
0,
aA.Main.Outline.Frame.Desc.Visible and(((an.Padding-2)*2)+aA.Main.Outline.Frame.Title.TextBounds.Y+6+aA.Main.Outline.Frame.Desc.TextBounds.Y)
or(((an.Padding-2)*2)+aA.Main.Outline.Frame.Title.TextBounds.Y)
)

af.AddSignal(aA.Main.MouseEnter,function()
aj(aA.Main,.04,{ImageTransparency=.95}):Play()
aj(aA.Main.Outline,.04,{ImageTransparency=.7}):Play()
end)
af.AddSignal(aA.Main.InputEnded,function()
aj(aA.Main,.08,{ImageTransparency=1}):Play()
aj(aA.Main.Outline,.08,{ImageTransparency=1}):Play()
end)
af.AddSignal(aA.Main.MouseButton1Click,function()
if az then
az()
end
end)

return aA
end

local function ContainsText(au,av)
if not av or av==""then
return false
end

if not au or au==""then
return false
end

local aw=string.lower(au)
local ax=string.lower(av)

return string.find(aw,ax,1,true)~=nil
end

local function Search(au)
if not au or au==""then
return{}
end

local av={}
for aw,ax in next,ak.Tabs do
local ay=ContainsText(ax.Title or"",au)
local az={}

for aA,aB in next,ax.Elements do
if aB.__type~="Section"then
local d=ContainsText(aB.Title or"",au)
local e=ContainsText(aB.Desc or"",au)

if d or e then
az[aA]={
Title=aB.Title,
Desc=aB.Desc,
Original=aB,
__type=aB.__type,
Index=aA,
}
end
end
end

if ay or next(az)~=nil then
av[aw]={
Tab=ax,
Title=ax.Title,
Icon=ax.Icon,
Elements=az,
}
end
end
return av
end

function an.Search(au,av)
av=av or""

local aw=Search(av)

ar.Visible=true
as.Frame.Results.Frame.Visible=true
for ax,ay in next,ar:GetChildren()do
if ay.ClassName~="UIListLayout"and ay.ClassName~="UIPadding"then
ay:Destroy()
end
end

if aw and next(aw)~=nil then
for ax,ay in next,aw do
local az=an.Icons.Tab
local aA=CreateSearchTab(ay.Title,nil,az,ar,true,function()
an:Close()
ak:SelectTab(ax)
end)
if ay.Elements and next(ay.Elements)~=nil then
for aB,d in next,ay.Elements do
local e=an.Icons[d.__type]
CreateSearchTab(d.Title,d.Desc,e,aA:FindFirstChild"ParentContainer"and aA.ParentContainer.Frame or nil,false,function()
an:Close()
ak:SelectTab(ax)
if ay.Tab.ScrollToTheElement then

ay.Tab:ScrollToTheElement(d.Index)
end

end)

end
end
end
elseif av~=""then
ah("TextLabel",{
Size=UDim2.new(1,0,0,70),
BackgroundTransparency=1,
Text="No results found",
TextSize=16,
ThemeTag={
TextColor3="Text",
},
TextTransparency=.2,
BackgroundTransparency=1,
FontFace=Font.new(af.Font,Enum.FontWeight.Medium),
Parent=ar,
Name="NotFound",
})
else
ar.Visible=false
as.Frame.Results.Frame.Visible=false
end
end

af.AddSignal(ao:GetPropertyChangedSignal"Text",function()
an:Search(ao.Text)
end)

af.AddSignal(ar.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()

aj(ar,.06,{Size=UDim2.new(
1,
0,
0,
math.clamp(ar.UIListLayout.AbsoluteContentSize.Y+(an.Padding*2),0,an.MaxHeight)
)},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()






end)

function an.Open(au)
task.spawn(function()
as.Frame.Visible=true
at.Visible=true
aj(at.UIScale,.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

function an.Close(au)
task.spawn(function()
am()
as.Frame.Visible=false
aj(at.UIScale,.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(.12)
at.Visible=false
end)
end

af.AddSignal(ap.TextButton.MouseButton1Click,function()
an:Close()
end)

an:Open()

return an
end

return ae end function a.Z()
local aa=(cloneref or clonereference or function(aa)return aa end)

local ae=aa(game:GetService"UserInputService")
aa(game:GetService"RunService")

local af=workspace.CurrentCamera

local ah=a.load'q'

local aj=a.load'b'
local ak=aj.New
local al=aj.Tween


local am=a.load't'.New
local an=a.load'j'.New
local ao=a.load'u'.New
local ap=a.load'v'

local ar=a.load'w'



return function(as)
local at={
Title=as.Title or"UI Library",
Author=as.Author,
Icon=as.Icon,
IconSize=as.IconSize or 22,
IconThemed=as.IconThemed,
Folder=as.Folder,
Resizable=as.Resizable~=false,
Background=as.Background,
BackgroundImageTransparency=as.BackgroundImageTransparency or 0,
ShadowTransparency=as.ShadowTransparency or 0.7,
User=as.User or{},

Size=as.Size,

MinSize=as.MinSize or Vector2.new(850,560),
MaxSize=as.MaxSize or Vector2.new(1050,560),

TopBarButtonIconSize=as.TopBarButtonIconSize or 16,

ToggleKey=as.ToggleKey,
ElementsRadius=as.ElementsRadius,
Radius=as.Radius or 16,
Transparent=as.Transparent or false,
HideSearchBar=as.HideSearchBar~=false,
ScrollBarEnabled=as.ScrollBarEnabled or false,
SideBarWidth=as.SideBarWidth or 200,
Acrylic=as.Acrylic or false,
NewElements=as.NewElements or false,
IgnoreAlerts=as.IgnoreAlerts or false,
HidePanelBackground=as.HidePanelBackground or false,
AutoScale=as.AutoScale~=false,
OpenButton=as.OpenButton,

Position=UDim2.new(0.5,0,0.5,0),
UICorner=nil,
UIPadding=14,
UIElements={},
CanDropdown=true,
Closed=false,
Parent=as.Parent,
Destroyed=false,
IsFullscreen=false,
CanResize=as.Resizable~=false,
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

at.UICorner=at.Radius

at.ElementConfig={
UIPadding=(at.NewElements and 10 or 13),
UICorner=at.ElementsRadius or(at.NewElements and 23 or 12),
}

local au=at.Size or UDim2.new(0,580,0,460)
at.Size=UDim2.new(
au.X.Scale,
math.clamp(au.X.Offset,at.MinSize.X,at.MaxSize.X),
au.Y.Scale,
math.clamp(au.Y.Offset,at.MinSize.Y,at.MaxSize.Y)
)

if at.Folder then
if not isfolder("ANUI/"..at.Folder)then
makefolder("ANUI/"..at.Folder)
end
if not isfolder("ANUI/"..at.Folder.."/assets")then
makefolder("ANUI/"..at.Folder.."/assets")
end
if not isfolder(at.Folder)then
makefolder(at.Folder)
end
if not isfolder(at.Folder.."/assets")then
makefolder(at.Folder.."/assets")
end
end

local av=ak("UICorner",{
CornerRadius=UDim.new(0,at.UICorner)
})

if at.Folder then
at.ConfigManager=ar:Init(at)
end


if at.Acrylic then local
aw=ah.AcrylicPaint{UseAcrylic=at.Acrylic}

at.AcrylicPaint=aw
end

local aw=ak("Frame",{
Size=UDim2.new(0,32,0,32),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(.5,.5),
BackgroundTransparency=1,
ZIndex=99,
Active=true
},{
ak("ImageLabel",{
Size=UDim2.new(0,96,0,96),
BackgroundTransparency=1,
Image="rbxassetid://120997033468887",
Position=UDim2.new(0.5,-16,0.5,-16),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
})
})
local ax=aj.NewRoundFrame(at.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=98,
Active=false,
},{
ak("ImageLabel",{
Size=UDim2.new(0,70,0,70),
Image=aj.Icon"expand"[1],
ImageRectOffset=aj.Icon"expand"[2].ImageRectPosition,
ImageRectSize=aj.Icon"expand"[2].ImageRectSize,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})

local ay=aj.NewRoundFrame(at.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=999,
Active=false,
})










at.UIElements.SideBar=ak("ScrollingFrame",{
Size=UDim2.new(
1,
at.ScrollBarEnabled and-3-(at.UIPadding/2)or 0,
1,
not at.HideSearchBar and-45 or 0
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
ak("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Frame",
},{
ak("UIPadding",{
PaddingTop=UDim.new(0,at.UIPadding/2),


PaddingBottom=UDim.new(0,at.UIPadding/2),
}),
ak("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,at.Gap)
})
}),
ak("UIPadding",{

PaddingLeft=UDim.new(0,at.UIPadding/2),
PaddingRight=UDim.new(0,at.UIPadding/2),

}),

})

at.UIElements.SideBarContainer=ak("Frame",{
Size=UDim2.new(0,at.SideBarWidth,1,at.User.Enabled and-94-(at.UIPadding*2)or-52),
Position=UDim2.new(0,0,0,52),
BackgroundTransparency=1,
Visible=true,
},{
aj.NewRoundFrame(at.UICorner-(at.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ZIndex=1,
ImageTransparency=1,
Name="SidebarBackdrop",
}),
ak("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(
1,
0,
1,
not at.HideSearchBar and-45-at.UIPadding/2 or 0
),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
}),
at.UIElements.SideBar,
})

if at.ScrollBarEnabled then
ao(at.UIElements.SideBar,at.UIElements.SideBarContainer.Content,at,3)
end


at.UIElements.MainBar=ak("Frame",{
Size=UDim2.new(1,-at.UIElements.SideBarContainer.AbsoluteSize.X,1,-52),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
},{
aj.NewRoundFrame(at.UICorner-(at.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ZIndex=3,
ImageTransparency=.95,
Name="Background",
Visible=not at.HidePanelBackground
}),
ak("UIPadding",{
PaddingTop=UDim.new(0,at.UIPadding/2),
PaddingLeft=UDim.new(0,at.UIPadding/2),
PaddingRight=UDim.new(0,at.UIPadding/2),
PaddingBottom=UDim.new(0,at.UIPadding/2),
})
})

local function getScaledSidebarWidth()
return at.UIElements.SideBarContainer.AbsoluteSize.X/(as.ANUI.UIScale or 1)
end

at.UIElements.MainBar.Size=UDim2.new(1,-at.SideBarWidth,1,-52)

aj.AddSignal(at.UIElements.SideBarContainer:GetPropertyChangedSignal"AbsoluteSize",function()
at.UIElements.MainBar.Size=UDim2.new(1,-getScaledSidebarWidth(),1,-52)
end)

local az=ak("ImageLabel",{
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



if ae.TouchEnabled and not ae.KeyboardEnabled then
at.IsPC=false
elseif ae.KeyboardEnabled then
at.IsPC=true
else
at.IsPC=nil
end










local aA
if at.User then
local function GetUserThumb()local
aB=aa(game:GetService"Players"):GetUserThumbnailAsync(
at.User.Anonymous and 1 or game.Players.LocalPlayer.UserId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size420x420
)
return aB
end


aA=ak("TextButton",{
Size=UDim2.new(0,
(at.UIElements.SideBarContainer.AbsoluteSize.X)-(at.UIPadding/2),
0,
42+(at.UIPadding)
),
Position=UDim2.new(0,at.UIPadding/2,1,-(at.UIPadding/2)),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
Visible=at.User.Enabled or false,
},{
aj.NewRoundFrame(at.UICorner-(at.UIPadding/2),"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline"
},{
ak("UIGradient",{
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
aj.NewRoundFrame(at.UICorner-(at.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="UserIcon",
},{
ak("ImageLabel",{
Image=GetUserThumb(),
BackgroundTransparency=1,
Size=UDim2.new(0,42,0,42),
ThemeTag={
BackgroundColor3="Text",
},
BackgroundTransparency=.93,
},{
ak("UICorner",{
CornerRadius=UDim.new(1,0)
})
}),
ak("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
},{
ak("TextLabel",{
Text=at.User.Anonymous and"Anonymous"or game.Players.LocalPlayer.DisplayName,
TextSize=17,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(aj.Font,Enum.FontWeight.SemiBold),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="DisplayName"
}),
ak("TextLabel",{
Text=at.User.Anonymous and"anonymous"or game.Players.LocalPlayer.Name,
TextSize=15,
TextTransparency=.6,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(aj.Font,Enum.FontWeight.Medium),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="UserName"
}),
ak("UIListLayout",{
Padding=UDim.new(0,4),
HorizontalAlignment="Left",
})
}),
ak("UIListLayout",{
Padding=UDim.new(0,at.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ak("UIPadding",{
PaddingLeft=UDim.new(0,at.UIPadding/2),
PaddingRight=UDim.new(0,at.UIPadding/2),
})
})
})


function at.User.Enable(aB)
at.User.Enabled=true
al(at.UIElements.SideBarContainer,.25,{Size=UDim2.new(0,at.SideBarWidth,1,-94-(at.UIPadding*2))},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
aA.Visible=true
end
function at.User.Disable(aB)
at.User.Enabled=false
al(at.UIElements.SideBarContainer,.25,{Size=UDim2.new(0,at.SideBarWidth,1,-52)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
aA.Visible=false
end
function at.User.SetAnonymous(aB,d)
if d~=false then d=true end
at.User.Anonymous=d
aA.UserIcon.ImageLabel.Image=GetUserThumb()
aA.UserIcon.Frame.DisplayName.Text=d and"Anonymous"or game.Players.LocalPlayer.DisplayName
aA.UserIcon.Frame.UserName.Text=d and"anonymous"or game.Players.LocalPlayer.Name
end

if at.User.Enabled then
at.User:Enable()
else
at.User:Disable()
end

if at.User.Callback then
aj.AddSignal(aA.MouseButton1Click,function()
at.User.Callback()
end)
aj.AddSignal(aA.MouseEnter,function()
al(aA.UserIcon,0.04,{ImageTransparency=.95}):Play()
al(aA.Outline,0.04,{ImageTransparency=.85}):Play()
end)
aj.AddSignal(aA.InputEnded,function()
al(aA.UserIcon,0.04,{ImageTransparency=1}):Play()
al(aA.Outline,0.04,{ImageTransparency=1}):Play()
end)
end
end

local aB
local d


local e=false
local f

local g=typeof(at.Background)=="string"and string.match(at.Background,"^video:(.+)")or nil
local h=typeof(at.Background)=="string"and not g and string.match(at.Background,"^https?://.+")or nil

local function GetImageExtension(j)
local l=j:match"%.(%w+)$"or j:match"%.(%w+)%?"
if l then
l=l:lower()
if l=="jpg"or l=="jpeg"or l=="png"or l=="webp"then
return"."..l
end
end
return".png"
end

if typeof(at.Background)=="string"and g then
e=true

if string.find(g,"http")then
local j=at.Folder.."/assets/."..aj.SanitizeFilename(g)..".webm"
if not isfile(j)then
local l,m=pcall(function()
local l=aj.Request{Url=g,Method="GET",Headers={["User-Agent"]="Roblox/Exploit"}}
writefile(j,l.Body)
end)
if not l then
warn("[ ANUI.Window.Background ] Failed to download video: "..tostring(m))
return
end
end

local l,m=pcall(function()
return getcustomasset(j)
end)
if not l then
warn("[ ANUI.Window.Background ] Failed to load custom asset: "..tostring(m))
return
end
warn"[ ANUI.Window.Background ] VideoFrame may not work with custom video"
g=m
end

f=ak("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=g,
Looped=true,
Volume=0,
},{
ak("UICorner",{
CornerRadius=UDim.new(0,at.UICorner)
}),
})
f:Play()

elseif h then
local j=at.Folder.."/assets/."..aj.SanitizeFilename(h)..GetImageExtension(h)
if not isfile(j)then
local l,m=pcall(function()
local l=aj.Request{Url=h,Method="GET",Headers={["User-Agent"]="Roblox/Exploit"}}
writefile(j,l.Body)
end)
if not l then
warn("[ Window.Background ] Failed to download image: "..tostring(m))
return
end
end

local l,m=pcall(function()
return getcustomasset(j)
end)
if not l then
warn("[ Window.Background ] Failed to load custom asset: "..tostring(m))
return
end

f=ak("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=m,
ImageTransparency=0,
ScaleType="Crop",
},{
ak("UICorner",{
CornerRadius=UDim.new(0,at.UICorner)
}),
})

elseif at.Background then
f=ak("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=typeof(at.Background)=="string"and at.Background or"",
ImageTransparency=1,
ScaleType="Crop",
},{
ak("UICorner",{
CornerRadius=UDim.new(0,at.UICorner)
}),
})
end


local j=aj.NewRoundFrame(99,"Squircle",{
ImageTransparency=.8,
ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(0,0,0,4),
Position=UDim2.new(0.5,0,1,4),
AnchorPoint=Vector2.new(0.5,0),
},{
ak("TextButton",{
Size=UDim2.new(1,12,1,12),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
ZIndex=99,
Name="Frame",
})
})

function createAuthor(l)
return ak("TextLabel",{
Text=l,
FontFace=Font.new(aj.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
TextTransparency=0.35,
AutomaticSize="XY",
Parent=at.UIElements.Main and at.UIElements.Main.Main.Topbar.Left.Title,
TextXAlignment="Left",
TextSize=13,
LayoutOrder=2,
ThemeTag={
TextColor3="WindowTopbarAuthor"
},
Name="Author",
})
end

local l
local m

if at.Author then
l=createAuthor(at.Author)
end


local p=ak("TextLabel",{
Text=at.Title,
FontFace=Font.new(aj.Font,Enum.FontWeight.SemiBold),
BackgroundTransparency=1,
AutomaticSize="XY",
Name="Title",
TextXAlignment="Left",
TextSize=16,
ThemeTag={
TextColor3="WindowTopbarTitle"
}
})

at.UIElements.Main=ak("Frame",{
Size=at.Size,
Position=at.Position,
BackgroundTransparency=1,
Parent=as.Parent,
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
},{
as.ANUI.UIScaleObj,
at.AcrylicPaint and at.AcrylicPaint.Frame or nil,
az,
aj.NewRoundFrame(at.UICorner,"Squircle",{
ImageTransparency=1,
Size=UDim2.new(1,0,1,-240),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Background",
ThemeTag={
ImageColor3="WindowBackground"
},

},{
f,
j,
aw,



}),
UIStroke,
av,
ax,
ay,
ak("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Main",

Visible=false,
ZIndex=97,
},{
ak("UICorner",{
CornerRadius=UDim.new(0,at.UICorner)
}),
at.UIElements.SideBarContainer,
at.UIElements.MainBar,

aA,

d,
ak("Frame",{
Size=UDim2.new(1,0,0,52),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(50,50,50),
Name="Topbar"
},{
aB,






ak("Frame",{
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
Name="Left"
},{
ak("UIListLayout",{
Padding=UDim.new(0,at.UIPadding+4),
SortOrder="LayoutOrder",
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ak("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Name="Title",
Size=UDim2.new(0,0,1,0),
LayoutOrder=2,
},{
ak("UIListLayout",{
Padding=UDim.new(0,0),
SortOrder="LayoutOrder",
FillDirection="Vertical",
VerticalAlignment="Center",
}),
p,
l,
}),
ak("UIPadding",{
PaddingLeft=UDim.new(0,4)
})
}),
ak("ScrollingFrame",{
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
ak("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
Padding=UDim.new(0,at.UIPadding/2)
})
}),
ak("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
Name="Right",
},{
ak("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
SortOrder="LayoutOrder",
}),

}),
ak("UIPadding",{
PaddingTop=UDim.new(0,at.UIPadding),
PaddingLeft=UDim.new(0,at.UIPadding),
PaddingRight=UDim.new(0,8),
PaddingBottom=UDim.new(0,at.UIPadding),
})
})
})
})

aj.AddSignal(at.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal"AbsoluteSize",function()
local r=0
local u=at.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X/as.ANUI.UIScale
if p and l then
r=math.max(p.TextBounds.X/as.ANUI.UIScale,l.TextBounds.X/as.ANUI.UIScale)
else
r=p.TextBounds.X/as.ANUI.UIScale
end
if m then
r=r+(at.IconSize/as.ANUI.UIScale)+(at.UIPadding/as.ANUI.UIScale)+(4/as.ANUI.UIScale)
end
at.UIElements.Main.Main.Topbar.Center.Position=UDim2.new(
0,
r+(at.UIPadding/as.ANUI.UIScale),
0.5,
0
)
at.UIElements.Main.Main.Topbar.Center.Size=UDim2.new(
1,
-r-u-((at.UIPadding*2)/as.ANUI.UIScale),
1,
0
)
end)

function at.CreateTopbarButton(r,u,v,x,z,A)
local B=aj.Image(
v,
v,
0,
at.Folder,
"WindowTopbarIcon",
true,
A,
"WindowTopbarButtonIcon"
)
B.Size=UDim2.new(0,at.TopBarButtonIconSize,0,at.TopBarButtonIconSize)
B.AnchorPoint=Vector2.new(0.5,0.5)
B.Position=UDim2.new(0.5,0,0.5,0)

local C=aj.NewRoundFrame(at.UICorner-(at.UIPadding/2),"Squircle",{
Size=UDim2.new(0,36,0,36),
LayoutOrder=z or 999,
Parent=at.UIElements.Main.Main.Topbar.Right,

ZIndex=9999,
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=1
},{
aj.NewRoundFrame(at.UICorner-(at.UIPadding/2),"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline"
},{
ak("UIGradient",{
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
B
},true)



at.TopBarButtons[100-z]={
Name=u,
Object=C
}

aj.AddSignal(C.MouseButton1Click,function()
x()
end)
aj.AddSignal(C.MouseEnter,function()
al(C,.15,{ImageTransparency=.93}):Play()
al(C.Outline,.15,{ImageTransparency=.75}):Play()

end)
aj.AddSignal(C.MouseLeave,function()
al(C,.1,{ImageTransparency=1}):Play()
al(C.Outline,.1,{ImageTransparency=1}):Play()

end)

return C
end



local r=aj.Drag(
at.UIElements.Main,
{at.UIElements.Main.Main.Topbar,j.Frame},
function(r,u)
if not at.Closed then
if r and u==j.Frame then
al(j,.1,{ImageTransparency=.35}):Play()
else
al(j,.2,{ImageTransparency=.8}):Play()
end
at.Position=at.UIElements.Main.Position
at.Dragging=r
end
end
)

if not e and at.Background and typeof(at.Background)=="table"then

local u=ak"UIGradient"
for v,x in next,at.Background do
u[v]=x
end

at.UIElements.BackgroundGradient=aj.NewRoundFrame(at.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
Parent=at.UIElements.Main.Background,
ImageTransparency=at.Transparent and as.ANUI.TransparencyValue or 0
},{
u
})
end














at.OpenButtonMain=a.load'x'.New(at)


task.spawn(function()
if at.Icon then

local u=ak("Frame",{
Size=UDim2.new(0,22,0,22),
BackgroundTransparency=1,
Parent=at.UIElements.Main.Main.Topbar.Left,
})

m=aj.Image(
at.Icon,
at.Title,
0,
at.Folder,
"Window",
true,
at.IconThemed,
"WindowTopbarIcon"
)
m.Parent=u
m.Size=UDim2.new(0,at.IconSize,0,at.IconSize)
m.Position=UDim2.new(0.5,0,0.5,0)
m.AnchorPoint=Vector2.new(0.5,0.5)

at.OpenButtonMain:SetIcon(at.Icon)











else
at.OpenButtonMain:SetIcon(at.Icon)

end
end)

function at.SetToggleKey(u,v)
at.ToggleKey=v
end

function at.SetTitle(u,v)
at.Title=v
p.Text=v
end

function at.SetAuthor(u,v)
at.Author=v
if not l then
l=createAuthor(at.Author)
end

l.Text=v
end

function at.SetBackgroundImage(u,v)
at.UIElements.Main.Background.ImageLabel.Image=v
end
function at.SetBackgroundImageTransparency(u,v)
if f and f:IsA"ImageLabel"then
f.ImageTransparency=math.floor(v*10+0.5)/10
end
at.BackgroundImageTransparency=math.floor(v*10+0.5)/10
end

function at.SetBackgroundTransparency(u,v)
local x=math.floor(tonumber(v)*10+0.5)/10
as.ANUI.TransparencyValue=x
at:ToggleTransparency(x>0)
end




at.SidebarCollapsed=false

local function updateSidebarToggleIcon()
local u=at.UIElements.SidebarToggleButtonIcon
if u and u:FindFirstChild"ImageLabel"then
local v=at.SidebarCollapsed and"chevrons-right"or"chevrons-left"
local x=aj.Icon(v)
if x and x[1]and x[2]then
u.ImageLabel.Image=x[1]
u.ImageLabel.ImageRectOffset=x[2].ImageRectPosition
u.ImageLabel.ImageRectSize=x[2].ImageRectSize
end
end
end

function at.CollapseSidebar(u)
if at.SidebarCollapsed then return end
at.SidebarCollapsed=true
local v=at.User.Enabled and-94-(at.UIPadding*2)or-52
al(at.UIElements.SideBarContainer,.32,{Size=UDim2.new(0,0,1,v)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
al(at.UIElements.MainBar,.32,{Size=UDim2.new(1,0,1,-52)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
al(at.UIElements.SideBarContainer.SidebarBackdrop,.28,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
task.delay(.32,function()
al(at.UIElements.SideBarContainer,.16,{Size=UDim2.new(0,8,1,v)},Enum.EasingStyle.Sine,Enum.EasingDirection.Out):Play()
al(at.UIElements.MainBar,.16,{Size=UDim2.new(1,-(8/(as.ANUI.UIScale or 1)),1,-52)},Enum.EasingStyle.Sine,Enum.EasingDirection.Out):Play()
end)
task.delay(.48,function()
al(at.UIElements.SideBarContainer,.16,{Size=UDim2.new(0,0,1,v)},Enum.EasingStyle.Sine,Enum.EasingDirection.In):Play()
al(at.UIElements.MainBar,.16,{Size=UDim2.new(1,0,1,-52)},Enum.EasingStyle.Sine,Enum.EasingDirection.In):Play()
end)
updateSidebarToggleIcon()
end

function at.ExpandSidebar(u)
if not at.SidebarCollapsed then return end
at.SidebarCollapsed=false
local v=at.User.Enabled and-94-(at.UIPadding*2)or-52
al(at.UIElements.SideBarContainer,.36,{Size=UDim2.new(0,at.SideBarWidth,1,v)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
al(at.UIElements.MainBar,.36,{Size=UDim2.new(1,-at.SideBarWidth,1,-52)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
al(at.UIElements.SideBarContainer.SidebarBackdrop,.30,{ImageTransparency=.95},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
task.delay(.36,function()
al(at.UIElements.SideBarContainer,.18,{Size=UDim2.new(0,at.SideBarWidth+10,1,v)},Enum.EasingStyle.Sine,Enum.EasingDirection.Out):Play()
al(at.UIElements.MainBar,.18,{Size=UDim2.new(1,-(at.SideBarWidth+10),1,-52)},Enum.EasingStyle.Sine,Enum.EasingDirection.Out):Play()
end)
task.delay(.54,function()
al(at.UIElements.SideBarContainer,.18,{Size=UDim2.new(0,at.SideBarWidth,1,v)},Enum.EasingStyle.Sine,Enum.EasingDirection.In):Play()
al(at.UIElements.MainBar,.18,{Size=UDim2.new(1,-at.SideBarWidth,1,-52)},Enum.EasingStyle.Sine,Enum.EasingDirection.In):Play()
end)
updateSidebarToggleIcon()
end

function at.ToggleSidebar(u,v)
if v==nil then
if at.SidebarCollapsed then
at:ExpandSidebar()
else
at:CollapseSidebar()
end
else
if v then
at:CollapseSidebar()
else
at:ExpandSidebar()
end
end
end

local u=at:CreateTopbarButton("Sidebar","chevrons-left",function()
at:ToggleSidebar()
end,998)
at.UIElements.SidebarToggleButton=u
at.UIElements.SidebarToggleButtonIcon=u:FindFirstChild("WindowTopbarButtonIcon",true)
updateSidebarToggleIcon()

at:CreateTopbarButton("Minimize","minus",function()
at:Close()






















end,997)

function at.OnOpen(v,x)
at.OnOpenCallback=x
end
function at.OnClose(v,x)
at.OnCloseCallback=x
end
function at.OnDestroy(v,x)
at.OnDestroyCallback=x
end

if as.ANUI.UseAcrylic then
at.AcrylicPaint.AddParent(at.UIElements.Main)
end

function at.SetIconSize(v,x)
local z
if typeof(x)=="number"then
z=UDim2.new(0,x,0,x)
at.IconSize=x
elseif typeof(x)=="UDim2"then
z=x
at.IconSize=x.X.Offset
end

if m then
m.Size=z
end
end

function at.Open(v)
task.spawn(function()
if at.OnOpenCallback then
task.spawn(function()
aj.SafeCallback(at.OnOpenCallback)
end)
end


task.wait(.06)
at.Closed=false

al(at.UIElements.Main.Background,0.2,{
ImageTransparency=at.Transparent and as.ANUI.TransparencyValue or 0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if at.UIElements.BackgroundGradient then
al(at.UIElements.BackgroundGradient,0.2,{
ImageTransparency=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

al(at.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,0),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()

if f then
if f:IsA"VideoFrame"then
f.Visible=true
else
al(f,0.2,{
ImageTransparency=at.BackgroundImageTransparency,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

if at.OpenButtonMain and at.IsOpenButtonEnabled then
at.OpenButtonMain:Visible(false)
end


al(az,0.25,{ImageTransparency=at.ShadowTransparency},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if UIStroke then
al(UIStroke,0.25,{Transparency=.8},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

task.spawn(function()
task.wait(.3)
al(j,.45,{Size=UDim2.new(0,200,0,4),ImageTransparency=.8},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
r:Set(true)
task.wait(.45)
if at.Resizable then
al(aw.ImageLabel,.45,{ImageTransparency=.8},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
at.CanResize=true
end
end)


at.CanDropdown=true

at.UIElements.Main.Visible=true
task.spawn(function()
task.wait(.05)
at.UIElements.Main:WaitForChild"Main".Visible=true

as.ANUI:ToggleAcrylic(true)
end)
end)
end
function at.Close(v)
local x={}

if at.OnCloseCallback then
task.spawn(function()
aj.SafeCallback(at.OnCloseCallback)
end)
end

as.ANUI:ToggleAcrylic(false)

at.UIElements.Main:WaitForChild"Main".Visible=false

at.CanDropdown=false
at.Closed=true

al(at.UIElements.Main.Background,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
if at.UIElements.BackgroundGradient then
al(at.UIElements.BackgroundGradient,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end

al(at.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,-240),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()


if f then
if f:IsA"VideoFrame"then
f.Visible=false
else
al(f,0.3,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
al(az,0.25,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if UIStroke then
al(UIStroke,0.25,{Transparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

al(j,.3,{Size=UDim2.new(0,0,0,4),ImageTransparency=1},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()
al(aw.ImageLabel,.3,{ImageTransparency=1},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
r:Set(false)
at.CanResize=false

task.spawn(function()
task.wait(0.4)
at.UIElements.Main.Visible=false

if at.OpenButtonMain and not at.Destroyed and at.IsOpenButtonEnabled then
at.OpenButtonMain:Edit{OnlyIcon=true}
at.OpenButtonMain:Visible(true)
end
end)

function x.Destroy(z)
task.spawn(function()
if at.OnDestroyCallback then
task.spawn(function()
aj.SafeCallback(at.OnDestroyCallback)
end)
end
if at.AcrylicPaint and at.AcrylicPaint.Model then
at.AcrylicPaint.Model:Destroy()
end
at.Destroyed=true
task.wait(0.4)
as.ANUI.ScreenGui:Destroy()
as.ANUI.NotificationGui:Destroy()
as.ANUI.DropdownGui:Destroy()

aj.DisconnectAll()

return
end)
end

return x
end
function at.Destroy(v)
return at:Close():Destroy()
end
function at.Toggle(v)
if at.Closed then
at:Open()
else
at:Close()
end
end


function at.ToggleTransparency(v,x)

at.Transparent=x
as.ANUI.Transparent=x

at.UIElements.Main.Background.ImageTransparency=x and as.ANUI.TransparencyValue or 0

at.UIElements.MainBar.Background.ImageTransparency=x and 0.97 or 0.95

end

function at.LockAll(v)
for x,z in next,at.AllElements do
if z.Lock then z:Lock()end
end
end
function at.UnlockAll(v)
for x,z in next,at.AllElements do
if z.Unlock then z:Unlock()end
end
end
function at.GetLocked(v)
local x={}

for z,A in next,at.AllElements do
if A.Locked then table.insert(x,A)end
end

return x
end
function at.GetUnlocked(v)
local x={}

for z,A in next,at.AllElements do
if A.Locked==false then table.insert(x,A)end
end

return x
end

function at.GetUIScale(v,x)
return as.ANUI.UIScale
end

function at.SetUIScale(v,x)
as.ANUI.UIScale=x
al(as.ANUI.UIScaleObj,.2,{Scale=x},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return at
end

function at.SetToTheCenter(v)
al(at.UIElements.Main,0.45,{Position=UDim2.new(0.5,0,0.5,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return at
end

function at.SetCurrentConfig(v,x)
at.CurrentConfig=x
end

do
local v=40
local x=af.ViewportSize
local z=at.UIElements.Main.AbsoluteSize

if not at.IsFullscreen and at.AutoScale then
local A=x.X-(v*2)
local B=x.Y-(v*2)

local C=A/z.X
local F=B/z.Y

local G=math.min(C,F)

local H=0.3
local J=1.0

local L=math.clamp(G,H,J)

local M=at:GetUIScale()or 1
local N=0.05

if math.abs(L-M)>N then
at:SetUIScale(L)
end
end
end


if at.OpenButtonMain and at.OpenButtonMain.Button then
aj.AddSignal(at.OpenButtonMain.Button.TextButton.MouseButton1Click,function()


at:Open()
end)
end

aj.AddSignal(ae.InputBegan,function(v,x)
if x then return end

if at.ToggleKey then
if v.KeyCode==at.ToggleKey then
at:Toggle()
end
end
end)

task.spawn(function()

at:Open()
end)

function at.EditOpenButton(v,x)
return at.OpenButtonMain:Edit(x)
end

if at.OpenButton and typeof(at.OpenButton)=="table"then
at:EditOpenButton(at.OpenButton)
end


local v=a.load'V'
local x=a.load'W'
local z=v.Init(at,as.ANUI,as.Parent.Parent.ToolTips)
z:OnChange(function(A)at.CurrentTab=A end)

at.TabModule=v

function at.Tab(A,B)
B.Parent=at.UIElements.SideBar.Frame
return z.New(B,as.ANUI.UIScale)
end

function at.SelectTab(A,B)
z:SelectTab(B)
end

function at.Section(A,B)
return x.New(B,at.UIElements.SideBar.Frame,at.Folder,as.ANUI.UIScale,at)
end

function at.IsResizable(A,B)
at.Resizable=B
at.CanResize=B
end

function at.Divider(A)
local B=ak("Frame",{
Size=UDim2.new(1,0,0,1),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local C=ak("Frame",{
Parent=at.UIElements.SideBar.Frame,

Size=UDim2.new(1,-7,0,5),
BackgroundTransparency=1,
},{
B
})

return C
end

local A=a.load'l'.Init(at,nil)
function at.Dialog(B,C)
local F={
Title=C.Title or"Dialog",
Width=C.Width or 320,
Content=C.Content,
Buttons=C.Buttons or{},

TextPadding=10,
}
local G=A.Create(false)

G.UIElements.Main.Size=UDim2.new(0,F.Width,0,0)

local H=ak("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=G.UIElements.Main
},{
ak("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,G.UIPadding),
VerticalAlignment="Center"
}),
ak("UIPadding",{
PaddingTop=UDim.new(0,F.TextPadding/2),
PaddingLeft=UDim.new(0,F.TextPadding/2),
PaddingRight=UDim.new(0,F.TextPadding/2),
})
})

local J
if C.Icon then
J=aj.Image(
C.Icon,
F.Title..":"..C.Icon,
0,
at,
"Dialog",
true,
C.IconThemed
)
J.Size=UDim2.new(0,22,0,22)
J.Parent=H
end

G.UIElements.UIListLayout=ak("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
Parent=G.UIElements.Main
})

ak("UISizeConstraint",{
MinSize=Vector2.new(180,20),
MaxSize=Vector2.new(400,math.huge),
Parent=G.UIElements.Main,
})


G.UIElements.Title=ak("TextLabel",{
Text=F.Title,
TextSize=20,
FontFace=Font.new(aj.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
TextWrapped=true,
RichText=true,
Size=UDim2.new(1,J and-26-G.UIPadding or 0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=H
})
if F.Content then
ak("TextLabel",{
Text=F.Content,
TextSize=18,
TextTransparency=.4,
TextWrapped=true,
RichText=true,
FontFace=Font.new(aj.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
LayoutOrder=2,
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=G.UIElements.Main
},{
ak("UIPadding",{
PaddingLeft=UDim.new(0,F.TextPadding/2),
PaddingRight=UDim.new(0,F.TextPadding/2),
PaddingBottom=UDim.new(0,F.TextPadding/2),
})
})
end

local L=ak("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
})

local M=ak("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="None",
BackgroundTransparency=1,
Parent=G.UIElements.Main,
LayoutOrder=4,
},{
L,






})


local N={}

for O,P in next,F.Buttons do
local Q=an(P.Title,P.Icon,P.Callback,P.Variant,M,G,false)
table.insert(N,Q)
end

local function CheckButtonsOverflow()
L.FillDirection=Enum.FillDirection.Horizontal
L.HorizontalAlignment=Enum.HorizontalAlignment.Right
L.VerticalAlignment=Enum.VerticalAlignment.Center
M.AutomaticSize=Enum.AutomaticSize.None

for O,P in ipairs(N)do
P.Size=UDim2.new(0,0,1,0)
P.AutomaticSize=Enum.AutomaticSize.X
end

wait()

local O=L.AbsoluteContentSize.X/as.ANUI.UIScale
local P=M.AbsoluteSize.X/as.ANUI.UIScale

if O>P then
L.FillDirection=Enum.FillDirection.Vertical
L.HorizontalAlignment=Enum.HorizontalAlignment.Right
L.VerticalAlignment=Enum.VerticalAlignment.Bottom
M.AutomaticSize=Enum.AutomaticSize.Y

for Q,R in ipairs(N)do
R.Size=UDim2.new(1,0,0,40)
R.AutomaticSize=Enum.AutomaticSize.None
end
else
local Q=P-O
if Q>0 then
local R
local S=math.huge

for T,U in ipairs(N)do
local V=U.AbsoluteSize.X/as.ANUI.UIScale
if V<S then
S=V
R=U
end
end

if R then
R.Size=UDim2.new(0,S+Q,1,0)
R.AutomaticSize=Enum.AutomaticSize.None
end
end
end
end

aj.AddSignal(G.UIElements.Main:GetPropertyChangedSignal"AbsoluteSize",CheckButtonsOverflow)
CheckButtonsOverflow()

wait()
G:Open()

return G
end


at:CreateTopbarButton("Close","x",function()
if not at.IgnoreAlerts then
at:SetToTheCenter()
at:Dialog{

Title="Close Window",
Content="Do you want to close this window? You will not be able to open it again.",
Buttons={
{
Title="Cancel",

Callback=function()end,
Variant="Secondary",
},
{
Title="Close Window",

Callback=function()at:Destroy()end,
Variant="Primary",
}
}
}
else
at:Destroy()
end
end,999)

function at.Tag(B,C)
if at.UIElements.Main.Main.Topbar.Center.Visible==false then at.UIElements.Main.Main.Topbar.Center.Visible=true end
return ap:New(C,at.UIElements.Main.Main.Topbar.Center)
end


local function startResizing(B)
if at.CanResize then
isResizing=true
ax.Active=true
initialSize=at.UIElements.Main.Size
initialInputPosition=B.Position


al(aw.ImageLabel,0.1,{ImageTransparency=.35}):Play()

aj.AddSignal(B.Changed,function()
if B.UserInputState==Enum.UserInputState.End then
isResizing=false
ax.Active=false


al(aw.ImageLabel,0.17,{ImageTransparency=.8}):Play()
end
end)
end
end

aj.AddSignal(aw.InputBegan,function(B)
if B.UserInputType==Enum.UserInputType.MouseButton1 or B.UserInputType==Enum.UserInputType.Touch then
if at.CanResize then
startResizing(B)
end
end
end)

aj.AddSignal(ae.InputChanged,function(B)
if B.UserInputType==Enum.UserInputType.MouseMovement or B.UserInputType==Enum.UserInputType.Touch then
if isResizing and at.CanResize then
local C=B.Position-initialInputPosition
local F=UDim2.new(0,initialSize.X.Offset+C.X*2,0,initialSize.Y.Offset+C.Y*2)

F=UDim2.new(
F.X.Scale,
math.clamp(F.X.Offset,at.MinSize.X,at.MaxSize.X),
F.Y.Scale,
math.clamp(F.Y.Offset,at.MinSize.Y,at.MaxSize.Y)
)

al(at.UIElements.Main,0,{
Size=F
}):Play()

at.Size=F
end
end
end)




local B=0
local C=0.4
local F
local G=0

function onDoubleClick()
at:SetToTheCenter()
end

j.Frame.MouseButton1Up:Connect(function()
local H=tick()
local J=at.Position

G=G+1

if G==1 then
B=H
F=J

task.spawn(function()
task.wait(C)
if G==1 then
G=0
F=nil
end
end)

elseif G==2 then
if H-B<=C and J==F then
onDoubleClick()
end

G=0
F=nil
B=0
else
G=1
B=H
F=J
end
end)





if not at.HideSearchBar then
local H=a.load'Y'
local J=false





















local L=am("Search","search",at.UIElements.SideBarContainer,true)
L.Size=UDim2.new(1,-at.UIPadding/2,0,39)
L.Position=UDim2.new(0,at.UIPadding/2,0,at.UIPadding/2)

aj.AddSignal(L.MouseButton1Click,function()
if J then return end

H.new(at.TabModule,at.UIElements.Main,function()

J=false
if at.Resizable then
at.CanResize=true
end

al(ay,0.1,{ImageTransparency=1}):Play()
ay.Active=false
end)
al(ay,0.1,{ImageTransparency=.65}):Play()
ay.Active=true

J=true
at.CanResize=false
end)
end




function at.DisableTopbarButtons(H,J)
for L,M in next,J do
for N,O in next,at.TopBarButtons do
if O.Name==M then
O.Object.Visible=false
end
end
end
end

return at
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


local ae=(cloneref or clonereference or function(ae)return ae end)

aa.cloneref=ae

local af=ae(game:GetService"HttpService")
local ah=ae(game:GetService"Players")
local aj=ae(game:GetService"CoreGui")local ak=

ah.LocalPlayer or nil

local al=af:JSONDecode(a.load'i')
if al then
aa.Version=al.version
end

local am=a.load'm'local an=

aa.Services


local ao=aa.Creator

local ap=ao.New local ar=
ao.Tween


local as=a.load'q'


local at=protectgui or(syn and syn.protect_gui)or function()end

local au=gethui and gethui()or(aj or game.Players.LocalPlayer:WaitForChild"PlayerGui")

local av=ap("UIScale",{
Scale=aa.Scale,
})

aa.UIScaleObj=av

aa.ScreenGui=ap("ScreenGui",{
Name="ANUI",
Parent=au,
IgnoreGuiInset=true,
ScreenInsets="None",
},{

ap("Folder",{
Name="Window"
}),






ap("Folder",{
Name="KeySystem"
}),
ap("Folder",{
Name="Popups"
}),
ap("Folder",{
Name="ToolTips"
})
})

aa.NotificationGui=ap("ScreenGui",{
Name="ANUI/Notifications",
Parent=au,
IgnoreGuiInset=true,
})
aa.DropdownGui=ap("ScreenGui",{
Name="ANUI/Dropdowns",
Parent=au,
IgnoreGuiInset=true,
})
at(aa.ScreenGui)
at(aa.NotificationGui)
at(aa.DropdownGui)

ao.Init(aa)


function aa.SetParent(aw,ax)
aa.ScreenGui.Parent=ax
aa.NotificationGui.Parent=ax
aa.DropdownGui.Parent=ax
end
math.clamp(aa.TransparencyValue,0,1)

local aw=aa.NotificationModule.Init(aa.NotificationGui)

function aa.Notify(ax,ay)
ay.Holder=aw.Frame
ay.Window=aa.Window

return aa.NotificationModule.New(ay)
end

function aa.SetNotificationLower(ax,ay)
aw.SetLower(ay)
end

function aa.SetFont(ax,ay)
ao.UpdateFont(ay)
end

function aa.OnThemeChange(ax,ay)
aa.OnThemeChangeFunction=ay
end

function aa.AddTheme(ax,ay)
aa.Themes[ay.Name]=ay
return ay
end

function aa.SetTheme(ax,ay)
if aa.Themes[ay]then
aa.Theme=aa.Themes[ay]
ao.SetTheme(aa.Themes[ay])

if aa.OnThemeChangeFunction then
aa.OnThemeChangeFunction(ay)
end


return aa.Themes[ay]
end
return nil
end

function aa.GetThemes(ax)
return aa.Themes
end
function aa.GetCurrentTheme(ax)
return aa.Theme.Name
end
function aa.GetTransparency(ax)
return aa.Transparent or false
end
function aa.GetWindowSize(ax)
return Window.UIElements.Main.Size
end
function aa.Localization(ax,ay)
return aa.LocalizationModule:New(ay,ao)
end

function aa.SetLanguage(ax,ay)
if ao.Localization then
return ao.SetLanguage(ay)
end
return false
end

function aa.ToggleAcrylic(ax,ay)
if aa.Window and aa.Window.AcrylicPaint and aa.Window.AcrylicPaint.Model then
aa.Window.Acrylic=ay
aa.Window.AcrylicPaint.Model.Transparency=ay and 0.98 or 1
if ay then
as.Enable()
else
as.Disable()
end
end
end



function aa.Gradient(ax,ay,az)
local aA={}
local aB={}

for d,e in next,ay do
local f=tonumber(d)
if f then
f=math.clamp(f/100,0,1)
table.insert(aA,ColorSequenceKeypoint.new(f,e.Color))
table.insert(aB,NumberSequenceKeypoint.new(f,e.Transparency or 0))
end
end

table.sort(aA,function(d,e)return d.Time<e.Time end)
table.sort(aB,function(d,e)return d.Time<e.Time end)


if#aA<2 then
error"ColorSequence requires at least 2 keypoints"
end


local d={
Color=ColorSequence.new(aA),
Transparency=NumberSequence.new(aB),
}

if az then
for e,f in pairs(az)do
d[e]=f
end
end

return d
end


function aa.Popup(ax,ay)
ay.ANUI=aa
return a.load'r'.new(ay)
end


aa.Themes=a.load's'(aa)

ao.Themes=aa.Themes


aa:SetTheme"Dark"
aa:SetLanguage(ao.Language)


function aa.CreateWindow(ax,ay)
local az=a.load'Z'

if not isfolder"ANUI"then
makefolder"ANUI"
end
if ay.Folder then
makefolder(ay.Folder)
else
makefolder(ay.Title)
end

ay.ANUI=aa
ay.Parent=aa.ScreenGui.Window

if aa.Window then
warn"You cannot create more than one window"
return
end

local aA=true

local aB=aa.Themes[ay.Theme or"Dark"]


ao.SetTheme(aB)


local d=gethwid or function()
return ah.LocalPlayer.UserId
end

local e=d()

if ay.KeySystem then
aA=false

local function loadKeysystem()
am.new(ay,e,function(f)aA=f end)
end

local f=(ay.Folder or"Temp").."/"..e..".key"

if ay.KeySystem.KeyValidator then
if ay.KeySystem.SaveKey and isfile(f)then
local g=readfile(f)
local h=ay.KeySystem.KeyValidator(g)

if h then
aA=true
else
loadKeysystem()
end
else
loadKeysystem()
end
elseif not ay.KeySystem.API then
if ay.KeySystem.SaveKey and isfile(f)then
local g=readfile(f)
local h=(type(ay.KeySystem.Key)=="table")
and table.find(ay.KeySystem.Key,g)
or tostring(ay.KeySystem.Key)==tostring(g)

if h then
aA=true
else
loadKeysystem()
end
else
loadKeysystem()
end
else
if isfile(f)then
local g=readfile(f)
local h=false

for j,l in next,ay.KeySystem.API do
local m=aa.Services[l.Type]
if m then
local p={}
for r,u in next,m.Args do
table.insert(p,l[u])
end

local r=m.New(table.unpack(p))
local u=r.Verify(g)
if u then
h=true
break
end
end
end

aA=h
if not h then loadKeysystem()end
else
loadKeysystem()
end
end

repeat task.wait()until aA
end

local f=az(ay)

aa.Transparent=ay.Transparent
aa.Window=f

if ay.Acrylic then
as.init()
end













return f
end

return aa