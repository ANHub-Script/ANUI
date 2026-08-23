--[[
     _      ___         ____  ______
    | | /| / (_)__  ___/ / / / /  _/
    | |/ |/ / / _ \/ _  / /_/ // /  
    |__/|__/_/_//_/\_,_/\____/___/
    
    v1.0.262  |  2026-08-23  |  Roblox UI Library for scripts
    
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

if type(r)=="table"then return nil end
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











p.ImageScaleTypes={
Default="Fit",
Thumbnail="Crop",
TabImage="Crop",
ProfileBanner="Crop",
ProfileAvatar="Crop",
Background="Crop",
}


p.ImageNativeSizes={}
p.AutoDetectNativeSize=true

local v={
"ScaleType","Fit","Crop","Stretch","KeepAspect","Native","Original",
"NativeSize","ResampleMode","Size","ImageRectOffset","ImageRectSize","OnNativeSize",
}

function p.SetImageScaleType(x,z)
if type(x)=="table"then
for A,B in pairs(x)do
p.ImageScaleTypes[A]=B
end
return p.ImageScaleTypes
end
if z==nil then
x,z="Default",x
end
p.ImageScaleTypes[x]=z
return p.ImageScaleTypes
end

function p.ResolveImageScaleType(x,z)
z=z or{}

local A=z.ScaleType
if A==nil and z.Fit then A="Fit"end
if A==nil and z.Crop then A="Crop"end
if A==nil and z.Stretch then A="Stretch"end
if A==nil then
A=p.ImageScaleTypes[x or"Default"]or p.ImageScaleTypes.Default or"Fit"
end

if typeof(A)=="EnumItem"then
A=A.Name
end
return A
end


function p.ToVector2(x)
if typeof(x)=="Vector2"then
return x
end
if type(x)=="table"then
local z=x.X or x.x or x.Width or x[1]
local A=x.Y or x.y or x.Height or x[2]
if z and A then return Vector2.new(z,A)end
end
if type(x)=="string"then
local z,A=string.match(x,"([%d%.]+)%s*[xX:,]%s*([%d%.]+)")
if z and A then return Vector2.new(tonumber(z),tonumber(A))end
end
return nil
end

local function ReadU16BE(x,z)
local A,B=string.byte(x,z,z+1)
if not B then return nil end
return A*256+B
end

local function ReadU32BE(x,z)
local A,B,C,F=string.byte(x,z,z+3)
if not F then return nil end
return A*16777216+B*65536+C*256+F
end


function p.GetImageSizeFromData(x)
local z,A=pcall(function()
return p.ParseImageSizeFromData(x)
end)
return z and A or nil
end

function p.ParseImageSizeFromData(x)
if type(x)~="string"or#x<16 then return nil end


if string.byte(x,1)==0x89 and string.sub(x,2,4)=="PNG"then
local z,A=ReadU32BE(x,17),ReadU32BE(x,21)
if z and A and z>0 and A>0 then return Vector2.new(z,A)end
return nil
end


if string.sub(x,1,3)=="GIF"then
local z,A,B,C=string.byte(x,7,10)
if C then return Vector2.new(z+A*256,B+C*256)end
return nil
end


if string.sub(x,1,2)=="BM"and#x>=26 then
local z,A,B,C=string.byte(x,19,22)
local F,G,H,J=string.byte(x,23,26)
if J then
return Vector2.new(
z+A*256+B*65536+C*16777216,
F+G*256+H*65536+J*16777216
)
end
return nil
end


if string.byte(x,1)==0xFF and string.byte(x,2)==0xD8 then
local z=3
while z<#x-8 do
if string.byte(x,z)~=0xFF then
z=z+1
else
local A=string.byte(x,z+1)
if A==0xFF then
z=z+1
else
local B=ReadU16BE(x,z+2)
if not B or B<2 then return nil end
if A>=0xC0 and A<=0xCF
and A~=0xC4 and A~=0xC8 and A~=0xCC then
local C=ReadU16BE(x,z+5)
local F=ReadU16BE(x,z+7)
if F and C and F>0 and C>0 then return Vector2.new(F,C)end
return nil
end
z=z+2+B
end
end
end
end

return nil
end

function p.GetImageNativeSize(x)
if type(x)~="string"then return nil end
return p.ImageNativeSizes[x]
end

function p.SetImageNativeSize(x,z)
z=p.ToVector2(z)
if type(x)=="string"and z then
p.ImageNativeSizes[x]=z
end
return z
end


function p.RequestImageNativeSize(x,z)
if type(x)~="string"or x==""then return nil end

local A=p.ImageNativeSizes[x]
if A then
if z then z(A)end
return A
end
if not p.AutoDetectNativeSize then return nil end

task.spawn(function()
local B,C=pcall(function()
local B=b(game:GetService"AssetService")
local C=B:CreateEditableImageAsync(Content.fromUri(x))
local F=C and C.Size
if C then pcall(function()C:Destroy()end)end
return F
end)
if B and typeof(C)=="Vector2"and C.X>0 and C.Y>0 then
p.ImageNativeSizes[x]=C
if z then z(C)end
end
end)
return nil
end




function p.ApplyImageAspect(x,z)
z=p.ToVector2(z)
if not x or not z or z.X<=0 or z.Y<=0 then return nil end

local A=x:FindFirstChildOfClass"UIAspectRatioConstraint"
if not A then
A=Instance.new"UIAspectRatioConstraint"
A.Name="ANUIImageAspect"
A.Parent=x
end
A.AspectRatio=z.X/z.Y
A.AspectType=Enum.AspectType.FitWithinMaxSize
A.DominantAxis=Enum.DominantAxis.Width

x.AnchorPoint=Vector2.new(0.5,0.5)
x.Position=UDim2.fromScale(0.5,0.5)

return A
end

























local x={
size="Size",s="Size",
w="Width",width="Width",
h="Height",height="Height",
alpha="Transparency",transparency="Transparency",opacity="Transparency",
themed="Themed",tint="Themed",
scale="ScaleType",scaletype="ScaleType",
aspect="KeepAspect",keepaspect="KeepAspect",native="KeepAspect",
color="Color",colour="Color",
}

local z={
["true"]=true,["1"]=true,yes=true,on=true,
["false"]=false,["0"]=false,no=false,off=false,
}

local A={
fit="Fit",crop="Crop",stretch="Stretch",
}



function p.TryIcon(B)
if type(B)~="string"or B==""then return nil end
local C,F=pcall(p.Icon,B)
if C then return F end
return nil
end


local function IsImageSource(B)
if type(B)=="table"then
return(B.url or B.gif or B.mp4 or B.webm or B.file)~=nil
end
if type(B)~="string"or B==""then
return false
end
if p.TryIcon(B)then
return true
end
return string.find(B,"^rbxassetid://")~=nil
or string.find(B,"^rbxthumb://")~=nil
or string.find(B,"^rbxasset://")~=nil
or string.find(B,"^https?://")~=nil
end
p.IsImageSource=IsImageSource


local function ParseInlineAttrValue(B,C)
if B=="Size"or B=="Width"or B=="Height"then
return tonumber(C)
elseif B=="Transparency"then
local F=tonumber(C)
if not F then return nil end

if F>1 then F=F/100 end
return math.clamp(F,0,1)
elseif B=="Themed"or B=="KeepAspect"then
local F=z[string.lower(C)]
if F==nil then return true end
return F
elseif B=="ScaleType"then
return A[string.lower(C)]
elseif B=="Color"then
local F,G=pcall(Color3.fromHex,(string.gsub(C,"^#","")))
if F then return G end
return nil
end
return C
end



local function ParseInlineToken(B,C)
B=string.match(B,"^%s*(.-)%s*$")or""

local F=string.match(B,"^(%S+)")or""
local G=string.sub(B,#F+1)

local H
local J=false

local L=string.match(F,"^[Ii][Cc][Oo][Nn]:(.+)$")
if B==""or string.lower(F)=="icon"then

H=C and C.Icon
J=true
elseif L then

H=L
J=true
else
H=F
end



if J and(H==nil or H=="")then
return{Drop=true}
end

if not IsImageSource(H)then
return nil
end

local M={}
for N,O in string.gmatch(G,"([%w_]+)%s*=%s*([^%s]+)")do
local P=x[string.lower(N)]
if P then
local Q=ParseInlineAttrValue(P,O)
if Q~=nil then
M[P]=Q
end
end
end

return{Source=H,Options=M}
end


function p.HasInlineIcons(B)
if type(B)~="string"or B==""then return false end
return string.find(B,"{",1,true)~=nil
end



function p.ParseInlineText(B,C)
local F={}
if type(B)~="string"or B==""then
return F
end

local G={}
local function Flush()
if#G==0 then return end
local H=table.concat(G)
G={}
if H~=""then
table.insert(F,{Type="Text",Content=H})
end
end




local H=false
local J=false

local function DropToken()

while#G>0 and string.match(G[#G],"%s")do
table.remove(G)
J=true
end
H=true
end

local function PushChar(L)
if H then
if string.match(L,"%s")then

J=true
return
end
H=false
if J and#G>0 then
table.insert(G," ")
end
J=false
end
table.insert(G,L)
end

local L=1
local M=#B

while L<=M do
local N=string.sub(B,L,L)

if N=="{"and string.sub(B,L+1,L+1)=="{"then
PushChar"{"
L=L+2
elseif N=="}"and string.sub(B,L+1,L+1)=="}"then
PushChar"}"
L=L+2
elseif N=="{"then
local O=string.find(B,"}",L+1,true)
local P=O and ParseInlineToken(string.sub(B,L+1,O-1),C)

if not P then

PushChar(N)
L=L+1
else
if P.Drop then
DropToken()
else
H,J=false,false
Flush()
table.insert(F,{
Type="Icon",
Content=P.Source,
Options=P.Options,
})
end
L=O+1
end
else
PushChar(N)
L=L+1
end
end

Flush()




local N=false
for O,P in ipairs(F)do
if P.Type=="Icon"then
N=true
break
end
end

if N then
local O={}
for P,Q in ipairs(F)do
if Q.Type~="Text"then
table.insert(O,Q)
else
local R=Q.Content
local S=F[P-1]
local T=F[P+1]
if not S or S.Type=="Icon"then
R=string.gsub(R,"^%s+","")
end
if not T or T.Type=="Icon"then
R=string.gsub(R,"%s+$","")
end
if R~=""then
Q.Content=R
table.insert(O,Q)
end
end
end
F=O
end

return F
end



function p.StripInlineIcons(B,C)
if not p.HasInlineIcons(B)then
return type(B)=="string"and B or""
end

local F={}
for G,H in ipairs(p.ParseInlineText(B,C))do
if H.Type=="Text"then
table.insert(F,H.Content)
end
end

local G=table.concat(F," ")
return(string.match(G,"^%s*(.-)%s*$"))or G
end



function p.MaxInlineIconSize(B,C,F)
F=F or 0
if not p.HasInlineIcons(B)then
return F
end

local G=F
for H,J in ipairs(p.ParseInlineText(B,C))do
if J.Type=="Icon"then
local L=J.Options or{}
local M=L.Height or L.Size
or(C and C.IconSize)or F
if M and M>G then
G=M
end
end
end
return G
end




local function InlineIconCacheName(B,C,F)
local G=B
if type(B)=="table"then
G=B.url or B.gif or B.mp4 or B.webm or B.file or"icon"
end
G=tostring(G)
G=string.match(G,"([^/]+)$")or G
G=string.gsub(G,"[^%w%-_]","_")
if#G>24 then
G=string.sub(G,1,24)
end
return(F or"Inline").."-"..tostring(C or 1).."-"..G
end
p.InlineIconCacheName=InlineIconCacheName



function p.InlineIconFrame(B,C)
if type(B)~="table"or B.Type~="Icon"then return nil end

local F=B.Content
if not IsImageSource(F)then return nil end

C=C or{}
local G=B.Options or{}

local H=G.Height or G.Size or C.IconSize or 18
local J=G.Width or G.Size or H

local L=G.Themed
if L==nil then L=C.IconThemed end

if L==nil then L=p.TryIcon(F)~=nil end

if G.Color then L=false end

local M=G.KeepAspect
if M==nil then M=C.IconKeepAspect end

local N=p.Image(
F,
InlineIconCacheName(F,C.Index,C.CachePrefix),
0,
C.Folder,
C.ImageKind or"Icon",
L and true or false,
L and true or false,
C.ThemeTagName or"Text",
{
ScaleType=G.ScaleType or C.IconScaleType,
KeepAspect=M,
Size=UDim2.fromOffset(J,H),
}
)
if not N then return nil end

N.Name="InlineIcon"
N.Size=UDim2.fromOffset(J,H)
N.BackgroundTransparency=1

local O=N:FindFirstChildOfClass"ImageLabel"
if O then
local P=G.Transparency
if P==nil then P=C.IconTransparency end
if P~=nil then
O.ImageTransparency=P
end
if G.Color then

p.Objects[O]=nil
O.ImageColor3=G.Color
end
end

return N,O
end



function p.TrySetWraps(B,C)
if not B then return false end
return(pcall(function()
B.Wraps=C~=false
end))
end

function p.Image(B,C,F,G,H,J,L,M,N)
G=G or"Temp"
C=p.SanitizeFilename(C)



local O={}
if type(N)=="table"then
for P,Q in pairs(N)do O[P]=Q end
end
if type(B)=="table"then
for P,Q in ipairs(v)do
if O[Q]==nil and B[Q]~=nil then
O[Q]=B[Q]
end
end
end

local P=p.ResolveImageScaleType(H,O)
local Q=(O.KeepAspect or O.Native or O.Original)and true or false
local R=Q or type(O.OnNativeSize)=="function"

local S=(O.ScaleType or O.Crop or O.Stretch or O.Fit)and P or"Fit"

local T=r("Frame",{
Size=O.Size or UDim2.new(0,0,0,0),
BackgroundTransparency=1,
},{
r("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScaleType=P,
ResampleMode=O.ResampleMode or nil,
ThemeTag=(p.Icon(B)or L)and{
ImageColor3=J and(M or"Icon")or nil
}or nil,
},{
r("UICorner",{
CornerRadius=UDim.new(0,F)
})
})
})
local U=T:FindFirstChildOfClass"ImageLabel"
local V=(type(B)=="table"and B.url)or B
local W=(type(B)=="table"and(B.gif or B.file))or nil
local X=(type(B)=="table"and B.mp4)or nil
local Y=(type(B)=="table"and B.webm)or nil


local function SetNativeSize(_)
_=p.ToVector2(_)
if not _ or _.X<=0 or _.Y<=0 then return end
if type(V)=="string"then
p.ImageNativeSizes[V]=_
end
if Q and U then
p.ApplyImageAspect(U,_)
end
if type(O.OnNativeSize)=="function"then
pcall(O.OnNativeSize,_,T)
end
end


local function ReadNativeSizeFromFile(_)
if not R then return end
if not(isfile and readfile and isfile(_))then return end
local aa,ab=pcall(readfile,_)
if aa then
SetNativeSize(p.GetImageSizeFromData(ab))
end
end


if U and O.ImageRectOffset then
U.ImageRectOffset=p.ToVector2(O.ImageRectOffset)or Vector2.zero
end
if U and O.ImageRectSize then
local aa=p.ToVector2(O.ImageRectSize)
if aa then
U.ImageRectSize=aa
SetNativeSize(aa)
end
end
if O.NativeSize then
SetNativeSize(O.NativeSize)
end

if type(V)=="string"and p.Icon(V)then
local aa=p.Icon(V)
if not U then
U=r("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScaleType=P,
})
U.Parent=T
end
U.Image=aa[1]
U.ImageRectOffset=aa[2].ImageRectPosition
U.ImageRectSize=aa[2].ImageRectSize
SetNativeSize(aa[2].ImageRectSize)
elseif type(V)=="string"and string.find(V,"http")then
local aa="ANUI/"..G.."/assets"
if isfolder and makefolder then
if not isfolder"ANUI"then makefolder"ANUI"end
if not isfolder("ANUI/"..G)then makefolder("ANUI/"..G)end
if not isfolder(aa)then makefolder(aa)end
end
local ab,ac=pcall(function()
task.spawn(function()
local ab=GetBaseUrl(V)
local _=LoadUrlMap(aa)
local ac=_[ab]
if Y and isfile and isfile(aa.."/"..Y)then
local ad,ae=pcall(getcustomasset,aa.."/"..Y)
if ad then
local af=r("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=ae,
Looped=true,
Volume=0,
},{
r("UICorner",{CornerRadius=UDim.new(0,F)})
})
af.Parent=T
U.Visible=false
af:Play()
_[ab]=_[ab]or{}
_[ab].webm=Y
SaveUrlMap(aa,_)
return
end
end
if X and isfile and isfile(aa.."/"..X)then
local ad,ae=pcall(getcustomasset,aa.."/"..X)
if ad then
local af=r("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=ae,
Looped=true,
Volume=0,
},{
r("UICorner",{CornerRadius=UDim.new(0,F)})
})
af.Parent=T
U.Visible=false
af:Play()
_[ab]=_[ab]or{}
_[ab].mp4=X
SaveUrlMap(aa,_)
return
end
end
if W and isfile and isfile(aa.."/"..W)then
local ad,ae=pcall(getcustomasset,aa.."/"..W)
if ad and U then
U.Image=ae
U.ScaleType=S
ReadNativeSizeFromFile(aa.."/"..W)
end
end
if ac and ac.mp4 and isfile and isfile(aa.."/"..ac.mp4)then
local ad,ae=pcall(getcustomasset,aa.."/"..ac.mp4)
if ad then
local af=r("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=ae,
Looped=true,
Volume=0,
},{
r("UICorner",{CornerRadius=UDim.new(0,F)})
})
af.Parent=T
U.Visible=false
af:Play()
return
end
end
if ac and ac.webm and isfile and isfile(aa.."/"..ac.webm)then
local ad,ae=pcall(getcustomasset,aa.."/"..ac.webm)
if ad then
local af=r("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=ae,
Looped=true,
Volume=0,
},{
r("UICorner",{CornerRadius=UDim.new(0,F)})
})
af.Parent=T
U.Visible=false
af:Play()
return
end
end
if ac and ac.gif and isfile and isfile(aa.."/"..ac.gif)then
local ad,ae=pcall(getcustomasset,aa.."/"..ac.gif)
if ad and U then
U.Image=ae
U.ScaleType=S
ReadNativeSizeFromFile(aa.."/"..ac.gif)
end
local af=p.ConvertGifToWebm(V,aa,H,C)
if af then
ac.webm=H.."-"..C..".webm"
SaveUrlMap(aa,_)
local ag=r("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=af,
Looped=true,
Volume=0,
},{
r("UICorner",{CornerRadius=UDim.new(0,F)})
})
ag.Parent=T
U.Visible=false
ag:Play()
return
end
end
local ad=p.Request{Url=V,Method="GET"}
local ae=ad and(ad.Body or ad)or""
local af=GetBaseUrl(V)
local ag=string.lower((af:match"%.([%w]+)$"or""))
local ah
if ad and ad.Headers then
ah=ad.Headers["Content-Type"]or ad.Headers["content-type"]or ad.Headers["Content-type"]
end
if not ag or ag==""then
if ah then
if string.find(ah,"gif")then ag="gif"
elseif string.find(ah,"jpeg")or string.find(ah,"jpg")then ag="jpg"
elseif string.find(ah,"png")then ag="png"else ag="png"end
else
ag="png"
end
end
local ai=H.."-"..C.."."..ag
local aj=aa.."/"..ai
writefile(aj,ae)
if R then
SetNativeSize(p.GetImageSizeFromData(ae))
end
_[af]=_[af]or{}
if ag=="gif"then
_[af].gif=ai
SaveUrlMap(aa,_)
if U then U.ScaleType=S end
local ak=p.ConvertGifToWebm(V,aa,H,C)
if ak then
_[af].webm=H.."-"..C..".webm"
SaveUrlMap(aa,_)
local al=r("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=ak,
Looped=true,
Volume=0,
},{
r("UICorner",{CornerRadius=UDim.new(0,F)})
})
al.Parent=T
U.Visible=false
al:Play()
return
end
end
local ak,al=pcall(getcustomasset,aj)
if ak then
if U then U.Image=al end
else
warn(string.format("[ ANUI.Creator ] Failed to load custom asset '%s': %s",aj,tostring(al)))
T:Destroy()
return
end
end)
end)
if not ab then
warn("[ ANUI.Creator ]  '"..tostring(identifyexecutor and identifyexecutor()or"unknown").."' doesnt support the URL Images. Error: "..tostring(ac))
T:Destroy()
end
elseif V==""then
T.Visible=false
else
if U then U.Image=V end
if R then
p.RequestImageNativeSize(V,SetNativeSize)
end
end

return T
end


return p end function a.c()

local aa={}







function aa.New(ab,ac,ad)
local ae={
Enabled=ac.Enabled or false,
Translations=ac.Translations or{},
Prefix=ac.Prefix or"loc:",
DefaultLanguage=ac.DefaultLanguage or"en"
}

ad.Localization=ae

return ae
end



return aa end function a.d()
local aa=a.load'b'
local ab=aa.New
local ac=aa.Tween

local ad={
Size=UDim2.new(0,300,1,-156),
SizeLower=UDim2.new(0,300,1,-56),
UICorner=13,
UIPadding=14,

Holder=nil,
NotificationIndex=0,
Notifications={}
}

function ad.Init(ae)
local af={
Lower=false
}

function af.SetLower(ag)
af.Lower=ag
af.Frame.Size=ag and ad.SizeLower or ad.Size
end

af.Frame=ab("Frame",{
Position=UDim2.new(1,-29,0,56),
AnchorPoint=Vector2.new(1,0),
Size=ad.Size,
Parent=ae,
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
return af
end

function ad.New(ae)
local af={
Title=ae.Title or"Notification",
Content=ae.Content or nil,
Icon=ae.Icon or nil,
IconThemed=ae.IconThemed,
Background=ae.Background,
BackgroundImageTransparency=ae.BackgroundImageTransparency,
Duration=ae.Duration or 5,
Buttons=ae.Buttons or{},
CanClose=true,
UIElements={},
Closed=false,
}
if af.CanClose==nil then
af.CanClose=true
end
ad.NotificationIndex=ad.NotificationIndex+1
ad.Notifications[ad.NotificationIndex]=af









local ag

if af.Icon then





















ag=aa.Image(
af.Icon,
af.Title..":"..af.Icon,
0,
ae.Window,
"Notification",
af.IconThemed
)
ag.Size=UDim2.new(0,26,0,26)
ag.Position=UDim2.new(0,ad.UIPadding,0,ad.UIPadding)

end

local ah
if af.CanClose then
ah=ab("ImageButton",{
Image=aa.Icon"x"[1],
ImageRectSize=aa.Icon"x"[2].ImageRectSize,
ImageRectOffset=aa.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
Size=UDim2.new(0,16,0,16),
Position=UDim2.new(1,-ad.UIPadding,0,ad.UIPadding),
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

local ai=ab("Frame",{
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=.95,
ThemeTag={
BackgroundColor3="Text",
},

})

local aj=ab("Frame",{
Size=UDim2.new(1,
af.Icon and-28-ad.UIPadding or 0,
1,0),
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
AutomaticSize="Y",
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,ad.UIPadding),
PaddingLeft=UDim.new(0,ad.UIPadding),
PaddingRight=UDim.new(0,ad.UIPadding),
PaddingBottom=UDim.new(0,ad.UIPadding),
}),
ab("TextLabel",{
AutomaticSize="Y",
Size=UDim2.new(1,-30-ad.UIPadding,0,0),
TextWrapped=true,
TextXAlignment="Left",
RichText=true,
BackgroundTransparency=1,
TextSize=16,
ThemeTag={
TextColor3="Text"
},
Text=af.Title,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium)
}),
ab("UIListLayout",{
Padding=UDim.new(0,ad.UIPadding/3)
})
})

if af.Content then
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
Text=af.Content,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
Parent=aj
})
end


local ak=aa.NewRoundFrame(ad.UICorner,"Squircle",{
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
ai,
ab("UICorner",{
CornerRadius=UDim.new(0,ad.UICorner),
})

}),
ab("ImageLabel",{
Name="Background",
Image=af.Background,
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
ScaleType="Crop",
ImageTransparency=af.BackgroundImageTransparency

},{
ab("UICorner",{
CornerRadius=UDim.new(0,ad.UICorner),
})
}),

aj,
ag,ah,
})

local al=ab("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
Parent=ae.Holder
},{
ak
})

function af.Close(b)
if not af.Closed then
af.Closed=true
ac(al,0.45,{Size=UDim2.new(1,0,0,-8)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ac(ak,0.55,{Position=UDim2.new(2,0,1,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
task.wait(.45)
al:Destroy()
end
end

task.spawn(function()
task.wait()
ac(al,0.45,{Size=UDim2.new(
1,
0,
0,
ak.AbsoluteSize.Y
)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ac(ak,0.45,{Position=UDim2.new(0,0,1,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if af.Duration then
ac(ai,af.Duration,{Size=UDim2.new(1,0,1,0)},Enum.EasingStyle.Linear,Enum.EasingDirection.InOut):Play()
task.wait(af.Duration)
af:Close()
end
end)

if ah then
aa.AddSignal(ah.TextButton.MouseButton1Click,function()
af:Close()
end)
end


return af
end

return ad end function a.e()











local aa=4294967296;local ab=aa-1;local function c(ac,ad)local ae,af=0,1;while ac~=0 or ad~=0 do local ag,ah=ac%2,ad%2;local ai=(ag+ah)%2;ae=ae+ai*af;ac=math.floor(ac/2)ad=math.floor(ad/2)af=af*2 end;return ae%aa end;local function k(ac,ad,ae,...)local af;if ad then ac=ac%aa;ad=ad%aa;af=c(ac,ad)if ae then af=k(af,ae,...)end;return af elseif ac then return ac%aa else return 0 end end;local function n(ac,ad,ae,...)local af;if ad then ac=ac%aa;ad=ad%aa;af=(ac+ad-c(ac,ad))/2;if ae then af=n(af,ae,...)end;return af elseif ac then return ac%aa else return ab end end;local function o(ac)return ab-ac end;local function q(ac,ad)if ad<0 then return lshift(ac,-ad)end;return math.floor(ac%4294967296/2^ad)end;local function s(ac,ad)if ad>31 or ad<-31 then return 0 end;return q(ac%aa,ad)end;local function lshift(ac,ad)if ad<0 then return s(ac,-ad)end;return ac*2^ad%4294967296 end;local function t(ac,ad)ac=ac%aa;ad=ad%32;local ae=n(ac,2^ad-1)return s(ac,ad)+lshift(ae,32-ad)end;local ac={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(ad)return string.gsub(ad,".",function(ae)return string.format("%02x",string.byte(ae))end)end;local function y(ad,ae)local af=""for ag=1,ae do local ah=ad%256;af=string.char(ah)..af;ad=(ad-ah)/256 end;return af end;local function D(ad,ae)local af=0;for ag=ae,ae+3 do af=af*256+string.byte(ad,ag)end;return af end;local function E(ad,ae)local af=64-(ae+9)%64;ae=y(8*ae,8)ad=ad.."\128"..string.rep("\0",af)..ae;assert(#ad%64==0)return ad end;local function I(ad)ad[1]=0x6a09e667;ad[2]=0xbb67ae85;ad[3]=0x3c6ef372;ad[4]=0xa54ff53a;ad[5]=0x510e527f;ad[6]=0x9b05688c;ad[7]=0x1f83d9ab;ad[8]=0x5be0cd19;return ad end;local function K(ad,ae,af)local ag={}for ah=1,16 do ag[ah]=D(ad,ae+(ah-1)*4)end;for ah=17,64 do local ai=ag[ah-15]local aj=k(t(ai,7),t(ai,18),s(ai,3))ai=ag[ah-2]ag[ah]=(ag[ah-16]+aj+ag[ah-7]+k(t(ai,17),t(ai,19),s(ai,10)))%aa end;local ah,ai,aj,ak,al,b,d,e=af[1],af[2],af[3],af[4],af[5],af[6],af[7],af[8]for f=1,64 do local g=k(t(ah,2),t(ah,13),t(ah,22))local h=k(n(ah,ai),n(ah,aj),n(ai,aj))local j=(g+h)%aa;local l=k(t(al,6),t(al,11),t(al,25))local m=k(n(al,b),n(o(al),d))local p=(e+l+m+ac[f]+ag[f])%aa;e=d;d=b;b=al;al=(ak+p)%aa;ak=aj;aj=ai;ai=ah;ah=(p+j)%aa end;af[1]=(af[1]+ah)%aa;af[2]=(af[2]+ai)%aa;af[3]=(af[3]+aj)%aa;af[4]=(af[4]+ak)%aa;af[5]=(af[5]+al)%aa;af[6]=(af[6]+b)%aa;af[7]=(af[7]+d)%aa;af[8]=(af[8]+e)%aa end;local function Z(ad)ad=E(ad,#ad)local ae=I{}for af=1,#ad,64 do K(ad,af,ae)end;return w(y(ae[1],4)..y(ae[2],4)..y(ae[3],4)..y(ae[4],4)..y(ae[5],4)..y(ae[6],4)..y(ae[7],4)..y(ae[8],4))end;local ad;local ae={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local af={["/"]="/"}for ag,ah in pairs(ae)do af[ah]=ag end;local ag=function(ag)return"\\"..(ae[ag]or string.format("u%04x",ag:byte()))end;local ah=function(ah)return"null"end;local ai=function(ai,aj)local ak={}aj=aj or{}if aj[ai]then error"circular reference"end;aj[ai]=true;if rawget(ai,1)~=nil or next(ai)==nil then local al=0;for b in pairs(ai)do if type(b)~="number"then error"invalid table: mixed or invalid key types"end;al=al+1 end;if al~=#ai then error"invalid table: sparse array"end;for b,d in ipairs(ai)do table.insert(ak,ad(d,aj))end;aj[ai]=nil;return"["..table.concat(ak,",").."]"else for al,b in pairs(ai)do if type(al)~="string"then error"invalid table: mixed or invalid key types"end;table.insert(ak,ad(al,aj)..":"..ad(b,aj))end;aj[ai]=nil;return"{"..table.concat(ak,",").."}"end end;local aj=function(aj)return'"'..aj:gsub('[%z\1-\31\\"]',ag)..'"'end;local ak=function(ak)if ak~=ak or ak<=-math.huge or ak>=math.huge then error("unexpected number value '"..tostring(ak).."'")end;return string.format("%.14g",ak)end;local al={["nil"]=ah,table=ai,string=aj,number=ak,boolean=tostring}ad=function(b,d)local e=type(b)local f=al[e]if f then return f(b,d)end;error("unexpected type '"..e.."'")end;local b=function(b)return ad(b)end;local d;local e=function(...)local e={}for f=1,select("#",...)do e[select(f,...)]=true end;return e end;local f=e(" ","\t","\r","\n")local g=e(" ","\t","\r","\n","]","}",",")local h=e("\\","/",'"',"b","f","n","r","t","u")local j=e("true","false","null")local l={["true"]=true,["false"]=false,null=nil}local m=function(m,p,r,u)for v=p,#m do if r[m:sub(v,v)]~=u then return v end end;return#m+1 end;local p=function(p,r,u)local v=1;local x=1;for z=1,r-1 do x=x+1;if p:sub(z,z)=="\n"then v=v+1;x=1 end end;error(string.format("%s at line %d col %d",u,v,x))end;local r=function(r)local u=math.floor;if r<=0x7f then return string.char(r)elseif r<=0x7ff then return string.char(u(r/64)+192,r%64+128)elseif r<=0xffff then return string.char(u(r/4096)+224,u(r%4096/64)+128,r%64+128)elseif r<=0x10ffff then return string.char(u(r/262144)+240,u(r%262144/4096)+128,u(r%4096/64)+128,r%64+128)end;error(string.format("invalid unicode codepoint '%x'",r))end;local u=function(u)local v=tonumber(u:sub(1,4),16)local x=tonumber(u:sub(7,10),16)if x then return r((v-0xd800)*0x400+x-0xdc00+0x10000)else return r(v)end end;local v=function(v,x)local z=""local A=x+1;local B=A;while A<=#v do local C=v:byte(A)if C<32 then p(v,A,"control character in string")elseif C==92 then z=z..v:sub(B,A-1)A=A+1;local F=v:sub(A,A)if F=="u"then local G=v:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",A+1)or v:match("^%x%x%x%x",A+1)or p(v,A-1,"invalid unicode escape in string")z=z..u(G)A=A+#G else if not h[F]then p(v,A-1,"invalid escape char '"..F.."' in string")end;z=z..af[F]end;B=A+1 elseif C==34 then z=z..v:sub(B,A-1)return z,A+1 end;A=A+1 end;p(v,x,"expected closing quote for string")end;local x=function(x,z)local A=m(x,z,g)local B=x:sub(z,A-1)local C=tonumber(B)if not C then p(x,z,"invalid number '"..B.."'")end;return C,A end;local z=function(z,A)local B=m(z,A,g)local C=z:sub(A,B-1)if not j[C]then p(z,A,"invalid literal '"..C.."'")end;return l[C],B end;local A=function(A,B)local C={}local F=1;B=B+1;while 1 do local G;B=m(A,B,f,true)if A:sub(B,B)=="]"then B=B+1;break end;G,B=d(A,B)C[F]=G;F=F+1;B=m(A,B,f,true)local H=A:sub(B,B)B=B+1;if H=="]"then break end;if H~=","then p(A,B,"expected ']' or ','")end end;return C,B end;local B=function(B,C)local F={}C=C+1;while 1 do local G,H;C=m(B,C,f,true)if B:sub(C,C)=="}"then C=C+1;break end;if B:sub(C,C)~='"'then p(B,C,"expected string for key")end;G,C=d(B,C)C=m(B,C,f,true)if B:sub(C,C)~=":"then p(B,C,"expected ':' after key")end;C=m(B,C+1,f,true)H,C=d(B,C)F[G]=H;C=m(B,C,f,true)local J=B:sub(C,C)C=C+1;if J=="}"then break end;if J~=","then p(B,C,"expected '}' or ','")end end;return F,C end;local C={['"']=v,["0"]=x,["1"]=x,["2"]=x,["3"]=x,["4"]=x,["5"]=x,["6"]=x,["7"]=x,["8"]=x,["9"]=x,["-"]=x,t=z,f=z,n=z,["["]=A,["{"]=B}d=function(F,G)local H=F:sub(G,G)local J=C[H]if J then return J(F,G)end;p(F,G,"unexpected character '"..H.."'")end;local F=function(F)if type(F)~="string"then error("expected argument of type string, got "..type(F))end;local G,H=d(F,m(F,1,f,true))H=m(F,H,f,true)if H<=#F then p(F,H,"trailing garbage")end;return G end;
local G,H,J=b,F,Z;





local L={}

local M=(cloneref or clonereference or function(M)return M end)


function L.New(N,O)

local P=N;
local Q=O;
local R=true;


local S=function(S)end;


repeat task.wait(1)until game:IsLoaded();


local T=false;
local U,V,W,X,Y,_,am,an,ao=setclipboard or toclipboard,request or http_request or syn_request,string.char,tostring,string.sub,os.time,math.random,math.floor,gethwid or function()return M(game:GetService"Players").LocalPlayer.UserId end
local ap,aq="",0;


local ar="https://api.platoboost.app";
local as=V{
Url=ar.."/public/connectivity",
Method="GET"
};
if as.StatusCode~=200 and as.StatusCode~=429 then
ar="https://api.platoboost.net";
end


function cacheLink()
if aq+(600)<_()then
local at=V{
Url=ar.."/public/start",
Method="POST",
Body=G{
service=P,
identifier=J(ao())
},
Headers={
["Content-Type"]="application/json",
["User-Agent"]="Roblox/Exploit"
}
};

if at.StatusCode==200 then
local au=H(at.Body);

if au.success==true then
ap=au.data.url;
aq=_();
return true,ap
else
S(au.message);
return false,au.message
end
elseif at.StatusCode==429 then
local au="you are being rate limited, please wait 20 seconds and try again.";
S(au);
return false,au
end

local au="Failed to cache link.";
S(au);
return false,au
else
return true,ap
end
end

cacheLink();


local at=function()
local at=""
for au=1,16 do
at=at..W(an(am()*(26))+97)
end
return at
end


for au=1,5 do
local av=at();
task.wait(0.2)
if at()==av then
local aw="platoboost nonce error.";
S(aw);
error(aw);
end
end


local au=function()
local au,av=cacheLink();

if au then
U(av);
end
end


local av=function(av)
local aw=at();
local ax=ar.."/public/redeem/"..X(P);

local ay={
identifier=J(ao()),
key=av
}

if R then
ay.nonce=aw;
end

local az=V{
Url=ax,
Method="POST",
Body=G(ay),
Headers={
["Content-Type"]="application/json"
}
};

if az.StatusCode==200 then
local aA=H(az.Body);

if aA.success==true then
if aA.data.valid==true then
if R then
if aA.data.hash==J("true".."-"..aw.."-"..Q)then
return true
else
S"failed to verify integrity.";
return false
end
else
return true
end
else
S"key is invalid.";
return false
end
else
if Y(aA.message,1,27)=="unique constraint violation"then
S"you already have an active key, please wait for it to expire before redeeming it.";
return false
else
S(aA.message);
return false
end
end
elseif az.StatusCode==429 then
S"you are being rate limited, please wait 20 seconds and try again.";
return false
else
S"server returned an invalid status code, please try again later.";
return false
end
end


local aw=function(aw)
if T==true then
return false,("A request is already being sent, please slow down.")
else
T=true;
end

local ax=at();
local ay=ar.."/public/whitelist/"..X(P).."?identifier="..J(ao()).."&key="..aw;

if R then
ay=ay.."&nonce="..ax;
end

local az=V{
Url=ay,
Method="GET",
};

T=false;

if az.StatusCode==200 then
local aA=H(az.Body);

if aA.success==true then
if aA.data.valid==true then
if R then
if aA.data.hash==J("true".."-"..ax.."-"..Q)then
return true,""
else
return false,("failed to verify integrity.")
end
else
return true
end
else
if Y(aw,1,4)=="KEY_"then
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
local az=ar.."/public/flag/"..X(P).."?name="..ax;

if R then
az=az.."&nonce="..ay;
end

local aA=V{
Url=az,
Method="GET",
};

if aA.StatusCode==200 then
local aB=H(aA.Body);

if aB.success==true then
if R then
if aB.data.hash==J(X(aB.data.value).."-"..ay.."-"..Q)then
return aB.data.value
else
S"failed to verify integrity.";
return nil
end
else
return aB.data.value
end
else
S(aB.message);
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


return L end function a.f()









local aa=(cloneref or clonereference or function(aa)return aa end)

local ab=aa(game:GetService"HttpService")
local ad={}



function ad.New(ae)
local af=gethwid or function()return aa(game:GetService"Players").LocalPlayer.UserId end
local ag,ah=request or http_request or syn_request,setclipboard or toclipboard

function ValidateKey(ai)
local aj="https://pandadevelopment.net/v2_validation?key="..tostring(ai).."&service="..tostring(ae).."&hwid="..tostring(af())


local ak,al=pcall(function()
return ag{
Url=aj,
Method="GET",
Headers={["User-Agent"]="Roblox/Exploit"}
}
end)

if ak and al then
if al.Success then
local am,an=pcall(function()
return ab:JSONDecode(al.Body)
end)

if am and an then
if an.V2_Authentication and an.V2_Authentication=="success"then

return true,"Authenticated"
else
local ao=an.Key_Information.Notes or"Unknown reason"

return false,"Authentication failed: "..ao
end
else

return false,"JSON decode error"
end
else
warn("[Pelinda Ov2.5] HTTP request was not successful. Code: "..tostring(al.StatusCode).." Message: "..al.StatusMessage)
return false,"HTTP request failed: "..al.StatusMessage
end
else

return false,"Request pcall error"
end
end

function GetKeyLink()
return"https://pandadevelopment.net/getkey?service="..tostring(ae).."&hwid="..tostring(af())
end

function CopyLink()
return ah(GetKeyLink())
end

return{
Verify=ValidateKey,
Copy=CopyLink
}
end

return ad end function a.g()








local aa={}


function aa.New(ab,ad)
local ae="https://sdkapi-public.luarmor.net/library.lua"

local af=loadstring(
game.HttpGetAsync and game:HttpGetAsync(ae)
or HttpService:GetAsync(ae)
)()
local ag=setclipboard or toclipboard

af.script_id=ab

function ValidateKey(ah)
local ai=af.check_key(ah);


if(ai.code=="KEY_VALID")then
return true,"Whitelisted!"

elseif(ai.code=="KEY_HWID_LOCKED")then
return false,"Key linked to a different HWID. Please reset it using our bot"

elseif(ai.code=="KEY_INCORRECT")then
return false,"Key is wrong or deleted!"
else
return false,"Key check failed:"..ai.message.." Code: "..ai.code
end
end

function CopyLink()
ag(tostring(ad))
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
    "version": "1.0.262",
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

]]end function a.j()local aa={}local ab=a.load'b'local ad=ab.New local ae=ab.Tween function aa.New(af,ag,ah,ai,aj,ak,al,am)ai=ai or"Primary"local an=am or(not al and 10 or 99)local ao if ag and ag~=""then ao=ad("ImageLabel",{Image=ab.Icon(ag)[1],ImageRectSize=ab.Icon(ag)[2].ImageRectSize,ImageRectOffset=ab.Icon(ag)[2].ImageRectPosition,Size=UDim2.new(0,21,0,21),BackgroundTransparency=1,ImageColor3=ai=="White"and Color3.new(0,0,0)or nil,ImageTransparency=ai=="White"and.4 or 0,ThemeTag={ImageColor3=ai~="White"and"Icon"or nil,}})end local ap=ad("TextButton",{Size=UDim2.new(0,0,1,0),AutomaticSize="X",Parent=aj,BackgroundTransparency=1},{
ab.NewRoundFrame(an,"Squircle",{
ThemeTag={
ImageColor3=ai~="White"and"Button"or nil,
},
ImageColor3=ai=="White"and Color3.new(1,1,1)or nil,
Size=UDim2.new(1,0,1,0),
Name="Squircle",
ImageTransparency=ai=="Primary"and 0 or ai=="White"and 0 or 1
}),

ab.NewRoundFrame(an,"Squircle",{



ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(1,0,1,0),
Name="Special",
ImageTransparency=ai=="Secondary"and 0.95 or 1
}),

ab.NewRoundFrame(an,"Shadow-sm",{



ImageColor3=Color3.new(0,0,0),
Size=UDim2.new(1,3,1,3),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Shadow",

ImageTransparency=1,
Visible=not al
}),

ab.NewRoundFrame(an,not al and"SquircleOutline"or"SquircleOutline2",{
ThemeTag={
ImageColor3=ai~="White"and"Outline"or nil,
},
Size=UDim2.new(1,0,1,0),
ImageColor3=ai=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=ai=="Primary"and.95 or.85,
Name="SquircleOutline",
},{
ad("UIGradient",{
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

ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3=ai~="White"and"Text"or nil
},
ImageColor3=ai=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=1
},{
ad("UIPadding",{
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
}),
ad("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
ao,
ad("TextLabel",{
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=af or"Button",
ThemeTag={
TextColor3=(ai~="Primary"and ai~="White")and"Text",
},
TextColor3=ai=="Primary"and Color3.new(1,1,1)or ai=="White"and Color3.new(0,0,0)or nil,
AutomaticSize="XY",
TextSize=18,
})
})
})

ab.AddSignal(ap.MouseEnter,function()
ae(ap.Frame,.047,{ImageTransparency=.95}):Play()
end)
ab.AddSignal(ap.MouseLeave,function()
ae(ap.Frame,.047,{ImageTransparency=1}):Play()
end)
ab.AddSignal(ap.MouseButton1Up,function()
if ak then
ak:Close()()
end
if ah then
ab.SafeCallback(ah)
end
end)

return ap
end


return aa end function a.k()
local aa={}

local ab=a.load'b'
local ad=ab.New local ae=
ab.Tween


function aa.New(af,ag,ah,ai,aj,ak,al,am)
ai=ai or"Input"
local an=al or 10
local ao
if ag and ag~=""then
ao=ad("ImageLabel",{
Image=ab.Icon(ag)[1],
ImageRectSize=ab.Icon(ag)[2].ImageRectSize,
ImageRectOffset=ab.Icon(ag)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local ap=ai~="Input"

local aq=ad("TextBox",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,ao and-29 or 0,1,0),
PlaceholderText=af,
ClearTextOnFocus=am or false,
ClipsDescendants=true,
TextWrapped=ap,
MultiLine=ap,
TextXAlignment="Left",
TextYAlignment=ai=="Input"and"Center"or"Top",

ThemeTag={
PlaceholderColor3="PlaceholderText",
TextColor3="Text",
},
})

local ar=ad("Frame",{
Size=UDim2.new(1,0,0,42),
Parent=ah,
BackgroundTransparency=1
},{
ad("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(an,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.97,
}),
ab.NewRoundFrame(an,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.95,
},{













}),
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.95
},{
ad("UIPadding",{
PaddingTop=UDim.new(0,ai=="Input"and 0 or 12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,ai=="Input"and 0 or 12),
}),
ad("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment=ai=="Input"and"Center"or"Top",
HorizontalAlignment="Left",
}),
ao,
aq,
})
})
})










if ak then
ab.AddSignal(aq:GetPropertyChangedSignal"Text",function()
if aj then
ab.SafeCallback(aj,aq.Text)
end
end)
else
ab.AddSignal(aq.FocusLost,function()
if aj then
ab.SafeCallback(aj,aq.Text)
end
end)
end

return ar
end


return aa end function a.l()
local aa=a.load'b'
local ab=aa.New
local ad=aa.Tween



local ae={
Holder=nil,

Parent=nil,
}

function ae.Init(af,ag)
Window=af
ae.Parent=ag
return ae
end

function ae.Create(af,ag)
local ah={
UICorner=24,
UIPadding=15,
UIElements={}
}

if af then ah.UIPadding=0 end
if af then ah.UICorner=26 end

ag=ag or"Dialog"

if not af then
ah.UIElements.FullScreen=ab("Frame",{
ZIndex=999,
BackgroundTransparency=1,
BackgroundColor3=Color3.fromHex"#000000",
Size=UDim2.new(1,0,1,0),
Active=false,
Visible=false,
Parent=ae.Parent or(Window and Window.UIElements and Window.UIElements.Main and Window.UIElements.Main.Main)
},{
ab("UICorner",{
CornerRadius=UDim.new(0,Window.UICorner)
})
})
end

ah.UIElements.Main=ab("Frame",{
Size=UDim2.new(0,280,0,0),
ThemeTag={
BackgroundColor3=ag.."Background",
},
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=false,
ZIndex=99999,
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,ah.UIPadding),
PaddingLeft=UDim.new(0,ah.UIPadding),
PaddingRight=UDim.new(0,ah.UIPadding),
PaddingBottom=UDim.new(0,ah.UIPadding),
})
})

ah.UIElements.MainContainer=aa.NewRoundFrame(ah.UICorner,"Squircle",{
Visible=false,

ImageTransparency=af and 0.15 or 0,
Parent=af and ae.Parent or ah.UIElements.FullScreen,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
AutomaticSize="XY",
ThemeTag={
ImageColor3=ag.."Background",
ImageTransparency=ag.."BackgroundTransparency",
},
ZIndex=9999,
},{





ah.UIElements.Main,



















})

function ah.Open(ai)
if not af then
ah.UIElements.FullScreen.Visible=true
ah.UIElements.FullScreen.Active=true
end

task.spawn(function()
ah.UIElements.MainContainer.Visible=true

if not af then
ad(ah.UIElements.FullScreen,0.1,{BackgroundTransparency=.3}):Play()
end
ad(ah.UIElements.MainContainer,0.1,{ImageTransparency=0}):Play()


task.spawn(function()
task.wait(0.05)
ah.UIElements.Main.Visible=true
end)
end)
end
function ah.Close(ai)
if not af then
ad(ah.UIElements.FullScreen,0.1,{BackgroundTransparency=1}):Play()
ah.UIElements.FullScreen.Active=false
task.spawn(function()
task.wait(.1)
ah.UIElements.FullScreen.Visible=false
end)
end
ah.UIElements.Main.Visible=false

ad(ah.UIElements.MainContainer,0.1,{ImageTransparency=1}):Play()



task.spawn(function()
task.wait(.1)
if not af then
ah.UIElements.FullScreen:Destroy()
else
ah.UIElements.MainContainer:Destroy()
end
end)

return function()end
end


return ah
end

return ae end function a.m()
local aa={}


local ab=a.load'b'
local ad=ab.New
local ae=ab.Tween

local af=a.load'j'.New
local ag=a.load'k'.New

function aa.new(ah,ai,aj,ak)
local al=a.load'l'.Init(nil,ah.ANUI.ScreenGui.KeySystem)
local am=al.Create(true)

local an={}

local ao

local ap=(ah.KeySystem.Thumbnail and ah.KeySystem.Thumbnail.Width)or 200

local aq=430
if ah.KeySystem.Thumbnail and ah.KeySystem.Thumbnail.Image then
aq=430+(ap/2)
end

am.UIElements.Main.AutomaticSize="Y"
am.UIElements.Main.Size=UDim2.new(0,aq,0,0)

local ar

if ah.Icon then

ar=ab.Image(
ah.Icon,
ah.Title..":"..ah.Icon,
0,
"Temp",
"KeySystem",
ah.IconThemed
)
ar.Size=UDim2.new(0,24,0,24)
ar.LayoutOrder=-1
end

local as=ad("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text=ah.KeySystem.Title or ah.Title,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
TextSize=20
})

local at=ad("TextLabel",{
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

local au=ad("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ad("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
ar,as
})

local av=ad("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





au,at,
})

local aw=ag("Enter Key","key",nil,"Input",function(aw)
ao=aw
end)

local ax
if ah.KeySystem.Note and ah.KeySystem.Note~=""then
ax=ad("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=ah.KeySystem.Note,
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

local ay=ad("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ad("Frame",{
BackgroundTransparency=1,
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
},{
ad("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
})
})
})


local az
if ah.KeySystem.Thumbnail and ah.KeySystem.Thumbnail.Image then
local aA
if ah.KeySystem.Thumbnail.Title then
aA=ad("TextLabel",{
Text=ah.KeySystem.Thumbnail.Title,
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
az=ad("ImageLabel",{
Image=ah.KeySystem.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,ap,1,-12),
Position=UDim2.new(0,6,0,6),
Parent=am.UIElements.Main,
ScaleType="Crop"
},{
aA,
ad("UICorner",{
CornerRadius=UDim.new(0,20),
})
})
end

ad("Frame",{

Size=UDim2.new(1,az and-ap or 0,1,0),
Position=UDim2.new(0,az and ap or 0,0,0),
BackgroundTransparency=1,
Parent=am.UIElements.Main
},{
ad("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ad("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
av,
ax,
aw,
ay,
ad("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})





local aA=af("Exit","log-out",function()
am:Close()()
end,"Tertiary",ay.Frame)

if az then
aA.Parent=az
aA.Size=UDim2.new(0,0,0,42)
aA.Position=UDim2.new(0,10,1,-10)
aA.AnchorPoint=Vector2.new(0,1)
end

if ah.KeySystem.URL then
af("Get key","key",function()
setclipboard(ah.KeySystem.URL)
end,"Secondary",ay.Frame)
end

if ah.KeySystem.API then








local aB=240
local b=false
local d=af("Get key","key",nil,"Secondary",ay.Frame)

local e=ab.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,1,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=.9,
})

ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=d.Frame,
},{
e,
ad("UIPadding",{
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

ad("Frame",{
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
ad("UIPadding",{
PaddingTop=UDim.new(0,5),
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
PaddingBottom=UDim.new(0,5),
}),
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
})
})

local h=ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,aB,0,0),
ClipsDescendants=true,
AnchorPoint=Vector2.new(1,0),
Parent=d,
Position=UDim2.new(1,0,1,15)
},{
g
})

ad("TextLabel",{
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
ad("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
})
})

for j,l in next,ah.KeySystem.API do
local m=ah.ANUI.Services[l.Type]
if m then
local p={}
for r,u in next,m.Args do
table.insert(p,l[u])
end

local r=m.New(table.unpack(p))
r.Type=l.Type
table.insert(an,r)

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
ad("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,10),
VerticalAlignment="Center",
}),
u,
ad("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,-34,0,0),
AutomaticSize="Y",
},{
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
HorizontalAlignment="Center",
}),
ad("TextLabel",{
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
ad("TextLabel",{
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
ae(v,0.08,{ImageTransparency=.95}):Play()
end)
ab.AddSignal(v.InputEnded,function()
ae(v,0.08,{ImageTransparency=1}):Play()
end)
ab.AddSignal(v.MouseButton1Click,function()
r.Copy()
ah.ANUI:Notify{
Title="Key System",
Content="Key link copied to clipboard.",
Image="key",
}
end)
end
end

ab.AddSignal(d.MouseButton1Click,function()
if not b then
ae(h,.3,{Size=UDim2.new(0,aB,0,g.AbsoluteSize.Y+1)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(f,.3,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
else
ae(h,.25,{Size=UDim2.new(0,aB,0,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(f,.25,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
b=not b
end)

end

local function handleSuccess(aB)
am:Close()()
writefile((ah.Folder or"Temp").."/"..ai..".key",tostring(aB))
task.wait(.4)
aj(true)
end

local aB=af("Submit","arrow-right",function()
local aB=tostring(ao or"empty")local b=
ah.Folder or ah.Title

if ah.KeySystem.KeyValidator then
local d=ah.KeySystem.KeyValidator(aB)

if d then
if ah.KeySystem.SaveKey then
handleSuccess(aB)
else
am:Close()()
task.wait(.4)
aj(true)
end
else
ah.ANUI:Notify{
Title="Key System. Error",
Content="Invalid key.",
Icon="triangle-alert",
}
end
elseif not ah.KeySystem.API then
local d=type(ah.KeySystem.Key)=="table"
and table.find(ah.KeySystem.Key,aB)
or ah.KeySystem.Key==aB

if d then
if ah.KeySystem.SaveKey then
handleSuccess(aB)
else
am:Close()()
task.wait(.4)
aj(true)
end
end
else
local d,e
for f,g in next,an do
local h,j=g.Verify(aB)
if h then
d,e=true,j
break
end
e=j
end

if d then
handleSuccess(aB)
else
ah.ANUI:Notify{
Title="Key System. Error",
Content=e,
Icon="triangle-alert",
}
end
end
end,"Primary",ay)

aB.AnchorPoint=Vector2.new(1,0.5)
aB.Position=UDim2.new(1,0,0.5,0)










am:Open()
end

return aa end function a.n()



local aa=(cloneref or clonereference or function(aa)return aa end)


local function map(ab,ad,ae,af,ag)
return(ab-ad)*(ag-af)/(ae-ad)+af
end

local function viewportPointToWorld(ab,ad)
local ae=aa(game:GetService"Workspace").CurrentCamera:ScreenPointToRay(ab.X,ab.Y)
return ae.Origin+ae.Direction*ad
end

local function getOffset()
local ab=aa(game:GetService"Workspace").CurrentCamera.ViewportSize.Y
return map(ab,0,2560,8,56)
end

return{viewportPointToWorld,getOffset}end function a.o()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=a.load'b'
local ad=ab.New


local ae,af=unpack(a.load'n')
local ag=Instance.new("Folder",aa(game:GetService"Workspace").CurrentCamera)


local function createAcrylic()
local ah=ad("Part",{
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
ad("SpecialMesh",{
MeshType=Enum.MeshType.Brick,
Offset=Vector3.new(0,0,-1E-6),
}),
})

return ah
end


local function createAcrylicBlur(ah)
local ai={}

ah=ah or 0.001
local aj={
topLeft=Vector2.new(),
topRight=Vector2.new(),
bottomRight=Vector2.new(),
}
local ak=createAcrylic()
ak.Parent=ag

local function updatePositions(al,am)
aj.topLeft=am
aj.topRight=am+Vector2.new(al.X,0)
aj.bottomRight=am+al
end

local function render()
local al=aa(game:GetService"Workspace").CurrentCamera
if al then
al=al.CFrame
end
local am=al
if not am then
am=CFrame.new()
end

local an=am
local ao=aj.topLeft
local ap=aj.topRight
local aq=aj.bottomRight

local ar=ae(ao,ah)
local as=ae(ap,ah)
local at=ae(aq,ah)

local au=(as-ar).Magnitude
local av=(as-at).Magnitude

ak.CFrame=
CFrame.fromMatrix((ar+at)/2,an.XVector,an.YVector,an.ZVector)
ak.Mesh.Scale=Vector3.new(au,av,0)
end

local function onChange(al)
local am=af()
local an=al.AbsoluteSize-Vector2.new(am,am)
local ao=al.AbsolutePosition+Vector2.new(am/2,am/2)

updatePositions(an,ao)
task.spawn(render)
end

local function renderOnChange()
local al=aa(game:GetService"Workspace").CurrentCamera
if not al then
return
end

table.insert(ai,al:GetPropertyChangedSignal"CFrame":Connect(render))
table.insert(ai,al:GetPropertyChangedSignal"ViewportSize":Connect(render))
table.insert(ai,al:GetPropertyChangedSignal"FieldOfView":Connect(render))
task.spawn(render)
end

ak.Destroying:Connect(function()
for al,am in ai do
pcall(function()
am:Disconnect()
end)
end
end)

renderOnChange()

return onChange,ak
end

return function(ah)
local ai={}
local aj,ak=createAcrylicBlur(ah)

local al=ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
})

ab.AddSignal(al:GetPropertyChangedSignal"AbsolutePosition",function()
aj(al)
end)

ab.AddSignal(al:GetPropertyChangedSignal"AbsoluteSize",function()
aj(al)
end)

ai.AddParent=function(am)
ab.AddSignal(am:GetPropertyChangedSignal"Visible",function()
ai.SetVisibility(am.Visible)
end)
end

ai.SetVisibility=function(am)
ak.Transparency=am and 0.98 or 1
end

ai.Frame=al
ai.Model=ak

return ai
end end function a.p()



local aa=a.load'b'
local ab=a.load'o'

local ad=aa.New

return function(ae)
local af={}

af.Frame=ad("Frame",{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,
},{












ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),

ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Name="Background",
ThemeTag={
BackgroundColor3="AcrylicMain",
},
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ad("Frame",{
BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{










}),

ad("ImageLabel",{
Image="rbxassetid://9968344105",
ImageTransparency=0.98,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ad("ImageLabel",{
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
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
ZIndex=2,
},{










}),
})


local ag

task.wait()
if ae.UseAcrylic then
ag=ab()

ag.Frame.Parent=af.Frame
af.Model=ag.Model
af.AddParent=ag.AddParent
af.SetVisibility=ag.SetVisibility
end

return af,ag
end end function a.q()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab={
AcrylicBlur=a.load'o',

AcrylicPaint=a.load'p',
}

function ab.init()
local ad=Instance.new"DepthOfFieldEffect"
ad.FarIntensity=0
ad.InFocusRadius=0.1
ad.NearIntensity=1

local ae={}

function ab.Enable()
for af,ag in pairs(ae)do
ag.Enabled=false
end

local af=pcall(function()
ad.Parent=aa(game:GetService"Lighting")
end)

if not af then
pcall(function()
ad.Parent=aa(game:GetService"Workspace").CurrentCamera
end)
end
end

function ab.Disable()
for af,ag in pairs(ae)do
ag.Enabled=ag.enabled
end
ad.Parent=nil
end

local function registerDefaults()
local function register(af)
if af:IsA"DepthOfFieldEffect"then
ae[af]={enabled=af.Enabled}
end
end

for af,ag in pairs(aa(game:GetService"Lighting"):GetChildren())do
register(ag)
end

if aa(game:GetService"Workspace").CurrentCamera then
for af,ag in pairs(aa(game:GetService"Workspace").CurrentCamera:GetChildren())do
register(ag)
end
end
end

registerDefaults()
ab.Enable()
end

return ab end function a.r()

local aa={}

local ab=a.load'b'
local ad=ab.New local ae=
ab.Tween


function aa.new(af)
local ag={
Title=af.Title or"Dialog",
Content=af.Content,
Icon=af.Icon,
IconThemed=af.IconThemed,
Thumbnail=af.Thumbnail,
Buttons=af.Buttons,

IconSize=22,
}

local ah=a.load'l'.Init(nil,af.ANUI.ScreenGui.Popups)
local ai=ah.Create(true,"Popup")

local aj=200

local ak=430
if ag.Thumbnail and ag.Thumbnail.Image then
ak=430+(aj/2)
end

ai.UIElements.Main.AutomaticSize="Y"
ai.UIElements.Main.Size=UDim2.new(0,ak,0,0)



local al

if ag.Icon then
al=ab.Image(
ag.Icon,
ag.Title..":"..ag.Icon,
0,
af.ANUI.Window,
"Popup",
true,
af.IconThemed,
"PopupIcon"
)
al.Size=UDim2.new(0,ag.IconSize,0,ag.IconSize)
al.LayoutOrder=-1
end


local am=ad("TextLabel",{
AutomaticSize="Y",
BackgroundTransparency=1,
Text=ag.Title,
TextXAlignment="Left",
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="PopupTitle",
},
TextSize=20,
TextWrapped=true,
Size=UDim2.new(1,al and-ag.IconSize-14 or 0,0,0)
})

local an=ad("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ad("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
al,am
})

local ao=ad("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





an,
})

local ap
if ag.Content and ag.Content~=""then
ap=ad("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=ag.Content,
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

local aq=ad("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ad("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
HorizontalAlignment="Right"
})
})

local ar
if ag.Thumbnail and ag.Thumbnail.Image then
local as
if ag.Thumbnail.Title then
as=ad("TextLabel",{
Text=ag.Thumbnail.Title,
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
ar=ad("ImageLabel",{
Image=ag.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,aj,1,0),
Parent=ai.UIElements.Main,
ScaleType="Crop"
},{
as,
ad("UICorner",{
CornerRadius=UDim.new(0,0),
})
})
end

ad("Frame",{

Size=UDim2.new(1,ar and-aj or 0,1,0),
Position=UDim2.new(0,ar and aj or 0,0,0),
BackgroundTransparency=1,
Parent=ai.UIElements.Main
},{
ad("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ad("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
ao,
ap,
aq,
ad("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})

local as=a.load'j'.New

for at,au in next,ag.Buttons do
as(au.Title,au.Icon,au.Callback,au.Variant,aq,ai)
end

ai:Open()


return ag
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
local ad=ab.New local ae=
ab.Tween


function aa.New(af,ag,ah,ai,aj)
local ak=aj or 10
local al
if ag and ag~=""then
al=ad("ImageLabel",{
Image=ab.Icon(ag)[1],
ImageRectSize=ab.Icon(ag)[2].ImageRectSize,
ImageRectOffset=ab.Icon(ag)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local am=ad("TextLabel",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,al and-29 or 0,1,0),
TextXAlignment="Left",
ThemeTag={
TextColor3=ai and"Placeholder"or"Text",
},
Text=af,
})

local an=ad("TextButton",{
Size=UDim2.new(1,0,0,42),
Parent=ah,
BackgroundTransparency=1,
Text="",
},{
ad("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(ak,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.97,
}),
ab.NewRoundFrame(ak,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.95,
},{
ad("UIGradient",{
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
ab.NewRoundFrame(ak,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.95
},{
ad("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
ad("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
al,
am,
})
})
})

return an
end


return aa end function a.u()
local aa={}

local ab=(cloneref or clonereference or function(ab)return ab end)


local ad=ab(game:GetService"UserInputService")

local ae=a.load'b'
local af=ae.New local ag=
ae.Tween


function aa.New(ah,ai,aj,ak)
local al=af("Frame",{
Size=UDim2.new(0,ak,1,0),
BackgroundTransparency=1,
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
Parent=ai,
ZIndex=999,
Active=true,
})

local am=ae.NewRoundFrame(ak/2,"Squircle",{
Size=UDim2.new(1,0,0,0),
ImageTransparency=0.85,
ThemeTag={ImageColor3="Text"},
Parent=al,
})

local an=af("Frame",{
Size=UDim2.new(1,12,1,12),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Active=true,
ZIndex=999,
Parent=am,
})

local ao=false
local ap=0

local function updateSliderSize()
local aq=ah
local ar=aq.AbsoluteCanvasSize.Y
local as=aq.AbsoluteWindowSize.Y

if ar<=as then
am.Visible=false
return
end

local at=math.clamp(as/ar,0.1,1)
am.Size=UDim2.new(1,0,at,0)
am.Visible=true
end

local function updateScrollingFramePosition()
local aq=am.Position.Y.Scale
local ar=ah.AbsoluteCanvasSize.Y
local as=ah.AbsoluteWindowSize.Y
local at=math.max(ar-as,0)

if at<=0 then return end

local au=math.max(1-am.Size.Y.Scale,0)
if au<=0 then return end

local av=aq/au

ah.CanvasPosition=Vector2.new(
ah.CanvasPosition.X,
av*at
)
end

local function updateThumbPosition()
if ao then return end

local aq=ah.CanvasPosition.Y
local ar=ah.AbsoluteCanvasSize.Y
local as=ah.AbsoluteWindowSize.Y
local at=math.max(ar-as,0)

if at<=0 then
am.Position=UDim2.new(0,0,0,0)
return
end

local au=aq/at
local av=math.max(1-am.Size.Y.Scale,0)
local aw=math.clamp(au*av,0,av)

am.Position=UDim2.new(0,0,aw,0)
end

ae.AddSignal(al.InputBegan,function(aq)
if(aq.UserInputType==Enum.UserInputType.MouseButton1 or aq.UserInputType==Enum.UserInputType.Touch)then
local ar=am.AbsolutePosition.Y
local as=ar+am.AbsoluteSize.Y

if not(aq.Position.Y>=ar and aq.Position.Y<=as)then
local at=al.AbsolutePosition.Y
local au=al.AbsoluteSize.Y
local av=am.AbsoluteSize.Y

local aw=aq.Position.Y-at-av/2
local ax=au-av

local ay=math.clamp(aw/ax,0,1-am.Size.Y.Scale)

am.Position=UDim2.new(0,0,ay,0)
updateScrollingFramePosition()
end
end
end)

ae.AddSignal(an.InputBegan,function(aq)
if aq.UserInputType==Enum.UserInputType.MouseButton1 or aq.UserInputType==Enum.UserInputType.Touch then
ao=true
ap=aq.Position.Y-am.AbsolutePosition.Y

local ar
local as

ar=ad.InputChanged:Connect(function(at)
if at.UserInputType==Enum.UserInputType.MouseMovement or at.UserInputType==Enum.UserInputType.Touch then
local au=al.AbsolutePosition.Y
local av=al.AbsoluteSize.Y
local aw=am.AbsoluteSize.Y

local ax=at.Position.Y-au-ap
local ay=av-aw

local az=math.clamp(ax/ay,0,1-am.Size.Y.Scale)

am.Position=UDim2.new(0,0,az,0)
updateScrollingFramePosition()
end
end)

as=ad.InputEnded:Connect(function(at)
if at.UserInputType==Enum.UserInputType.MouseButton1 or at.UserInputType==Enum.UserInputType.Touch then
ao=false
if ar then ar:Disconnect()end
if as then as:Disconnect()end
end
end)
end
end)

ae.AddSignal(ah:GetPropertyChangedSignal"AbsoluteWindowSize",function()
updateSliderSize()
updateThumbPosition()
end)

ae.AddSignal(ah:GetPropertyChangedSignal"AbsoluteCanvasSize",function()
updateSliderSize()
updateThumbPosition()
end)

ae.AddSignal(ah:GetPropertyChangedSignal"CanvasPosition",function()
if not ao then
updateThumbPosition()
end
end)

updateSliderSize()
updateThumbPosition()

return al
end


return aa end function a.v()
local aa={}


local ab=a.load'b'
local ad=ab.New
local ae=ab.Tween

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

local function GetAverageColor(af)
local ag,ah,ai=0,0,0
local aj=af.Color.Keypoints
for ak,al in ipairs(aj)do

ag=ag+al.Value.R
ah=ah+al.Value.G
ai=ai+al.Value.B
end
local ak=#aj
return Color3.new(ag/ak,ah/ak,ai/ak)
end


function aa.New(af,ag,ah)
local ai={
Title=ag.Title or"Tag",
Icon=ag.Icon,
Color=ag.Color or Color3.fromHex"#315dff",
Radius=ag.Radius or 999,

TagFrame=nil,
Height=26,
Padding=10,
TextSize=14,
IconSize=16,
}

local aj
if ai.Icon then
aj=ab.Image(
ai.Icon,
ai.Icon,
0,
ag.Window,
"Tag",
false
)

aj.Size=UDim2.new(0,ai.IconSize,0,ai.IconSize)
aj.ImageLabel.ImageColor3=typeof(ai.Color)=="Color3"and GetTextColorForHSB(ai.Color)or nil
end

local ak=ad("TextLabel",{
BackgroundTransparency=1,
AutomaticSize="XY",
TextSize=ai.TextSize,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ai.Title,
TextColor3=typeof(ai.Color)=="Color3"and GetTextColorForHSB(ai.Color)or nil,
})

local al

if typeof(ai.Color)=="table"then

al=ad"UIGradient"
for am,an in next,ai.Color do
al[am]=an
end

ak.TextColor3=GetTextColorForHSB(GetAverageColor(al))
if aj then
aj.ImageLabel.ImageColor3=GetTextColorForHSB(GetAverageColor(al))
end
end



local am=ab.NewRoundFrame(ai.Radius,"Squircle",{
AutomaticSize="X",
Size=UDim2.new(0,0,0,ai.Height),
Parent=ah,
ImageColor3=typeof(ai.Color)=="Color3"and ai.Color or Color3.new(1,1,1),
},{
al,
ad("UIPadding",{
PaddingLeft=UDim.new(0,ai.Padding),
PaddingRight=UDim.new(0,ai.Padding),
}),
aj,
ak,
ad("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,ai.Padding/1.5)
})
})


function ai.SetTitle(an,ao)
ai.Title=ao
ak.Text=ao
end

function ai.SetColor(an,ao)
ai.Color=ao
if typeof(ao)=="table"then
local ap=GetAverageColor(ao)
ae(ak,.06,{TextColor3=GetTextColorForHSB(ap)}):Play()
local aq=am:FindFirstChildOfClass"UIGradient"or ad("UIGradient",{Parent=am})
for ar,as in next,ao do aq[ar]=as end
ae(am,.06,{ImageColor3=Color3.new(1,1,1)}):Play()
else
if al then
al:Destroy()
end
ae(ak,.06,{TextColor3=GetTextColorForHSB(ao)}):Play()
if aj then
ae(aj.ImageLabel,.06,{ImageColor3=GetTextColorForHSB(ao)}):Play()
end
ae(am,.06,{ImageColor3=ao}):Play()
end
end


return ai
end


return aa end function a.w()
local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=aa(game:GetService"HttpService")

local ad

local ae
ae={
Folder=nil,
Path=nil,
Configs={},
Parser={
Colorpicker={
Save=function(af)
return{
__type=af.__type,
value=af.Default:ToHex(),
transparency=af.Transparency or nil,
}
end,
Load=function(af,ag)
if af and af.Update then
af:Update(Color3.fromHex(ag.value),ag.transparency or nil)
end
end
},
Dropdown={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Select then
af:Select(ag.value)
end
end
},
Input={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
Keybind={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
Slider={
Save=function(af)
return{
__type=af.__type,
value=af.Value.Default,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(tonumber(ag.value))
end
end
},
Toggle={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value,false,nil,true)
if af.Disabled~=true then
af:Set(ag.value,true,true,true)
end
end
end
},
}
}

function ae.Init(af,ag)
if not ag.Folder then
warn"[ ANUI.ConfigManager ] Window.Folder is not specified."
return false
end

ad=ag
ae.Folder=ad.Folder
ae.Path="ANUI/"..tostring(ae.Folder).."/config/"

if not isfolder("ANUI/"..ae.Folder)then
makefolder("ANUI/"..ae.Folder)
if not isfolder("ANUI/"..ae.Folder.."/config/")then
makefolder("ANUI/"..ae.Folder.."/config/")
end
end

local ah=ae:AllConfigs()

for ai,aj in next,ah do
if isfile and readfile and isfile(aj..".json")then
ae.Configs[aj]=readfile(aj..".json")
end
end

return ae
end

function ae.CreateConfig(af,ag,ah)
local ai={
Path=ae.Path..ag..".json",
Elements={},
CustomData={},
AutoLoad=ah or false,
Version=1.2,
}

if not ag then
return false,"No config file is selected"
end

function ai.SetAsCurrent(aj)
ad:SetCurrentConfig(ai)
end

function ai.Register(aj,ak,al)
ai.Elements[ak]=al
end

function ai.Set(aj,ak,al)
ai.CustomData[ak]=al
end

function ai.Get(aj,ak)
return ai.CustomData[ak]
end

function ai.SetAutoLoad(aj,ak)
ai.AutoLoad=ak
end

function ai.Save(aj)
if ad.PendingFlags then
for ak,al in next,ad.PendingFlags do
ai:Register(ak,al)
end
end

local ak={
__version=ai.Version,
__elements={},
__autoload=ai.AutoLoad,
__custom=ai.CustomData
}

for al,am in next,ai.Elements do
if ae.Parser[am.__type]then
ak.__elements[tostring(al)]=ae.Parser[am.__type].Save(am)
end
end

local al=ab:JSONEncode(ak)
if writefile then
writefile(ai.Path,al)
end

return ak
end

function ai.Load(aj)
if isfile and not isfile(ai.Path)then
return false,"Config file does not exist"
end

local ak,al=pcall(function()
local ak=readfile or function()
warn"[ ANUI.ConfigManager ] The config system doesn't work in the studio."
return nil
end
return ab:JSONDecode(ak(ai.Path))
end)

if not ak then
return false,"Failed to parse config file"
end

if not al.__version then
local am={
__version=ai.Version,
__elements=al,
__custom={}
}
al=am
end

if ad.PendingFlags then
for am,an in next,ad.PendingFlags do
ai:Register(am,an)
end
end

for am,an in next,(al.__elements or{})do
if ai.Elements[am]and ae.Parser[an.__type]then
task.spawn(function()
ae.Parser[an.__type].Load(ai.Elements[am],an)
end)
else
ad.PendingConfigData=ad.PendingConfigData or{}
ad.PendingConfigData[am]=an
end
end

ai.CustomData=al.__custom or{}

return ai.CustomData
end

function ai.Delete(aj)
if not delfile then
return false,"delfile function is not available"
end

if not isfile(ai.Path)then
return false,"Config file does not exist"
end

local ak,al=pcall(function()
delfile(ai.Path)
end)

if not ak then
return false,"Failed to delete config file: "..tostring(al)
end

ae.Configs[ag]=nil

if ad.CurrentConfig==ai then
ad.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ai.GetData(aj)
return{
elements=ai.Elements,
custom=ai.CustomData,
autoload=ai.AutoLoad
}
end


if isfile(ai.Path)then
local aj,ak=pcall(function()
return ab:JSONDecode(readfile(ai.Path))
end)

if aj and ak and ak.__autoload then
ai.AutoLoad=true

task.spawn(function()
task.wait(0.5)
local al,am=pcall(function()
return ai:Load()
end)
if al then
if ad.Debug then print("[ ANUI.ConfigManager ] AutoLoaded config: "..ag)end
else
warn("[ ANUI.ConfigManager ] Failed to AutoLoad config: "..ag.." - "..tostring(am))
end
end)
end
end


ai:SetAsCurrent()
ae.Configs[ag]=ai
return ai
end

function ae.Config(af,ag,ah)
return ae:CreateConfig(ag,ah)
end

function ae.GetAutoLoadConfigs(af)
local ag={}

for ah,ai in pairs(ae.Configs)do
if ai.AutoLoad then
table.insert(ag,ah)
end
end

return ag
end

function ae.DeleteConfig(af,ag)
if not delfile then
return false,"delfile function is not available"
end

local ah=ae.Path..ag..".json"

if not isfile(ah)then
return false,"Config file does not exist"
end

local ai,aj=pcall(function()
delfile(ah)
end)

if not ai then
return false,"Failed to delete config file: "..tostring(aj)
end

ae.Configs[ag]=nil

if ad.CurrentConfig and ad.CurrentConfig.Path==ah then
ad.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ae.AllConfigs(af)
if not listfiles then return{}end

local ag={}
if not isfolder(ae.Path)then
makefolder(ae.Path)
return ag
end

for ah,ai in next,listfiles(ae.Path)do
local aj=ai:match"([^\\/]+)%.json$"
if aj then
table.insert(ag,aj)
end
end

return ag
end

function ae.GetConfig(af,ag)
return ae.Configs[ag]
end

return ae end function a.x()

local aa={}

local ab=a.load'b'
local ad=ab.New
local ae=ab.Tween


local af=(cloneref or clonereference or function(af)return af end)


af(game:GetService"UserInputService")


function aa.New(ag)
local ah={
Button=nil,
CurrentConfig={}
}

local ai













local aj=ad("TextLabel",{
Text=ag.Title,
TextSize=10,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
})

local ak=ad("Frame",{
Size=UDim2.new(0,14,0,14),
BackgroundTransparency=1,
Name="Drag",
},{
ad("ImageLabel",{
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
local al=ad("Frame",{
Size=UDim2.new(0,1,1,0),
Position=UDim2.new(0,18,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=.9,
})

local am=ad("Frame",{
Size=UDim2.new(0,0,0,0),
Position=UDim2.new(0.5,0,0,17),
AnchorPoint=Vector2.new(0.5,0.5),
Parent=ag.Parent,
BackgroundTransparency=1,
Active=true,
Visible=false,
})
local an=ad("TextButton",{
Size=UDim2.new(0,0,0,22),
AutomaticSize="X",
Parent=am,
Active=false,
BackgroundTransparency=.25,
ZIndex=99,
BackgroundColor3=Color3.new(0,0,0),
},{
ad("UIScale",{
Scale=1,
}),
ad("UICorner",{
CornerRadius=UDim.new(1,0)
}),
ad("UIStroke",{
Thickness=1,
ApplyStrokeMode="Border",
Color=Color3.new(1,1,1),
Transparency=0,
},{
ad("UIGradient",{
Color=ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff")
})
}),
ak,
al,

ad("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),

ad("TextButton",{
AutomaticSize="XY",
Active=true,
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,14),
BackgroundColor3=Color3.new(1,1,1),
},{
ad("UICorner",{
CornerRadius=UDim.new(1,-4)
}),
ai,
ad("UIListLayout",{
Padding=UDim.new(0,ag.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aj,
ad("UIPadding",{
PaddingLeft=UDim.new(0,6),
PaddingRight=UDim.new(0,6),
}),
}),
ad("UIPadding",{
PaddingLeft=UDim.new(0,4),
PaddingRight=UDim.new(0,4),
})
})

ah.Button=an



function ah.SetIcon(ao,ap)
if ai then
ai:Destroy()
end
if ap then
ai=ab.Image(
ap,
ag.Title,
0,
ag.Folder,
"OpenButton",
true,
ag.IconThemed
)
ai.Size=UDim2.new(0,11,0,11)
ai.LayoutOrder=-1
ai.Parent=ah.Button.TextButton
end
end

if ag.Icon then
ah:SetIcon(ag.Icon)
end



ab.AddSignal(an:GetPropertyChangedSignal"AbsoluteSize",function()
am.Size=UDim2.new(
0,an.AbsoluteSize.X,
0,an.AbsoluteSize.Y
)
end)

ab.AddSignal(an.TextButton.MouseEnter,function()
ae(an.TextButton,.1,{BackgroundTransparency=.93}):Play()
end)
ab.AddSignal(an.TextButton.MouseLeave,function()
ae(an.TextButton,.1,{BackgroundTransparency=1}):Play()
end)

ab.Drag(am,{ak,an.TextButton})


function ah.Visible(ao,ap)
am.Visible=ap
end

function ah.Edit(ao,ap)
for aq,ar in pairs(ap)do
ah.CurrentConfig[aq]=ar
end
local aq=ah.CurrentConfig

local ar={
Title=aq.Title,
Icon=aq.Icon,
Enabled=aq.Enabled,
Position=aq.Position,
OnlyIcon=aq.OnlyIcon or false,
Draggable=aq.Draggable,
OnlyMobile=aq.OnlyMobile,
CornerRadius=aq.CornerRadius or UDim.new(1,0),
StrokeThickness=aq.StrokeThickness or 2,
Color=aq.Color
or ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff"),
}



if ar.Enabled==false then
ag.IsOpenButtonEnabled=false
end

if ar.OnlyMobile~=false then
ar.OnlyMobile=true
else
ag.IsPC=false
end

if ar.OnlyIcon==true then

local as=ag.IsPC and 50 or 60
ar.Size=UDim2.new(0,as,0,as)
ar.CornerRadius=UDim.new(1,0)

if aj then aj.Visible=false end
if ak then ak.Visible=false end
if al then al.Visible=false end


an.TextButton.UIPadding.PaddingLeft=UDim.new(0,0)
an.TextButton.UIPadding.PaddingRight=UDim.new(0,0)


an.TextButton.UIListLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
an.TextButton.UIListLayout.VerticalAlignment=Enum.VerticalAlignment.Center


if ai then
ai.Size=UDim2.new(0,as*0.5,0,as*0.5)
end


an.AutomaticSize=Enum.AutomaticSize.None
an.Size=ar.Size
an.TextButton.Size=UDim2.new(1,0,1,0)
an.TextButton.AutomaticSize=Enum.AutomaticSize.None

elseif ar.OnlyIcon==false then
aj.Visible=true
if ak then ak.Visible=true end
if al then al.Visible=true end

an.TextButton.UIPadding.PaddingLeft=UDim.new(0,6)
an.TextButton.UIPadding.PaddingRight=UDim.new(0,6)

an.TextButton.UIListLayout.HorizontalAlignment=Enum.HorizontalAlignment.Left
an.TextButton.UIListLayout.VerticalAlignment=Enum.VerticalAlignment.Center

if ai then
ai.Size=UDim2.new(0,11,0,11)
end


local as=ag.IsPC and 150 or 60
if not ar.Size then
ar.Size=UDim2.new(0,as,0,22)
end
an.AutomaticSize=Enum.AutomaticSize.None
an.Size=ar.Size
an.TextButton.Size=UDim2.new(0,0,0,14)
an.TextButton.AutomaticSize=Enum.AutomaticSize.XY
end





if aj then
if ar.Title then
aj.Text=ar.Title
ab:ChangeTranslationKey(aj,ar.Title)
elseif ar.Title==nil then

end
end

if ar.Icon then
ah:SetIcon(ar.Icon)
end

an.UIStroke.UIGradient.Color=ar.Color
if Glow then
Glow.UIGradient.Color=ar.Color
end

an.UICorner.CornerRadius=ar.CornerRadius
an.TextButton.UICorner.CornerRadius=UDim.new(ar.CornerRadius.Scale,ar.CornerRadius.Offset-4)
an.UIStroke.Thickness=ar.StrokeThickness
end

return ah
end



return aa end function a.y()

local aa={}

local ab=a.load'b'
local ad=ab.New
local ae=ab.Tween


function aa.New(af,ag)
local ah={
Container=nil,
ToolTipSize=16,
}

local ai=ad("TextLabel",{
AutomaticSize="XY",
TextWrapped=true,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
Text=af,
TextSize=17,
TextTransparency=1,
ThemeTag={
TextColor3="Text",
}
})

local aj=ad("UIScale",{
Scale=.9
})

local ak=ad("Frame",{
AnchorPoint=Vector2.new(0.5,0),
AutomaticSize="XY",
BackgroundTransparency=1,
Parent=ag,

Visible=false
},{
ad("UISizeConstraint",{
MaxSize=Vector2.new(400,math.huge)
}),
ad("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
LayoutOrder=99,
Visible=false
},{
ad("ImageLabel",{
Size=UDim2.new(0,ah.ToolTipSize,0,ah.ToolTipSize/2),
BackgroundTransparency=1,
Rotation=180,
Image="rbxassetid://89524607682719",
ThemeTag={
ImageColor3="Accent",
},
},{
ad("ImageLabel",{
Size=UDim2.new(0,ah.ToolTipSize,0,ah.ToolTipSize/2),
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



ad("Frame",{
ThemeTag={
BackgroundColor3="Text",
},
AutomaticSize="XY",
BackgroundTransparency=1,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,16),
}),
ad("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),

ai,
ad("UIPadding",{
PaddingTop=UDim.new(0,12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,12),
}),
})
}),
aj,
ad("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
})
ah.Container=ak

function ah.Open(al)
ak.Visible=true


ae(ak.Background,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(ai,.2,{TextTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(aj,.18,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

function ah.Close(al)

ae(ak.Background,.3,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(ai,.3,{TextTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(aj,.35,{Scale=.9},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(.35)

ak.Visible=false
ak:Destroy()
end

return ah
end



return aa end function a.z()
local aa=a.load'b'
local ab=aa.New
local ad=aa.NewRoundFrame
local ae=aa.Tween



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



local function ToColor3(af)
if typeof(af)=="Color3"then
return af
elseif type(af)=="string"then
local ag,ah=pcall(Color3.fromHex,af)
if ag and ah then
return ah
end
end
return nil
end


local af=20




local function ColorsToSequence(ag)
if type(ag)~="table"then return nil end

local ah={}
for ai,aj in ipairs(ag)do
local ak=ToColor3(aj)
if ak then
table.insert(ah,ak)
end
end

if#ah==0 then
return nil
elseif#ah==1 then
return ColorSequence.new(ah[1])
end


if#ah>af then
local ai={}
for aj=1,af do
local ak=1+math.floor(((aj-1)*(#ah-1))/(af-1)+0.5)
table.insert(ai,ah[ak])
end
ah=ai
end

local ai={}
for aj,ak in ipairs(ah)do
table.insert(ai,ColorSequenceKeypoint.new((aj-1)/(#ah-1),ak))
end
return ColorSequence.new(ai)
end




local ag={
Color="ColorSequence",
Transparency="NumberSequence",
Rotation="number",
Offset="Vector2",
Enabled="boolean",
}

local function CoerceGradientProp(ah,ai)
if typeof(ai)==ah then
return ai
elseif ah=="number"then
return tonumber(ai)
elseif ah=="NumberSequence"and type(ai)=="number"then
return NumberSequence.new(ai)
elseif ah=="Vector2"and type(ai)=="number"then
return Vector2.new(ai,0)
end
return nil
end



local ah




local function ResolveGradientProps(ai)
if not ai then return nil end

if typeof(ai)=="ColorSequence"then
return{Color=ai}
elseif typeof(ai)=="Color3"then
return{Color=ColorSequence.new(ai)}
elseif type(ai)=="string"then
return ah(ai)
elseif typeof(ai)~="table"then
return nil
end


local aj=ai.Color
if aj==nil then aj=ai.Colors end
if aj==nil and#ai>0 then aj=ai end

local ak
if typeof(aj)=="ColorSequence"then
ak=aj
elseif aj~=nil then
local al=ToColor3(aj)
if al then
ak=ColorSequence.new(al)
else
ak=ColorsToSequence(aj)
end
end

if not ak then return nil end

local al={Color=ak}
for am,an in pairs(ai)do
local ao=am~="Color"and ag[am]
if ao then
local ap=CoerceGradientProp(ao,an)
if ap~=nil then
al[am]=ap
end
end
end

return al
end

local ai="<gradient>"
local aj="</gradient>"






local function HasGradientTag(ak)
if type(ak)~="string"or ak==""then return false end
return string.find(ak,ai,1,true)~=nil
or string.find(ak,"<gradient=",1,true)~=nil
or string.find(ak,aj,1,true)~=nil
end



ah=function(ak)
if type(ak)~="string"or ak==""then return nil end

local al,am=ak
local an=string.find(ak,"|",1,true)
if an then
al=string.sub(ak,1,an-1)
am=string.sub(ak,an+1)
end

local ao={}
for ap in string.gmatch(al,"[^,]+")do
ap=ap:match"^%s*(.-)%s*$"
if ap~=""then
table.insert(ao,ap)
end
end

local ap=ColorsToSequence(ao)
if not ap then return nil end

local aq={Color=ap}
if am then
local ar=tonumber(am)
if ar then
aq.Rotation=ar
end
end

return aq
end













local function ParseTextSegments(ak,al,am)
local an={}
local ao=1
local ap=#ak

if am==nil then
am=HasGradientTag(ak)
end





local aq=true
if am then
aq=false
end




local function PushTextWithIcons(ar)
if ar==""then return end

if not al or not aa.HasInlineIcons(ar)then
table.insert(an,{Type="Text",Content=ar,Gradient=aq})
return
end

for as,at in ipairs(aa.ParseInlineText(ar,al))do
if at.Type=="Icon"then
table.insert(an,{
Type="Icon",
Content=at.Content,
Options=at.Options,
})
elseif at.Content~=""then
table.insert(an,{Type="Text",Content=at.Content,Gradient=aq})
end
end
end

while ao<=ap do
local ar,as=string.find(ak,"rbxassetid://%d+",ao)
local at,au=string.find(ak,ai,ao,true)
local av,aw,ax=string.find(ak,"<gradient=([^>]*)>",ao)
local ay,az=string.find(ak,aj,ao,true)

local aA,aB,b,d
for e,f in ipairs{
{s=ar,e=as,k="Image"},
{s=at,e=au,k="OpenPlain"},
{s=av,e=aw,k="OpenAttr",attr=ax},
{s=ay,e=az,k="Close"},
}do
if f.s and(not aA or f.s<aA)then
aA,aB,b,d=f.s,f.e,f.k,f.attr
end
end

if not aA then
PushTextWithIcons(string.sub(ak,ao))
break
end

PushTextWithIcons(string.sub(ak,ao,aA-1))

if b=="Image"then
table.insert(an,{Type="Image",Content=string.sub(ak,aA,aB)})
elseif b=="OpenPlain"then
aq=true
elseif b=="OpenAttr"then
aq=ah(d)or true
elseif b=="Close"then
aq=false
end

ao=aB+1
end

return an
end




local function HasRichTokens(ak,al)
if not ak or ak==""then return false end
return string.find(ak,"rbxassetid://%d+")~=nil
or HasGradientTag(ak)
or(al~=false and aa.HasInlineIcons(ak))
end


local function ResolveItemGradientProps(ak,al)
if typeof(ak)=="table"then
return ResolveGradientProps(ak)
elseif ak~=false then
return ResolveGradientProps(al)
end
return nil
end


local function GradientSignature(ak)
if ak==false then
return""
elseif ak==nil or ak==true then


return"@default"
elseif typeof(ak)=="table"and ak.Color then
local al={}
for am,an in ipairs(ak.Color.Keypoints)do
table.insert(al,string.format("%.3f:%s",an.Time,an.Value:ToHex()))
end
if ak.Rotation then
table.insert(al,"R"..tostring(ak.Rotation))
end
return table.concat(al,"|")
end
return""
end




local ak=setmetatable({},{__mode="k"})

local function RestoreTextColor(al)
local am=ak[al]
if not am then return end

if am.ThemeTag then

aa.AddThemeObject(al,{TextColor3=am.ThemeTag})
elseif am.Color then
al.TextColor3=am.Color
end
end


local function ApplyGradientToLabel(al,am)
if not al then return end

local an=al:FindFirstChild"TextGradient"

if am then
if not an then
an=Instance.new"UIGradient"
an.Name="TextGradient"
an.Parent=al
end



an.Color=am.Color
an.Rotation=am.Rotation or 0
an.Offset=am.Offset or Vector2.new(0,0)
an.Transparency=am.Transparency or NumberSequence.new(0)
an.Enabled=am.Enabled~=false




aa.Objects[al]=nil
al.TextColor3=Color3.new(1,1,1)
elseif an then
an:Destroy()
RestoreTextColor(al)
end
end

local function getElementPosition(al,am)
if type(am)~="number"or am~=math.floor(am)then
return nil,1
end

local an=#al

if an==0 or am<1 or am>an then
return nil,2
end

local function isDelimiter(ao)
if ao==nil then return true end
local ap=ao.__type
return ap=="Divider"or ap=="Space"or ap=="Section"or ap=="Code"or ap=="Paragraph"
end

if isDelimiter(al[am])then
return nil,3
end

local function calculate(ao,ap)
if ap==1 then return"Squircle"end
if ao==1 then return"Squircle-TL-TR"end
if ao==ap then return"Squircle-BL-BR"end
return"Square"
end

local ao=1
local ap=0

for aq=1,an do
local ar=al[aq]
if isDelimiter(ar)then
if am>=ao and am<=aq-1 then
local as=am-ao+1
return calculate(as,ap)
end
ao=aq+1
ap=0
else
ap=ap+1
end
end

if am>=ao and am<=an then
local aq=am-ao+1
return calculate(aq,ap)
end

return nil,4
end

return function(al)
local am={
Title=al.Title,
Desc=al.Desc or nil,
Hover=al.Hover,
Thumbnail=al.Thumbnail,
ThumbnailSize=al.ThumbnailSize or 80,
Image=al.Image,
IconThemed=al.IconThemed or false,
ImageSize=al.ImageSize or 30,
Color=al.Color,
TitleGradient=al.TitleGradient,
DescGradient=al.DescGradient,
Scalable=al.Scalable,
Parent=al.Parent,
Justify=al.Justify or"Between",
UIPadding=al.Window.ElementConfig.UIPadding,
UICorner=al.Window.ElementConfig.UICorner,
UIElements={},
DescColumnWidth=al.DescColumnWidth,

Index=al.Index
}

local an=am.ImageSize
local ao=am.ThumbnailSize
local ap=true
local aq=0



local ar=al.Icon or al.Image
if typeof(ar)~="string"and type(ar)~="table"then
ar=nil
end

local function InlineContext(as,at)
return{
Icon=ar,
IconSize=al.InlineIconSize or(as=="Desc"and 16 or 18),
IconThemed=al.InlineIconThemed,
Folder=al.Window and al.Window.Folder,
ImageKind="Icon",
ThemeTagName=as=="Desc"and"ElementDesc"or"ElementTitle",
CachePrefix="Inline"..(as or"Title"),
Index=at,
IconTransparency=as=="Desc"and 0.3 or 0,
}
end


local as=al.InlineIcon~=false

local function ParseInline(at,au,av)

return ParseTextSegments(at,as and InlineContext(au)or nil,av)
end

local function HasRich(at)
return HasRichTokens(at,as)
end

local at
local au
if am.Thumbnail then
at=aa.Image(
am.Thumbnail,
am.Title,
al.Window.NewElements and am.UICorner-11 or(am.UICorner-4),
al.Window.Folder,
"Thumbnail",
false,
am.IconThemed
)
at.Size=UDim2.new(1,0,0,ao)
end
if am.Image then
au=aa.Image(
am.Image,
am.Title,
al.Window.NewElements and am.UICorner-11 or(am.UICorner-4),
al.Window.Folder,
"Image",
am.IconThemed,
not am.Color and true or false,
"ElementIcon"
)
if typeof(am.Color)=="string"then
au.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[am.Color]))
elseif typeof(am.Color)=="Color3"then
au.ImageLabel.ImageColor3=GetTextColorForHSB(am.Color)
end

au.Size=UDim2.new(0,an,0,an)

aq=an
end




local function CreateText(av,aw,ax)
local ay=typeof(am.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[am.Color]))
or typeof(am.Color)=="Color3"
and GetTextColorForHSB(am.Color)

local az=ResolveItemGradientProps(ax,aw=="Desc"and am.DescGradient or am.TitleGradient)

local aA=(not am.Color)and("Element"..aw)or nil

local aB=ab("TextLabel",{
BackgroundTransparency=1,
Text=av or"",
TextSize=aw=="Desc"and 15 or 17,
TextXAlignment="Left",
ThemeTag={
TextColor3=(not az)and aA or nil,
},
TextColor3=az and Color3.new(1,1,1)or(am.Color and ay or nil),
TextTransparency=aw=="Desc"and.3 or 0,
TextWrapped=true,
Size=UDim2.new(am.Justify=="Between"and 1 or 0,0,0,0),
AutomaticSize=am.Justify=="Between"and"Y"or"XY",
FontFace=Font.new(aa.Font,aw=="Desc"and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold)
})


ak[aB]={
ThemeTag=aA,
Color=am.Color and ay or nil,
}

ApplyGradientToLabel(aB,az)

return aB
end

local av=CreateText(am.Title,"Title")
local aw=ab("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,4),
VerticalAlignment=Enum.VerticalAlignment.Center
})


if am.Justify=="Between"then
aa.TrySetWraps(aw,true)
end

local ax=ab("Frame",{
Name="TitleRich",
BackgroundTransparency=1,
Size=UDim2.new(am.Justify=="Between"and 1 or 0,0,0,0),
AutomaticSize=am.Justify=="Between"and"Y"or"XY",
Visible=false,
},{
aw
})


local ay=ab("Frame",{
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


local function UpdateDesc(az)

if not az or az==""then
ay.Visible=false
return
end
ay.Visible=true




local aA=HasGradientTag(az)

local function parseInline(aB)
return ParseInline(aB,"Desc",aA)
end

local function getColumnWidth()
if typeof(am.DescColumnWidth)=="number"and am.DescColumnWidth>0 then
return math.floor(am.DescColumnWidth)
end

local aB=ay.AbsoluteSize.X
if not aB or aB<=0 then
return 320
end
return math.clamp(math.floor(aB*0.62),220,520)
end

local function getOrCreateListLayout(aB)
local b=aB:FindFirstChild"UIListLayout"
if not b then
b=ab("UIListLayout",{
Parent=aB,
FillDirection=Enum.FillDirection.Horizontal,
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,4),
VerticalAlignment=Enum.VerticalAlignment.Center
})
else
b.FillDirection=Enum.FillDirection.Horizontal
b.SortOrder=Enum.SortOrder.LayoutOrder
b.Padding=UDim.new(0,4)
b.VerticalAlignment=Enum.VerticalAlignment.Center
end
return b
end





local function ItemSignature(aB)
if aB.Type=="Text"then
return"T|"..GradientSignature(aB.Gradient)
elseif aB.Type=="Image"then
return"I"
end

local b=aB.Options or{}
return table.concat({
"C",tostring(aB.Content),
tostring(b.Size),tostring(b.Width),tostring(b.Height),
tostring(b.Transparency),tostring(b.Themed),
tostring(b.ScaleType),tostring(b.KeepAspect),
b.Color and b.Color:ToHex()or"",
},"|")
end

local function updateItemsInContainer(aB,b)
local d={}
for e,f in ipairs(aB:GetChildren())do
if f:IsA"GuiObject"then table.insert(d,f)end
end




local e=0

for f,g in ipairs(b)do
local h=ItemSignature(g)
local j=d[e+1]

if j and j:GetAttribute"ItemSig"~=h then
j:Destroy()
table.remove(d,e+1)
j=nil
end

if not j then
if g.Type=="Text"then
j=CreateText(g.Content,"Desc",g.Gradient)
j:SetAttribute("GradientSig",GradientSignature(g.Gradient))
j.Parent=aB
elseif g.Type=="Icon"then
j=aa.InlineIconFrame(g,InlineContext("Desc",f))
if j then
j.Parent=aB
end
else
j=ab("ImageLabel",{
Parent=aB,
BackgroundTransparency=1,
Size=UDim2.new(0,16,0,16),
ScaleType=Enum.ScaleType.Fit,
ThemeTag={ImageColor3="ElementDesc"},
ImageTransparency=0.3
})
end

if j then
j:SetAttribute("ItemSig",h)
table.insert(d,e+1,j)
end
end


if j then
e=e+1
j.LayoutOrder=f
j.Visible=true

if g.Type=="Text"then
if j.Text~=g.Content then
j.Text=g.Content
end
ApplyGradientToLabel(j,ResolveItemGradientProps(g.Gradient,am.DescGradient))
if#b==1 then
j.Size=UDim2.new(1,0,0,0)
j.AutomaticSize=Enum.AutomaticSize.Y
j.TextWrapped=true
else
j.Size=UDim2.new(0,0,0,0)
j.AutomaticSize=Enum.AutomaticSize.XY
j.TextWrapped=false
end
elseif g.Type=="Icon"then
if am.Color then
local l=j:FindFirstChildOfClass"ImageLabel"
local m=g.Options or{}

if l and not m.Color then
if typeof(am.Color)=="string"then
l.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[am.Color]))
elseif typeof(am.Color)=="Color3"then
l.ImageColor3=GetTextColorForHSB(am.Color)
end
end
end
else
if j.Image~=g.Content then
j.Image=g.Content
end
if am.Color then
if typeof(am.Color)=="string"then
j.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[am.Color]))
elseif typeof(am.Color)=="Color3"then
j.ImageColor3=GetTextColorForHSB(am.Color)
end
end
end
end
end



for f=e+1,#d do
d[f]:Destroy()
end
end

local aB=string.split(az,"\n")
local b={}
for d,e in ipairs(aB)do
local f=string.split(e,"\t")
if#f>=2 then
table.insert(b,{Cols={parseInline(f[1]or""),parseInline(f[2]or"")}})
else
table.insert(b,{Cols={parseInline(e)}})
end
end

local d={}
for e,f in ipairs(ay:GetChildren())do
if f:IsA"Frame"then table.insert(d,f)end
end

for e,f in ipairs(b)do
local g=d[e]

if not g then
g=ab("Frame",{
Parent=ay,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize=Enum.AutomaticSize.Y,
})
end
g.LayoutOrder=e
g.Visible=true

local h=f.Cols
if#h>=2 then
local j=getColumnWidth()
local l=getOrCreateListLayout(g)
l.Padding=UDim.new(0,0)

local m=g:FindFirstChild"Col1"
if not m then
m=ab("Frame",{
Name="Col1",
Parent=g,
BackgroundTransparency=1,
Size=UDim2.new(0,j,0,0),
AutomaticSize=Enum.AutomaticSize.Y,
})
getOrCreateListLayout(m)
else
m.Size=UDim2.new(0,j,0,0)
m.AutomaticSize=Enum.AutomaticSize.Y
getOrCreateListLayout(m)
end

local p=g:FindFirstChild"Col2"
if not p then
p=ab("Frame",{
Name="Col2",
Parent=g,
BackgroundTransparency=1,
Size=UDim2.new(1,-j,0,0),
AutomaticSize=Enum.AutomaticSize.Y,
})
getOrCreateListLayout(p)
else
p.Size=UDim2.new(1,-j,0,0)
p.AutomaticSize=Enum.AutomaticSize.Y
getOrCreateListLayout(p)
end

for r,u in ipairs(g:GetChildren())do
if u:IsA"GuiObject"and u~=m and u~=p then
u:Destroy()
end
end

updateItemsInContainer(m,h[1])
updateItemsInContainer(p,h[2])
else
for j,l in ipairs(g:GetChildren())do
if l:IsA"Frame"and(l.Name=="Col1"or l.Name=="Col2")then
l:Destroy()
end
end

getOrCreateListLayout(g)
updateItemsInContainer(g,h[1])
end
end

for e=#b+1,#d do
d[e]:Destroy()
end
end

local function UpdateTitle(az)
av.Text=az or""
ApplyGradientToLabel(av,ResolveGradientProps(am.TitleGradient))

if not az or az==""then
av.Visible=true
ax.Visible=false
return
end

if not HasRich(az)then
av.Visible=true
ax.Visible=false
return
end

local aA=ParseInline(az,"Title")









local aB=HasGradientTag(az)
if not aB then
for b,d in ipairs(aA)do
if d.Type~="Text"then
aB=true
break
end
end
end
if not aB then
av.Visible=true
ax.Visible=false
return
end

av.Visible=false
ax.Visible=true

for b,d in ipairs(ax:GetChildren())do
if d:IsA"GuiObject"then
d:Destroy()
end
end

for b,d in ipairs(aA)do
if d.Type=="Text"then
local e=CreateText(d.Content,"Title",d.Gradient)
e.LayoutOrder=b
if#aA==1 then
e.Size=UDim2.new(1,0,0,0)
e.AutomaticSize=Enum.AutomaticSize.Y
e.TextWrapped=true
else
e.Size=UDim2.new(0,0,0,0)
e.AutomaticSize=Enum.AutomaticSize.XY
e.TextWrapped=false
end
e.Parent=ax
elseif d.Type=="Icon"then

local e=aa.InlineIconFrame(d,InlineContext("Title",b))
if e then
e.LayoutOrder=b

local f=e:FindFirstChildOfClass"ImageLabel"
if f and am.Color and not(d.Options and d.Options.Color)then
if typeof(am.Color)=="string"then
f.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[am.Color]))
elseif typeof(am.Color)=="Color3"then
f.ImageColor3=GetTextColorForHSB(am.Color)
end
end

e.Parent=ax
end
else
local e=ab("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(0,18,0,18),
ScaleType=Enum.ScaleType.Fit,
ThemeTag={ImageColor3="ElementTitle"},
ImageTransparency=0,
Image=d.Content,
LayoutOrder=b,
})

if am.Color then
if typeof(am.Color)=="string"then
e.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[am.Color]))
elseif typeof(am.Color)=="Color3"then
e.ImageColor3=GetTextColorForHSB(am.Color)
end
end

e.Parent=ax
end
end
end

am.UIElements.Container=ab("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ab("UIListLayout",{
Padding=UDim.new(0,am.UIPadding),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment=am.Justify=="Between"and"Left"or"Center",
}),
at,
ab("Frame",{
Size=UDim2.new(
am.Justify=="Between"and 1 or 0,
am.Justify=="Between"and-al.TextOffset or 0,
0,
0
),
AutomaticSize=am.Justify=="Between"and"Y"or"XY",
BackgroundTransparency=1,
Name="TitleFrame",
},{
ab("UIListLayout",{
Padding=UDim.new(0,am.UIPadding),
FillDirection="Horizontal",
VerticalAlignment=(al.ElementTable and al.ElementTable.__type=="Dropdown")and"Center"
or((au and al.ElementTable and al.ElementTable.__type=="Toggle")and"Center"
or(al.Window.NewElements and(am.Justify=="Between"and"Top"or"Center")or"Center")),
HorizontalAlignment=am.Justify~="Between"and am.Justify or"Center",
}),
au,
ab("Frame",{
BackgroundTransparency=1,
AutomaticSize=am.Justify=="Between"and"Y"or"XY",
Size=UDim2.new(
am.Justify=="Between"and 1 or 0,
am.Justify=="Between"and(au and-aq-am.UIPadding or-aq)or 0,
1,
0
),
Name="TitleFrame",
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,al.Window.NewElements and am.UIPadding/2 or 0),
PaddingLeft=UDim.new(0,al.Window.NewElements and am.UIPadding/2 or 0),
PaddingRight=UDim.new(0,al.Window.NewElements and am.UIPadding/2 or 0),
PaddingBottom=UDim.new(0,al.Window.NewElements and am.UIPadding/2 or 0),
}),
ab("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
av,
ax,
ay
}),
})
})


local az=al.LockedIcon or al.LockIcon or"lock"
local aA=al.LockedIconSize or 20
local aB=al.LockedIconColor or Color3.new(1,1,1)
local b=al.LockedIconTransparency or.4

local d=aa.Image(
az,"lock",0,al.Window.Folder,"Lock",false
)
d.Size=UDim2.new(0,aA,0,aA)
d.ImageLabel.ImageColor3=aB
d.ImageLabel.ImageTransparency=b

local e=ab("TextLabel",{
Text="Locked",
TextSize=18,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
AutomaticSize="XY",
BackgroundTransparency=1,
TextColor3=Color3.new(1,1,1),
TextTransparency=.05,
})

local f=ab("Frame",{
Size=UDim2.new(1,am.UIPadding*2,1,am.UIPadding*2),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ZIndex=9999999,
})

local g,h=ad(am.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=.25,
ImageColor3=Color3.new(0,0,0),
Visible=false,
Active=false,
Parent=f,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
d,e
},nil,true)

local j,l=ad(am.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={ImageColor3="Text"},
Parent=f,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
},nil,true)

local m,p=ad(am.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={ImageColor3="Text"},
Parent=f,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8)
}),
},nil,true)

local r,u=ad(am.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={ImageColor3="Text"},
Parent=f,
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

local v,x=ad(am.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={ImageColor3="Text"},
Parent=f,
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

local z,A=ad(am.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=am.Color and.05 or.93,
Parent=al.Parent,
ThemeTag={
ImageColor3=not am.Color and"ElementBackground"or nil
},
ImageColor3=am.Color and
(
typeof(am.Color)=="string"
and Color3.fromHex(aa.Colors[am.Color])
or typeof(am.Color)=="Color3"
and am.Color
)or nil
},{
am.UIElements.Container,
f,
ab("UIPadding",{
PaddingTop=UDim.new(0,am.UIPadding),
PaddingLeft=UDim.new(0,am.UIPadding),
PaddingRight=UDim.new(0,am.UIPadding),
PaddingBottom=UDim.new(0,am.UIPadding),
}),
},true,true)

am.UIElements.Main=z
am.UIElements.Locked=g

if am.Hover then
aa.AddSignal(z.MouseEnter,function()
if ap then
ae(z,.12,{ImageTransparency=am.Color and.15 or.9}):Play()
ae(v,.12,{ImageTransparency=.9}):Play()
ae(r,.12,{ImageTransparency=.8}):Play()
aa.AddSignal(z.MouseMoved,function(B,C)
v.HoverGradient.Offset=Vector2.new(((B-z.AbsolutePosition.X)/z.AbsoluteSize.X)-0.5,0)
r.HoverGradient.Offset=Vector2.new(((B-z.AbsolutePosition.X)/z.AbsoluteSize.X)-0.5,0)
end)
end
end)
aa.AddSignal(z.InputEnded,function()
if ap then
ae(z,.12,{ImageTransparency=am.Color and.05 or.93}):Play()
ae(v,.12,{ImageTransparency=1}):Play()
ae(r,.12,{ImageTransparency=1}):Play()
end
end)
end

function am.SetTitle(B,C)
am.Title=C
UpdateTitle(C)
end

function am.SetTitleGradient(B,C)
am.TitleGradient=C
UpdateTitle(am.Title)
end

function am.SetDescGradient(B,C)
am.DescGradient=C
UpdateDesc(am.Desc)
end

function am.SetDesc(B,C)

if am.Desc==C then
return
end

am.Desc=C
UpdateDesc(C)

if al.ElementTable then
al.ElementTable.Desc=C
end
end


UpdateDesc(am.Desc)
UpdateTitle(am.Title)

function am.Colorize(B,C,F)
if am.Color then
C[F]=typeof(am.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[am.Color]))
or typeof(am.Color)=="Color3"
and GetTextColorForHSB(am.Color)
or nil
end
end

if al.ElementTable then
if av and av.GetPropertyChangedSignal then
aa.AddSignal(av:GetPropertyChangedSignal"Text",function()
if am.Title~=av.Text then
am:SetTitle(av.Text)
al.ElementTable.Title=av.Text
end
end)
end
end

function am.SetThumbnail(B,C,F)
am.Thumbnail=C
if F then
am.ThumbnailSize=F
ao=F
end

if at then
if C then
at:Destroy()
at=aa.Image(
C,
am.Title,
am.UICorner-3,
al.Window.Folder,
"Thumbnail",
false,
am.IconThemed
)
at.Size=UDim2.new(1,0,0,ao)
at.Parent=am.UIElements.Container
local G=am.UIElements.Container:FindFirstChild"UIListLayout"
if G then
at.LayoutOrder=-1
end
else
at.Visible=false
end
else
if C then
at=aa.Image(
C,
am.Title,
am.UICorner-3,
al.Window.Folder,
"Thumbnail",
false,
am.IconThemed
)
at.Size=UDim2.new(1,0,0,ao)
at.Parent=am.UIElements.Container
local G=am.UIElements.Container:FindFirstChild"UIListLayout"
if G then
at.LayoutOrder=-1
end
end
end
end

function am.SetImage(B,C,F)
am.Image=C
if F then
am.ImageSize=F
an=F
end

local G=au
if C then
local H=aa.Image(
C,
am.Title,
am.UICorner-3,
al.Window.Folder,
"Image",
not am.Color and true or false
)
if typeof(am.Color)=="string"and H.ImageLabel then
H.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[am.Color]))
elseif typeof(am.Color)=="Color3"and H.ImageLabel then
H.ImageLabel.ImageColor3=GetTextColorForHSB(am.Color)
end
H.Visible=true
H.Size=UDim2.new(0,an,0,an)
aq=an
if G and G.Parent then G:Destroy()end
H.Parent=am.UIElements.Container.TitleFrame
au=H
else
if au then
au.Visible=false
end
aq=0
end

am.UIElements.Container.TitleFrame.TitleFrame.Size=UDim2.new(1,-aq,1,0)
end

function am.Destroy(B)
z:Destroy()
end

function am.SetLockedIcon(B,C,F,G,H)
if d and d.ImageLabel then
if C then
d.ImageLabel.Image=C
end
if F then
d.Size=UDim2.new(0,F,0,F)
end
if G then
d.ImageLabel.ImageColor3=G
end
if H then
d.ImageLabel.ImageTransparency=H
end
end
end
function am.Lock(B,C,F)
ap=false
az=F or az
e.Text=C or"Locked"
g.Active=true
g.Visible=true
end

function am.Unlock(B)
ap=true
g.Active=false
g.Visible=false
end

function am.Highlight(B)
local C=ab("UIGradient",{
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
Parent=j
})

local F=ab("UIGradient",{
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
Parent=m
})

j.ImageTransparency=0.65
m.ImageTransparency=0.88

ae(C,0.75,{
Offset=Vector2.new(1,0)
}):Play()

ae(F,0.75,{
Offset=Vector2.new(1,0)
}):Play()

task.spawn(function()
task.wait(.75)
j.ImageTransparency=1
m.ImageTransparency=1
C:Destroy()
F:Destroy()
end)
end

function am.UpdateShape(B)
if al.Window.NewElements then
local C
local F=al.ParentType or(al.ParentConfig and al.ParentConfig.ParentType)
if F=="Group"or F=="Paragraph"then
C="Squircle"
else
C=getElementPosition(B.Elements,am.Index)
end

if C and z then
A:SetType(C)
h:SetType(C)
p:SetType(C)
l:SetType(C.."-Outline")
x:SetType(C)
u:SetType(C.."-Outline")
end
end
end

return am
end end function a.A()

local aa=a.load'b'
local ab=aa.New
local ad=aa.Tween

local ae={}
local af=a.load'j'.New


local function GetGradientData(ag)
if typeof(ag)=="ColorSequence"then
return ag
elseif typeof(ag)=="Color3"then
return ColorSequence.new(ag)
else
return ColorSequence.new(Color3.fromRGB(80,80,80))
end
end

function ae.New(ag,ah)
ah.Hover=false
ah.TextOffset=0
ah.ParentConfig=ah

local ai={
__type="Paragraph",
Title=ah.Title or"Paragraph",
Desc=ah.Desc or nil,
Locked=ah.Locked or false,
Elements={}
}

local aj=a.load'z'(ah)
ai.ParagraphFrame=aj


function ai.SetTitle(ak,al)
ak.Title=al
if ak.ParagraphFrame.UIElements.Title then
ak.ParagraphFrame.UIElements.Title.Text=al
end
end

function ai.SetDesc(ak,al)
ak.Desc=al
if ak.ParagraphFrame.UIElements.Description then
ak.ParagraphFrame.UIElements.Description.Text=al
end
end




function ai.SetViewport(ak,al,am)
if not ak.ParagraphFrame then return end


if ak.ViewportFrame then
ak.ViewportFrame:Destroy()
end

local an=ak.ParagraphFrame.UIElements.Main

local ao=ab("ViewportFrame",{
Name="ModelPreview",
Size=UDim2.new(0,95,0,95),
Position=UDim2.new(1,-100,0.5,-47),
BackgroundTransparency=1,
Parent=an,
ZIndex=10
})

local ap=ab("WorldModel",{Parent=ao})

if al then
local aq=al:Clone()

aq:PivotTo(CFrame.new(0,0,0))
aq.Parent=ap local


ar, as=aq:GetBoundingBox()
local at=Vector3.new(0,as.Y/2,0)

local au=ab("Camera",{
FieldOfView=50,
Parent=ao
})


local av=am or Vector3.new(0,0.8,-4.2)


au.CFrame=CFrame.lookAt(at+av,at)
ao.CurrentCamera=au
end


if an:FindFirstChild"UIElements"and an.UIElements:FindFirstChild"Content"then
an.UIElements.Content.PaddingRight=UDim.new(0,105)
end

ak.ViewportFrame=ao
return ao
end


if ah.Images and#ah.Images>0 then
local ak=ab("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize=Enum.AutomaticSize.Y,
BackgroundTransparency=1,
Parent=aj.UIElements.Container,
LayoutOrder=2
},{
ab("UIGridLayout",{
CellSize=ah.ImageSize or UDim2.new(0,70,0,70),
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


task.spawn(function()
for al,am in ipairs(ah.Images)do
local an=am.Title or"Item"
local ao=am.Quantity
local ap=am.Image
local aq=GetGradientData(am.Gradient)
local ar=aq.Keypoints[1].Value
local as=(type(am.Callback)=="function")

local at=aa.NewRoundFrame(8,"Squircle",{
ImageColor3=ar,
ClipsDescendants=true,
Parent=ak,
Active=as
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
ab("UIGradient",{Color=aq,Rotation=45}),
aa.Image(ap,an,0,ah.Window.Folder,"CardIcon",false).ImageLabel,

ao and ab("TextLabel",{
Text=ao,
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
Text=an,
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
},as)

local au=at:FindFirstChild("ImageLabel",true)
if au then
au.Size=UDim2.new(0.65,0,0.65,0)
au.AnchorPoint=Vector2.new(0.5,0.5)
au.Position=UDim2.new(0.5,0,0.45,0)
au.BackgroundTransparency=1
au.ScaleType=Enum.ScaleType.Fit
au.ZIndex=4
end

if as then
aa.AddSignal(at.MouseButton1Click,function()am.Callback()end)
aa.AddSignal(at.MouseButton1Down,function()
ad(at,0.1,{Size=UDim2.new(0,ah.ImageSize.X.Offset*0.95,0,ah.ImageSize.Y.Offset*0.95)}):Play()
end)
aa.AddSignal(at.MouseButton1Up,function()ad(at,0.1,{Size=ah.ImageSize}):Play()end)
aa.AddSignal(at.MouseLeave,function()ad(at,0.1,{Size=ah.ImageSize}):Play()end)
end



if al%3==0 then
task.wait()
end
end
end)
end


if ah.Buttons and#ah.Buttons>0 then
local ak=ab("Frame",{
Size=UDim2.new(1,0,0,38),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=aj.UIElements.Container,
LayoutOrder=3
},{
ab("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
})
})

for al,am in next,ah.Buttons do
local an=af(am.Title,am.Icon,am.Callback,"White",ak,nil,nil,ah.Window.NewElements and 12 or 10)
an.Size=UDim2.new(1,0,0,38)
end
end

return ai.__type,ai
end

return ae end function a.B()
local aa=a.load'b'local ab=
aa.New

local ad={}

function ad.New(ae,af)
local ag={
__type="Button",
Title=af.Title or"Button",
Desc=af.Desc or nil,
Icon=af.Icon or"mouse-pointer-click",
IconThemed=af.IconThemed or false,
Color=af.Color,
Justify=af.Justify or"Between",
IconAlign=af.IconAlign or"Right",
Locked=af.Locked or false,
Callback=af.Callback or function()end,
UIElements={}
}

local ah=true

ag.ButtonFrame=a.load'z'{
Title=ag.Title,
Desc=ag.Desc,
TitleGradient=af.TitleGradient,
DescGradient=af.DescGradient,
Parent=af.Parent,




Window=af.Window,
Color=ag.Color,
Justify=ag.Justify,
TextOffset=20,
Hover=true,
Scalable=true,
Tab=af.Tab,
Index=af.Index,
ElementTable=ag,
ParentConfig=af,
ParentType=af.ParentType,
}














ag.UIElements.ButtonIcon=aa.Image(
ag.Icon,
ag.Icon,
0,
af.Window.Folder,
"Button",
not ag.Color and true or nil,
ag.IconThemed
)

ag.UIElements.ButtonIcon.Size=UDim2.new(0,20,0,20)
ag.UIElements.ButtonIcon.Parent=ag.Justify=="Between"and ag.ButtonFrame.UIElements.Main or ag.ButtonFrame.UIElements.Container.TitleFrame
ag.UIElements.ButtonIcon.LayoutOrder=ag.IconAlign=="Left"and-99999 or 99999
ag.UIElements.ButtonIcon.AnchorPoint=Vector2.new(1,0.5)
ag.UIElements.ButtonIcon.Position=UDim2.new(1,0,0.5,0)

ag.ButtonFrame:Colorize(ag.UIElements.ButtonIcon.ImageLabel,"ImageColor3")

function ag.Lock(ai)
ag.Locked=true
ah=false
return ag.ButtonFrame:Lock()
end
function ag.Unlock(ai)
ag.Locked=false
ah=true
return ag.ButtonFrame:Unlock()
end

if ag.Locked then
ag:Lock()
end

aa.AddSignal(ag.ButtonFrame.UIElements.Main.MouseButton1Click,function()
if ah then
task.spawn(function()
aa.SafeCallback(ag.Callback)
end)
end
end)
return ag.__type,ag
end

return ad end function a.C()
local aa={}

local ab=a.load'b'
local ad=ab.New
local ae=ab.Tween

local af=game:GetService"UserInputService"

function aa.New(ag,ah,ai,aj,ak,al,am)
local an={}

local ao=12
local ap
if ah and ah~=""then
ap=ad("ImageLabel",{
Size=UDim2.new(1,-7,1,-7),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Image=ab.Icon(ah)[1],
ImageRectOffset=ab.Icon(ah)[2].ImageRectPosition,
ImageRectSize=ab.Icon(ah)[2].ImageRectSize,
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
})
end

local aq=ad("Frame",{
Size=UDim2.new(0,2,0,26),
BackgroundTransparency=1,
Parent=aj,
})

local ar=ab.NewRoundFrame(ao,"Squircle",{
ImageTransparency=.85,
ThemeTag={
ImageColor3="Text"
},
Parent=aq,
Size=UDim2.new(0,al and(52)or(40.8),0,24),
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(0,0,0.5,0),
},{
ab.NewRoundFrame(ao,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Toggle",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(ao,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
},{
ad("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
}
})
}),


ab.NewRoundFrame(ao,"Squircle",{
Size=UDim2.new(0,al and 30 or 20,0,20),
Position=UDim2.new(0,2,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ImageTransparency=1,
Name="Frame",
},{
ab.NewRoundFrame(ao,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0,
ThemeTag={
ImageColor3="ToggleBar",
},
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Bar"
},{
ab.NewRoundFrame(ao,"SquircleOutline2",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=.45,
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
}),
}),
ap,
ad("UIScale",{
Scale=1,
})
}),
})
})

local as
local at

local au=al and 30 or 20
local av=ar.Size.X.Offset

function an.Set(aw,ax,ay,az)
if not az then
if ax then
ae(ar.Frame,0.15,{
Position=UDim2.new(0,av-au-2,0.5,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(ar.Layer,0.1,{
ImageTransparency=0,
}):Play()

if ap then
ae(ap,0.1,{
ImageTransparency=0,
}):Play()
end
else
ae(ar.Frame,0.15,{
Position=UDim2.new(0,2,0.5,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(ar.Layer,0.1,{
ImageTransparency=1,
}):Play()

if ap then
ae(ap,0.1,{
ImageTransparency=1,
}):Play()
end
end
end

ay=ay~=false

task.spawn(function()
if ak and ay then
ab.SafeCallback(ak,ax)
end
end)
end


function an.Animate(aw,ax,ay)
if not am.Window.IsToggleDragging then
am.Window.IsToggleDragging=true

local az=ax.Position.X
local aA=ax.Position.Y
local aB=ar.Frame.Position.X.Offset
local b=false

ae(ar.Frame.Bar.UIScale,0.28,{Scale=1.5},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(ar.Frame.Bar,0.28,{ImageTransparency=.85},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if as then
as:Disconnect()
end

as=af.InputChanged:Connect(function(d)
if am.Window.IsToggleDragging and(d.UserInputType==Enum.UserInputType.MouseMovement or d.UserInputType==Enum.UserInputType.Touch)then
if b then
return
end

local e=math.abs(d.Position.X-az)
local f=math.abs(d.Position.Y-aA)

if f>e and f>10 then
b=true
am.Window.IsToggleDragging=false

if as then
as:Disconnect()
as=nil
end
if at then
at:Disconnect()
at=nil
end

ae(ar.Frame,0.15,{
Position=UDim2.new(0,aB,0.5,0)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ae(ar.Frame.Bar.UIScale,0.23,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(ar.Frame.Bar,0.23,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return
end

local g=d.Position.X-az
local h=math.max(2,math.min(aB+g,av-au-2))

ae(ar.Frame,0.05,{
Position=UDim2.new(0,h,0.5,0)
},Enum.EasingStyle.Linear,Enum.EasingDirection.Out):Play()
end
end)

if at then
at:Disconnect()
end

at=af.InputEnded:Connect(function(d)
if am.Window.IsToggleDragging and(d.UserInputType==Enum.UserInputType.MouseButton1 or d.UserInputType==Enum.UserInputType.Touch)then
am.Window.IsToggleDragging=false

if as then
as:Disconnect()
as=nil
end

if at then
at:Disconnect()
at=nil
end

if b then
return
end

local e=ar.Frame.Position.X.Offset
local f=math.abs(d.Position.X-az)

if f<10 then
ay:Set(not ay.Value,true,false)
else
local g=e+au/2
local h=av/2
local j=g>h
ay:Set(j,true,false)
end

ae(ar.Frame.Bar.UIScale,0.23,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(ar.Frame.Bar,0.23,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end)
end
end

return aq,an
end

return aa end function a.D()
local aa={}

local ab=a.load'b'
local ad=ab.New
local ae=ab.Tween


function aa.New(af,ag,ah,ai,aj,ak)
local al={}

ag=ag or"sfsymbols:checkmark"

local am=9

local an=ab.Image(
ag,
ag,
0,
(ak and ak.Window.Folder or"Temp"),
"Checkbox",
true,
false,
"CheckboxIcon"
)
an.Size=UDim2.new(1,-26+ah,1,-26+ah)
an.AnchorPoint=Vector2.new(0.5,0.5)
an.Position=UDim2.new(0.5,0,0.5,0)


local ao=ab.NewRoundFrame(am,"Squircle",{
ImageTransparency=.85,
ThemeTag={
ImageColor3="Text"
},
Parent=ai,
Size=UDim2.new(0,26,0,26),
},{
ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Checkbox",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(am,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
},{
ad("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
}
})
}),

an,
})

function al.Set(ap,aq)
if aq then
ae(ao.Layer,0.06,{
ImageTransparency=0,
}):Play()



ae(an.ImageLabel,0.06,{
ImageTransparency=0,
}):Play()
else
ae(ao.Layer,0.05,{
ImageTransparency=1,
}):Play()



ae(an.ImageLabel,0.06,{
ImageTransparency=1,
}):Play()
end

task.spawn(function()
if aj then
ab.SafeCallback(aj,aq)
end
end)
end

return ao,al
end


return aa end function a.E()
local aa=a.load'b'
local ab=aa.New local ad=
aa.Tween

local ae=a.load'C'.New
local af=a.load'D'.New

local ag={}

function ag.New(ah,ai)
local aj={
__type="Toggle",
Title=ai.Title or"Toggle",
Desc=ai.Desc or nil,
Locked=ai.Locked or false,
Disabled=ai.Disabled or false,
Value=ai.Value,
Icon=ai.Icon or nil,
IconSize=ai.IconSize or 23,
Image=ai.Image,
ImageSize=ai.ImageSize or 30,
Thumbnail=ai.Thumbnail,
ThumbnailSize=ai.ThumbnailSize or 80,
Type=ai.Type or"Toggle",
Callback=ai.Callback or function()end,
UIElements={}
}


local ak=aj.Image
if typeof(ak)=="table"then
ak=nil
end

aj.ToggleFrame=a.load'z'{
Title=aj.Title,
Desc=aj.Desc,
TitleGradient=ai.TitleGradient,
DescGradient=ai.DescGradient,
Image=ak,
ImageSize=aj.ImageSize,
Thumbnail=aj.Thumbnail,
ThumbnailSize=aj.ThumbnailSize,
Window=ai.Window,
Parent=ai.Parent,
TextOffset=(52),
Hover=false,
Tab=ai.Tab,
Index=ai.Index,
ElementTable=aj,
ParentConfig=ai,
ParentType=ai.ParentType,
}

local al=true
local am=true

if aj.Value==nil then
aj.Value=false
end


function aj.SetMainImage(an,ao,ap)
local aq=aj.ToggleFrame.UIElements.Container:FindFirstChild"TitleFrame"
if not aq then return end

local ar=aq:FindFirstChild"CustomMainIcon"
if ar then ar:Destroy()end

for as,at in ipairs(aq:GetChildren())do
if at:IsA"Frame"and at.Name~="TitleFrame"and at.Name~="UIListLayout"and at.Name~="CustomMainIcon"then
at:Destroy()
end
end

if not ao then
local as=aq:FindFirstChild"TitleFrame"
if as then as.Size=UDim2.new(1,0,1,0)end
return
end

local as=ap or aj.ImageSize or 30
if typeof(as)=="number"then
as=UDim2.new(0,as,0,as)
end

local at


if typeof(ao)=="table"then
local au=ao
local av=au.Image or""
local aw=au.Gradient
local ax=au.Quantity
local ay=au.Rate
local az=au.Title

local aA
if typeof(aw)=="ColorSequence"then
aA=aw
elseif typeof(aw)=="Color3"then
aA=ColorSequence.new(aw)
else
aA=ColorSequence.new(Color3.fromRGB(80,80,80))
end

local aB=aA.Keypoints[1].Value
local b=2


at=aa.NewRoundFrame(8,"Squircle",{
Name="CustomMainIcon",
Size=as,
Parent=aq,
ImageColor3=aB,
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
Size=UDim2.new(1,-b*2,1,-b*2),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageColor3=Color3.new(1,1,1),
ClipsDescendants=true,
ZIndex=3,
},{

ab("UIGradient",{
Color=aA,
Rotation=45,
}),

ab("ImageLabel",{
Image=av,
Size=UDim2.new(0.65,0,0.65,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.45,0),
BackgroundTransparency=1,
ScaleType="Fit",
ZIndex=4,
}),


ax and ab("TextLabel",{
Text=ax,
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


ay and ab("TextLabel",{
Text=ay,
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


az and ab("Frame",{
Size=UDim2.new(1,0,0,18),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.4,
BorderSizePixel=0,
ZIndex=6,
},{
ab("TextLabel",{
Text=az,
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
at=aa.Image(
ao,
aj.Title,
ai.Window.NewElements and 12 or 6,
ai.Window.Folder,
"ToggleIcon",
false
)
at.Name="CustomMainIcon"
at.Parent=aq
at.Size=as
at.LayoutOrder=-1
at.AnchorPoint=Vector2.new(0,0.5)
at.Position=UDim2.new(0,0,0.5,0)
at.BackgroundTransparency=1
end

local au=aq:FindFirstChild"TitleFrame"
if au then
au.Size=UDim2.new(1,-as.X.Offset,1,0)
end
end

if typeof(aj.Image)=="table"then
aj:SetMainImage(aj.Image,aj.ImageSize)
end


function aj.Lock(an,ao)
aj.Locked=true
al=false
return aj.ToggleFrame:Lock(ao)
end
function aj.Unlock(an)
aj.Locked=false
al=true
return aj.ToggleFrame:Unlock()
end
function aj.Disable(an)
aj.Disabled=true
end
function aj.Enable(an)
aj.Disabled=false
end

if aj.Locked then
aj:Lock()
end

local an=aj.Value

local ao,ap
if aj.Type=="Toggle"then
ao,ap=ae(an,aj.Icon,aj.IconSize,aj.ToggleFrame.UIElements.Main,aj.Callback,ai.Window.NewElements,ai)
elseif aj.Type=="Checkbox"then
ao,ap=af(an,aj.Icon,aj.IconSize,aj.ToggleFrame.UIElements.Main,aj.Callback,ai)
else
error("Unknown Toggle Type: "..tostring(aj.Type))
end

ao.AnchorPoint=Vector2.new(1,ai.Window.NewElements and 0 or 0.5)
ao.Position=UDim2.new(1,0,ai.Window.NewElements and 0 or 0.5,0)

function aj.Set(aq,ar,as,at,au)
if al and((au==true)or(not aj.Disabled)or am)then
ap:Set(ar,as,at or false)
an=ar
aj.Value=ar
end
end

aj:Set(an,false,ai.Window.NewElements)
am=false


if ai.Window.NewElements and ap.Animate then
aa.AddSignal(aj.ToggleFrame.UIElements.Main.InputBegan,function(aq)
if aq.UserInputType==Enum.UserInputType.MouseButton1 or aq.UserInputType==Enum.UserInputType.Touch then
if aj.Disabled then
return
end
ap:Animate(aq,aj)
end
end)
else
aa.AddSignal(aj.ToggleFrame.UIElements.Main.MouseButton1Click,function()
if aj.Disabled then
return
end
aj:Set(not aj.Value,nil,ai.Window.NewElements)
end)
end

return aj.__type,aj
end

return ag end function a.F()

local aa=a.load'b'
local ab=aa.New
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
TitleGradient=ai.TitleGradient,
DescGradient=ai.DescGradient,
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

aj.UIElements.SliderContainer=ab("Frame",{
Size=UDim2.new(0,aj.Width,0,0),
AutomaticSize="Y",
Position=UDim2.new(1,ai.Window.NewElements and-20 or 0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
BackgroundTransparency=1,
Parent=aj.SliderFrame.UIElements.Main,
},{
ab("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aj.UIElements.SliderIcon,
ab("TextBox",{
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

local ab=aa(game:GetService"UserInputService")

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
TitleGradient=aj.TitleGradient,
DescGradient=aj.DescGradient,
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
am=ab.InputBegan:Connect(function(an)
local ao

if an.UserInputType==Enum.UserInputType.Keyboard then
ao=an.KeyCode.Name
elseif an.UserInputType==Enum.UserInputType.MouseButton1 then
ao="MouseLeft"
elseif an.UserInputType==Enum.UserInputType.MouseButton2 then
ao="MouseRight"
end

local ap
ap=ab.InputEnded:Connect(function(aq)
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

ad.AddSignal(ab.InputBegan,function(am,an)
if ab:GetFocusedTextBox()then
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
local ab=aa.New local ad=
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
TitleGradient=ai.TitleGradient,
DescGradient=ai.DescGradient,
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

ab("UIScale",{
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
local ab=aa.New

local ae={}

function ae.New(af,ag)
local ah=ab("Frame",{
Size=ag.ParentType~="Group"and UDim2.new(1,0,0,1)or UDim2.new(0,1,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local ai=ab("Frame",{
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

local ab=(cloneref or clonereference or function(ab)return ab end)

local ae=ab(game:GetService"UserInputService")
local af=ab(game:GetService"Players").LocalPlayer:GetMouse()
local ag=ab(game:GetService"Workspace").CurrentCamera

local ah=a.load'b'
local ai=ah.New
local aj=ah.Tween

local ak=workspace.CurrentCamera

function aa.New(al,am,an,ao,ap)
local aq={}

if not am.Callback then
ap="Menu"
end

local ar=setmetatable({},{__mode="k"})

local function BuildImagesSignature(as)
if not as or#as==0 then return""end
local at=table.create(#as)
for au,av in ipairs(as)do
if typeof(av)=="table"then
local aw=av.Image or av.Icon or av.Id or""
local ax=av.Size or""
local ay=av.Gradient or""
at[au]=tostring(aw).."|"..tostring(av.Title or"").."|"..tostring(av.Quantity or"").."|"..tostring(av.Rate or"").."|"..tostring(ax).."|"..tostring(ay)
else
at[au]=tostring(av)
end
end
return table.concat(at,"||")
end

local function RenderImages(as,at)
local au=ar[as]
if not au then
au={token=0,lastSignature=""}
ar[as]=au
end

local av=BuildImagesSignature(at)
if av==au.lastSignature then
return
end

au.lastSignature=av
au.token=au.token+1
local aw=au.token

for ax,ay in ipairs(as:GetChildren())do
if not ay:IsA"UIListLayout"and not ay:IsA"UIPadding"then
ay:Destroy()
end
end

if not at or#at==0 then return end

task.spawn(function()
local ax=#at
local ay=0.004
if ax>=20 then
ay=0.002
elseif ax>=10 then
ay=0.003
end
local az=os.clock()
for aA,aB in ipairs(at)do
if ar[as]~=au or au.token~=aw then
return
end
local b=false
if typeof(aB)=="table"and(aB.Quantity or aB.Gradient or aB.Card)then
b=true
end

if b then
local d=aB.Size or am.ImageSize or UDim2.new(0,60,0,60)
local e=aB.Title or"Item"
local f=aB.Quantity or""
local g=aB.Rate or""
local h=aB.Image or""
local j=aB.Gradient

local l
if typeof(j)=="ColorSequence"then
l=j
elseif typeof(j)=="Color3"then
l=ColorSequence.new(j)
else
l=ColorSequence.new(Color3.fromRGB(80,80,80))
end

local m=l.Keypoints[1].Value
local p=2


ah.NewRoundFrame(8,"Squircle",{
Size=d,
Parent=as,
ImageColor3=m,
ClipsDescendants=true,
},{
ai("ImageLabel",{
Image="rbxassetid://5554236805",
ScaleType=Enum.ScaleType.Slice,
SliceCenter=Rect.new(23,23,277,277),
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ImageColor3=Color3.new(0,0,0),
ImageTransparency=0.4,
ZIndex=2,
}),

(ah.NewRoundFrame(8,"Squircle",{
Size=UDim2.new(1,-p*2,1,-p*2),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageColor3=Color3.new(1,1,1),
ClipsDescendants=true,
ZIndex=3,
},{
ai("UIGradient",{Color=l,Rotation=45}),
ai("ImageLabel",{
Image=h,
Size=UDim2.new(0.65,0,0.65,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.45,0),
BackgroundTransparency=1,
ScaleType="Fit",
ZIndex=4,
}),
f and ai("TextLabel",{
Text=f,
Size=UDim2.new(0.5,0,0,12),
Position=UDim2.new(0,4,0,2),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(ah.Font,Enum.FontWeight.Bold),
TextSize=10,
TextStrokeTransparency=0,
TextStrokeColor3=Color3.new(0,0,0),
ZIndex=5,
})or nil,
g and ai("TextLabel",{
Text=g,
Size=UDim2.new(0.5,-4,0,12),
Position=UDim2.new(1,-4,0,2),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Right,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(ah.Font,Enum.FontWeight.Bold),
TextSize=10,
TextStrokeTransparency=0,
TextStrokeColor3=Color3.new(0,0,0),
ZIndex=5,
})or nil,
ai("Frame",{
Size=UDim2.new(1,0,0,18),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.4,
BorderSizePixel=0,
ZIndex=6,
},{
ai("TextLabel",{
Text=e,
Size=UDim2.new(1,-2,1,0),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Center,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(ah.Font,Enum.FontWeight.Bold),
TextSize=9,
TextWrapped=true,
TextTruncate="AtEnd",
ZIndex=7,
}),
})
}))
})
else
local d=(typeof(aB)=="table"and(aB.Image or aB.Icon or aB.Id))or aB
local e=ah.Image(d,tostring(d),6,al.Window.Folder,"Dropdown",false)
e.Size=am.ImageSize or UDim2.new(0,30,0,30)
e.Parent=as
end
if os.clock()-az>=ay then
task.wait()
az=os.clock()
end
end
end)
end


am.UIElements.UIListLayout=ai("UIListLayout",{
Padding=UDim.new(0,an.MenuPadding/1.5),
FillDirection="Vertical",
HorizontalAlignment="Center",
})

am.UIElements.Menu=ah.NewRoundFrame(an.MenuCorner,"Squircle",{
ThemeTag={ImageColor3="Background"},
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
},{
ai("UIPadding",{
PaddingTop=UDim.new(0,an.MenuPadding),
PaddingLeft=UDim.new(0,an.MenuPadding),
PaddingRight=UDim.new(0,an.MenuPadding),
PaddingBottom=UDim.new(0,an.MenuPadding),
}),
ai("UIListLayout",{FillDirection="Vertical",Padding=UDim.new(0,an.MenuPadding)}),
ai("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,am.SearchBarEnabled and-an.MenuPadding-an.SearchBarHeight),
Name="Frame",
ClipsDescendants=true,
LayoutOrder=999,
},{
ai("UICorner",{CornerRadius=UDim.new(0,an.MenuCorner-an.MenuPadding)}),
ai("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
ScrollBarThickness=0,
ScrollingDirection="Y",
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
ScrollBarImageTransparency=1,
},{
am.UIElements.UIListLayout,
})
})
})

am.UIElements.MenuCanvas=ai("Frame",{
Size=UDim2.new(0,am.MenuWidth,0,300),
BackgroundTransparency=1,
Position=UDim2.new(-10,0,-10,0),
Visible=false,
Active=false,
Parent=al.ANUI.DropdownGui,
AnchorPoint=Vector2.new(1,0),
},{
am.UIElements.Menu,
ai("UISizeConstraint",{
MinSize=Vector2.new(170,0),
MaxSize=Vector2.new(300,400),
})
})

local function RecalculateCanvasSize()
am.UIElements.Menu.Frame.ScrollingFrame.CanvasSize=UDim2.fromOffset(0,am.UIElements.UIListLayout.AbsoluteContentSize.Y)
end
local function RecalculateListSize()
local as=ak.ViewportSize.Y*0.6
local at=am.UIElements.UIListLayout.AbsoluteContentSize.Y
local au=am.SearchBarEnabled and(an.SearchBarHeight+(an.MenuPadding*3))or(an.MenuPadding*2)
local av=(at)+au
if av>as then
am.UIElements.MenuCanvas.Size=UDim2.fromOffset(am.UIElements.MenuCanvas.AbsoluteSize.X,as)
else
am.UIElements.MenuCanvas.Size=UDim2.fromOffset(am.UIElements.MenuCanvas.AbsoluteSize.X,av)
end
end

function UpdatePosition()
local as=am.UIElements.Dropdown or am.DropdownFrame.UIElements.Main
local at=am.UIElements.MenuCanvas
local au=ag.ViewportSize.Y-(as.AbsolutePosition.Y+as.AbsoluteSize.Y)-an.MenuPadding-54
local av=at.AbsoluteSize.Y+an.MenuPadding
local aw=-54
if au<av then aw=av-au-54 end
at.Position=UDim2.new(0,as.AbsolutePosition.X+as.AbsoluteSize.X,0,as.AbsolutePosition.Y+as.AbsoluteSize.Y-aw+(an.MenuPadding*2))
end

local as

function aq.Display(at)
local au=am.Values
local av=""
if am.Multi then
local aw={}
if typeof(am.Value)=="table"then
for ax,ay in ipairs(am.Value)do
local az=typeof(ay)=="table"and ay.Title or ay
aw[az]=true
end
end
for ax,ay in ipairs(au)do
local az=typeof(ay)=="table"and ay.Title or ay
if aw[az]then av=av..az..", "end
end
if#av>0 then av=av:sub(1,#av-2)end
else
av=typeof(am.Value)=="table"and am.Value.Title or am.Value or""
end
if am.UIElements.Dropdown then
am.UIElements.Dropdown.Frame.Frame.TextLabel.Text=(av==""and"--"or av)
end
end

local function Callback(at)
aq:Display()
if am.Callback then
task.spawn(function()ah.SafeCallback(am.Callback,am.Value)end)
else
task.spawn(function()ah.SafeCallback(at)end)
end
end

function aq.Refresh(at,au)

if am._ActiveRefreshTask then
task.cancel(am._ActiveRefreshTask)
am._ActiveRefreshTask=nil
end


local av=am.UIElements.Menu.Frame.ScrollingFrame
for aw,ax in next,av:GetChildren()do
if not ax:IsA"UIListLayout"and not ax:IsA"UIPadding"and ax.Name~="SearchBar"then
ax:Destroy()
end
end

am.Tabs={}


if am.SearchBarEnabled then
if not as then
as=CreateInput("Search...","search",am.UIElements.Menu,nil,function(aw)
for ax,ay in next,am.Tabs do
if string.find(string.lower(ay.Name),string.lower(aw),1,true)then
ay.UIElements.TabItem.Visible=true
else
ay.UIElements.TabItem.Visible=false
end
end
RecalculateListSize()
RecalculateCanvasSize()
end,true)
as.Size=UDim2.new(1,0,0,an.SearchBarHeight)
as.Position=UDim2.new(0,0,0,0)
as.Name="SearchBar"
else
as.Parent=am.UIElements.Menu
end
end


am._ActiveRefreshTask=task.spawn(function()
local aw=0
local ax=2

for ay,az in next,au do
if not am.UIElements.Menu or not am.UIElements.Menu.Parent then break end

if(az.Type~="Divider")then

local aA={
Name=typeof(az)=="table"and az.Title or az,
Desc=typeof(az)=="table"and az.Desc or nil,
Icon=typeof(az)=="table"and az.Icon or nil,
Images=typeof(az)=="table"and az.Images or nil,
Original=az,
Selected=false,
Locked=typeof(az)=="table"and az.Locked or false,
UIElements={},
}

local aB
if aA.Icon then
aB=ah.Image(aA.Icon,aA.Icon,0,al.Window.Folder,"Dropdown",true)
aB.Size=UDim2.new(0,an.TabIcon,0,an.TabIcon)
aB.ImageLabel.ImageTransparency=ap=="Dropdown"and.2 or 0
aA.UIElements.TabIcon=aB
end


aA.UIElements.TabItem=ah.NewRoundFrame(an.MenuCorner-an.MenuPadding,"Squircle",{
Size=UDim2.new(1,0,0,36),
AutomaticSize=((aA.Desc or(aA.Images and#aA.Images>0))and"Y")or nil,
ImageTransparency=1,
Parent=am.UIElements.Menu.Frame.ScrollingFrame,
ImageColor3=Color3.new(1,1,1),
Active=not aA.Locked,
},{
ah.NewRoundFrame(an.MenuCorner-an.MenuPadding,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=1,
Name="Highlight",
},{
ai("UIGradient",{
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
ai("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Frame",
},{
ai("UIListLayout",{Padding=UDim.new(0,an.TabPadding),FillDirection="Horizontal",VerticalAlignment="Center"}),
ai("UIPadding",{
PaddingTop=UDim.new(0,an.TabPadding),
PaddingLeft=UDim.new(0,an.TabPadding),
PaddingRight=UDim.new(0,an.TabPadding),
PaddingBottom=UDim.new(0,an.TabPadding),
}),
ai("UICorner",{CornerRadius=UDim.new(0,an.MenuCorner-an.MenuPadding)}),
aB,
ai("Frame",{
Size=UDim2.new(1,aB and-an.TabPadding-an.TabIcon or 0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Name="Title",
},{
ai("TextLabel",{
Text=aA.Name,
TextXAlignment="Left",
FontFace=Font.new(ah.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text",BackgroundColor3="Text"},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=ap=="Dropdown"and.4 or.05,
LayoutOrder=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
}),
ai("TextLabel",{
Text=aA.Desc or"",
TextXAlignment="Left",
FontFace=Font.new(ah.Font,Enum.FontWeight.Regular),
ThemeTag={TextColor3="Text",BackgroundColor3="Text"},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=ap=="Dropdown"and.6 or.35,
LayoutOrder=2,
AutomaticSize="Y",
TextWrapped=true,
Size=UDim2.new(1,0,0,0),
Visible=aA.Desc and true or false,
Name="Desc",
}),
ai("ScrollingFrame",{
Size=UDim2.new(1,0,0,70),
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.None,
AutomaticCanvasSize=Enum.AutomaticSize.X,
ScrollingDirection=Enum.ScrollingDirection.X,
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
Visible=(aA.Images and#aA.Images>0)and true or false,
LayoutOrder=3,
Name="Images",
},{
ai("UIListLayout",{FillDirection="Horizontal",Padding=UDim.new(0,am.ImagePadding or an.TabPadding/3),VerticalAlignment="Center"}),
ai("UIPadding",{PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,2),PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,2)})
}),
ai("UIListLayout",{Padding=UDim.new(0,an.TabPadding/3),FillDirection="Vertical"}),
})
})
},true)


if aA.Images and#aA.Images>0 then
local b=aA.UIElements.TabItem.Frame.Title:FindFirstChild"Images"
if b then
b.Active=true


local d=false
local e=Vector2.new()
local f=Vector2.new()
b.InputBegan:Connect(function(g)
if g.UserInputType==Enum.UserInputType.MouseButton1 then
d=true
e=g.Position
f=b.CanvasPosition
end
end)
b.InputEnded:Connect(function(g)
if g.UserInputType==Enum.UserInputType.MouseButton1 then d=false end
end)
b.InputChanged:Connect(function(g)
if g.UserInputType==Enum.UserInputType.MouseMovement and d then
local h=g.Position-e
b.CanvasPosition=Vector2.new(f.X-h.X,0)
elseif g.UserInputType==Enum.UserInputType.MouseWheel then
local h=g.Position.Z*-35
b.CanvasPosition=b.CanvasPosition+Vector2.new(h,0)
end
end)


RenderImages(b,aA.Images)




aw=0
end
else

aw=aw+1
end

if aA.Locked then
aA.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0.6
if aA.UIElements.TabIcon then aA.UIElements.TabIcon.ImageLabel.ImageTransparency=0.6 end
end


if am.Multi and typeof(am.Value)=="string"then
for b,d in next,am.Values do
if typeof(d)=="table"then if d.Title==am.Value then am.Value={d}end else if d==am.Value then am.Value={am.Value}end end
end
end
local b=false
if am.Multi then
if typeof(am.Value)=="table"then for d,e in ipairs(am.Value)do local f=typeof(e)=="table"and e.Title or e if f==aA.Name then b=true break end end end
else
local d=typeof(am.Value)=="table"and am.Value.Title or am.Value
b=(d==aA.Name)
end
aA.Selected=b
if aA.Selected and not aA.Locked then
aA.UIElements.TabItem.ImageTransparency=.95
aA.UIElements.TabItem.Highlight.ImageTransparency=.75
aA.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0
if aA.UIElements.TabIcon then aA.UIElements.TabIcon.ImageLabel.ImageTransparency=0 end
end

am.Tabs[ay]=aA


if ap=="Dropdown"then
ah.AddSignal(aA.UIElements.TabItem.MouseButton1Click,function()
if aA.Locked then return end
if am.Multi then
if typeof(am.Value)~="table"then am.Value={}end
if not aA.Selected then
aA.Selected=true
aj(aA.UIElements.TabItem,0.1,{ImageTransparency=.95}):Play()
aj(aA.UIElements.TabItem.Highlight,0.1,{ImageTransparency=.75}):Play()
aj(aA.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aA.UIElements.TabIcon then aj(aA.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()end
table.insert(am.Value,aA.Original)
else
if not am.AllowNone and#am.Value==1 then return end
aA.Selected=false
aj(aA.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
aj(aA.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
aj(aA.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=.4}):Play()
if aA.UIElements.TabIcon then aj(aA.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=.2}):Play()end
for d,e in next,am.Value do
if typeof(e)=="table"and(e.Title==aA.Name)or(e==aA.Name)then
table.remove(am.Value,d)
break
end
end
end
else
if am.AllowNone and aA.Selected then
aA.Selected=false
aj(aA.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
aj(aA.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
aj(aA.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=.4}):Play()
if aA.UIElements.TabIcon then aj(aA.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=.2}):Play()end
am.Value=nil
else
for d,e in next,am.Tabs do
aj(e.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
aj(e.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
aj(e.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=.4}):Play()
if e.UIElements.TabIcon then aj(e.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=.2}):Play()end
e.Selected=false
end
aA.Selected=true
aj(aA.UIElements.TabItem,0.1,{ImageTransparency=.95}):Play()
aj(aA.UIElements.TabItem.Highlight,0.1,{ImageTransparency=.75}):Play()
aj(aA.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aA.UIElements.TabIcon then aj(aA.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()end
am.Value=aA.Original
end
end
Callback()
end)
elseif ap=="Menu"then
if not aA.Locked then
ah.AddSignal(aA.UIElements.TabItem.MouseEnter,function()aj(aA.UIElements.TabItem,0.08,{ImageTransparency=.95}):Play()end)
ah.AddSignal(aA.UIElements.TabItem.InputEnded,function()aj(aA.UIElements.TabItem,0.08,{ImageTransparency=1}):Play()end)
end
ah.AddSignal(aA.UIElements.TabItem.MouseButton1Click,function()
if aA.Locked then return end
Callback(az.Callback or function()end)
end)
end

else a.load'I'
:New{Parent=am.UIElements.Menu.Frame.ScrollingFrame}
aw=aw+1
end



if aw>=ax then
RecalculateCanvasSize()
task.wait()
aw=0
end
end


local ay=am.MenuWidth or 0
if ay==0 then
for az,aA in next,am.Tabs do
if aA.UIElements.TabItem and aA.UIElements.TabItem.Frame.UIListLayout then ay=math.max(ay,aA.UIElements.TabItem.Frame.UIListLayout.AbsoluteContentSize.X)end
end
end
am.UIElements.MenuCanvas.Size=UDim2.new(0,ay+30,am.UIElements.MenuCanvas.Size.Y.Scale,am.UIElements.MenuCanvas.Size.Y.Offset)

Callback()
am.Values=au
RecalculateCanvasSize()
RecalculateListSize()

am._ActiveRefreshTask=nil
end)
end

aq:Refresh(am.Values)


function aq.Select(at,au)
if au then am.Value=au else
if am.Multi then am.Value={}else am.Value=nil end
end
aq:Refresh(am.Values)
end

function aq.Edit(at,au,av)
for aw,ax in ipairs(am.Tabs)do
if ax.Name==au then
local ay=am.Values[aw]
if ay and type(ay)=="table"then
if av.Title then ay.Title=av.Title end
if av.Desc then ay.Desc=av.Desc end
if av.Icon then ay.Icon=av.Icon end
if av.Images then ay.Images=av.Images end

if av.Title then ax.Name=av.Title end
if av.Desc then ax.Desc=av.Desc ax.Original.Desc=av.Desc end
if av.Images then ax.Images=av.Images ax.Original.Images=av.Images end
end

local az=ax.UIElements
if az and az.TabItem then
local aA=az.TabItem:FindFirstChild"Frame"
local aB=aA and aA:FindFirstChild"Title"

if aB then
if av.Title then
local b=aB:FindFirstChild"TextLabel"
if b then b.Text=av.Title end
end
if av.Desc then
local b=aB:FindFirstChild"Desc"
if b then
b.Text=av.Desc
b.Visible=true
ax.UIElements.TabItem.AutomaticSize=Enum.AutomaticSize.Y
end
end
if av.Images then
local b=aB:FindFirstChild"Images"
if b then
b.Visible=(av.Images and#av.Images>0)
RenderImages(b,av.Images)
ax.UIElements.TabItem.AutomaticSize=Enum.AutomaticSize.Y
end
end
end

if av.Icon and az.TabIcon then
local b=az.TabIcon:FindFirstChild"ImageLabel"
if b then
local d=ah.Icon(av.Icon)
if d then
b.Image=d[1]
b.ImageRectOffset=d[2].ImageRectPosition
b.ImageRectSize=d[2].ImageRectSize
else
b.Image=av.Icon
b.ImageRectOffset=Vector2.new(0,0)
b.ImageRectSize=Vector2.new(0,0)
end
if av.Gradient then
local e=b:FindFirstChildOfClass"UIGradient"or ai("UIGradient",{Parent=b})
e.Color=av.Gradient
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

function aq.EditDrop(at,au,av)
local aw
local ax

if type(au)=="number"then
aw=au
ax=am.Tabs[au]
else
for ay,az in ipairs(am.Tabs)do
if az.Name==au then aw=ay ax=az break end
end
end

if ax and aw then
local ay=am.Values[aw]
if type(ay)~="table"then
ay={Title=ay,Value=ay}
am.Values[aw]=ay
end

if av.Title then ay.Title=av.Title end
if av.Desc then ay.Desc=av.Desc end
if av.Icon then ay.Icon=av.Icon end
if av.Images then ay.Images=av.Images end
if av.Gradient then ay.Gradient=av.Gradient end
if av.Value then ay.Value=av.Value end

if av.Title then ax.Name=av.Title end
if av.Desc then ax.Desc=av.Desc ax.Original.Desc=av.Desc end
if av.Images then ax.Images=av.Images ax.Original.Images=av.Images end
for az,aA in pairs(av)do ax.Original[az]=aA end

local az=ax.UIElements
if az and az.TabItem then
local aA=az.TabItem:FindFirstChild"Frame"
local aB=aA and aA:FindFirstChild"Title"

if aB then
if av.Title then
local b=aB:FindFirstChild"TextLabel"
if b then b.Text=av.Title end
end
if av.Desc then
local b=aB:FindFirstChild"Desc"
if b then
b.Text=av.Desc
b.Visible=true
az.TabItem.AutomaticSize=Enum.AutomaticSize.Y
end
end
if av.Images then
local b=aB:FindFirstChild"Images"
if b then
b.Visible=(av.Images and#av.Images>0)
RenderImages(b,av.Images)
az.TabItem.AutomaticSize=Enum.AutomaticSize.Y
end
end
end

if av.Icon and az.TabIcon then
local b=az.TabIcon:FindFirstChild"ImageLabel"
if b then
local d=ah.Icon(av.Icon)
if d then
b.Image=d[1]
b.ImageRectOffset=d[2].ImageRectPosition
b.ImageRectSize=d[2].ImageRectSize
else
b.Image=av.Icon
b.ImageRectOffset=Vector2.new(0,0)
b.ImageRectSize=Vector2.new(0,0)
end

if av.Gradient then
local e=b:FindFirstChildOfClass"UIGradient"or ai("UIGradient",{Parent=b})
e.Color=av.Gradient
end
end
end
end

local aA=am.Value
local aB=false
if not am.Multi and aA==ay then aB=true end

if aB then
if am.UIElements.Dropdown and av.Title then
local b=am.UIElements.Dropdown:FindFirstChild"Frame"
local d=b and b:FindFirstChild"Frame"
local e=d and d:FindFirstChild"TextLabel"
if e then e.Text=av.Title end
end

am.Value=ay

if av.Desc then aq:SetDesc(av.Desc)end

if av.Icon then
aq:SetValueImage(av.Icon)
if av.Gradient then
aq:SetMainImage({Image=av.Icon,Quantity="",Gradient=av.Gradient},50)
else
aq:SetMainImage(av.Icon)
end
end
end

RecalculateCanvasSize()
RecalculateListSize()
end
end

RecalculateListSize()
RecalculateCanvasSize()

function aq.Open(at)
if ao then
am.UIElements.Menu.Visible=true
am.UIElements.MenuCanvas.Visible=true
am.UIElements.MenuCanvas.Active=true
am.UIElements.Menu.Size=UDim2.new(1,0,0,0)
aj(am.UIElements.Menu,0.1,{Size=UDim2.new(1,0,1,0),ImageTransparency=0.05},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()
task.spawn(function()task.wait(.1)am.Opened=true end)
UpdatePosition()
end
end

function aq.Close(at)
am.Opened=false
aj(am.UIElements.Menu,0.25,{Size=UDim2.new(1,0,0,0),ImageTransparency=1},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()
task.spawn(function()task.wait(.1)am.UIElements.Menu.Visible=false end)
task.spawn(function()task.wait(.25)am.UIElements.MenuCanvas.Visible=false am.UIElements.MenuCanvas.Active=false end)
end

ah.AddSignal((am.UIElements.Dropdown and am.UIElements.Dropdown.MouseButton1Click or am.DropdownFrame.UIElements.Main.MouseButton1Click),function()
aq:Open()
end)

ah.AddSignal(ae.InputBegan,function(at)
if at.UserInputType==Enum.UserInputType.MouseButton1 or at.UserInputType==Enum.UserInputType.Touch then
local au=am.UIElements.MenuCanvas
local av,aw=au.AbsolutePosition,au.AbsoluteSize
local ax=am.UIElements.Dropdown or am.DropdownFrame.UIElements.Main
local ay=ax.AbsolutePosition
local az=ax.AbsoluteSize

local aA=af.X>=ay.X and af.X<=ay.X+az.X and af.Y>=ay.Y and af.Y<=ay.Y+az.Y
local aB=af.X>=av.X and af.X<=av.X+aw.X and af.Y>=av.Y and af.Y<=av.Y+aw.Y

if al.Window.CanDropdown and am.Opened and not aA and not aB then
aq:Close()
end
end
end)

ah.AddSignal(
am.UIElements.Dropdown and am.UIElements.Dropdown:GetPropertyChangedSignal"AbsolutePosition"or am.DropdownFrame.UIElements.Main:GetPropertyChangedSignal"AbsolutePosition",
UpdatePosition
)

return aq
end

return aa end function a.K()

local aa=(cloneref or clonereference or function(aa)return aa end)

aa(game:GetService"UserInputService")
aa(game:GetService"Players").LocalPlayer:GetMouse()local ab=
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
TitleGradient=an.TitleGradient,
DescGradient=an.DescGradient,
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




function ao.SetMainImage(aq,ar,as)

local at=ao.DropdownFrame.UIElements.Container:FindFirstChild"TitleFrame"

if not at then return end



local au=at:FindFirstChild"CustomMainIcon"
if au then
au:Destroy()
end


for av,aw in ipairs(at:GetChildren())do
if aw:IsA"Frame"and aw.Name~="TitleFrame"and aw.Name~="UIListLayout"and aw.Name~="CustomMainIcon"then
aw:Destroy()
end
end


if not ar then
local av=at:FindFirstChild"TitleFrame"
if av then
av.Size=UDim2.new(1,0,1,0)
end
return
end


local av=as or ao.ImageSize or 30
if typeof(av)=="number"then
av=UDim2.new(0,av,0,av)
end


local aw


if typeof(ar)=="table"then
local ax=ar
local ay=ax.Image or""
local az=ax.Gradient
local aA=ax.Quantity
local aB=ax.Rate
local b=ax.Title

local d
if typeof(az)=="ColorSequence"then
d=az
elseif typeof(az)=="Color3"then
d=ColorSequence.new(az)
else
d=ColorSequence.new(Color3.fromRGB(80,80,80))
end

local e=d.Keypoints[1].Value
local f=2


aw=ae.NewRoundFrame(8,"Squircle",{
Name="CustomMainIcon",
Size=av,
Parent=at,
ImageColor3=e,
ClipsDescendants=true,
LayoutOrder=-1,
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,0,0.5,0),
},{

af("ImageLabel",{
Image="rbxassetid://5554236805",
ScaleType=Enum.ScaleType.Slice,
SliceCenter=Rect.new(23,23,277,277),
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ImageColor3=Color3.new(0,0,0),
ImageTransparency=0.4,
ZIndex=2,
}),

ae.NewRoundFrame(8,"Squircle",{
Size=UDim2.new(1,-f*2,1,-f*2),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageColor3=Color3.new(1,1,1),
ClipsDescendants=true,
ZIndex=3,
},{

af("UIGradient",{
Color=d,
Rotation=45,
}),

af("ImageLabel",{
Image=ay,
Size=UDim2.new(0.65,0,0.65,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.45,0),
BackgroundTransparency=1,
ScaleType="Fit",
ZIndex=4,
}),


aA and af("TextLabel",{
Text=aA,
Size=UDim2.new(0.5,0,0,12),
Position=UDim2.new(0,4,0,2),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Left,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(ae.Font,Enum.FontWeight.Bold),
TextSize=8,
TextStrokeTransparency=0,
TextStrokeColor3=Color3.new(0,0,0),

ZIndex=5,
})or nil,


aB and af("TextLabel",{
Text=aB,
Size=UDim2.new(0.5,-4,0,12),
Position=UDim2.new(1,-4,0,2),
AnchorPoint=Vector2.new(1,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Right,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(ae.Font,Enum.FontWeight.Bold),
TextSize=11,
TextStrokeTransparency=0,
TextStrokeColor3=Color3.new(0,0,0),
TextWrapped=true,
ZIndex=5,
})or nil,


b and af("Frame",{
Size=UDim2.new(1,0,0,18),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.4,
BorderSizePixel=0,
ZIndex=6,
},{
af("TextLabel",{
Text=b,
Size=UDim2.new(1,-2,1,0),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=1,
TextXAlignment=Enum.TextXAlignment.Center,
TextColor3=Color3.new(1,1,1),
FontFace=Font.new(ae.Font,Enum.FontWeight.Bold),
TextSize=10,
TextWrapped=true,
ZIndex=7,
})
})or nil
})
})

else
aw=ae.Image(
ar,
ao.Title,
an.Window.NewElements and 12 or 6,
an.Window.Folder,
"DropdownIcon",
false
)

aw.Name="CustomMainIcon"
aw.Parent=at
aw.Size=av
aw.LayoutOrder=-1
aw.AnchorPoint=Vector2.new(0,0.5)
aw.Position=UDim2.new(0,0,0.5,0)
aw.BackgroundTransparency=1
end


local ax=at:FindFirstChild"TitleFrame"
if ax then
ax.Size=UDim2.new(1,-av.X.Offset,1,0)
end
end


function ao.SetValueImage(aq,ar)
if ao.UIElements.Dropdown then

local as=ao.UIElements.Dropdown:FindFirstChild"Frame"
local at=as and as:FindFirstChild"Frame"


if not at then
local au=ao.UIElements.Dropdown:FindFirstChild("TextLabel",true)
if au then
at=au.Parent
end
end

if not at then return end

local au=at:FindFirstChild"TextLabel"
local av=at:FindFirstChild"DynamicValueIcon"

if ar and ar~=""then
if not av then
av=af("ImageLabel",{
Name="DynamicValueIcon",
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
LayoutOrder=-1,
Parent=at
})
end

local aw=ae.Icon(ar)
if aw then
av.Image=aw[1]
av.ImageRectSize=aw[2].ImageRectSize
av.ImageRectOffset=aw[2].ImageRectPosition
else
av.Image=ar
av.ImageRectSize=Vector2.new(0,0)
av.ImageRectOffset=Vector2.new(0,0)
end

av.Visible=true

if au then
au.Size=UDim2.new(1,-29,1,0)
end
else
if av then
av.Visible=false
end
if au then
au.Size=UDim2.new(1,0,1,0)
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

function ao.Lock(aq,ar)
ao.Locked=true
ap=false
return ao.DropdownFrame:Lock(ar)
end
function ao.Unlock(aq)
ao.Locked=false
ap=true
return ao.DropdownFrame:Unlock()
end

function ao.Edit(aq,ar,as)
ao.DropdownMenu:Edit(ar,as)
end

function ao.EditDrop(aq,ar,as)
ao.DropdownMenu:EditDrop(ar,as)
end

if ao.Locked then
ao:Lock()
end



local aq=ao.Open

ao.Open=function()
if ao.Opened then

ao.Close()
else

aq()
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
local aq=false

for ar=1,#al do
local as=al:sub(ar,ar)

if ap then
if as=="\n"and not aq then
table.insert(am,an)
table.insert(am,as)
an=""

ap=false
elseif al:sub(ar-1,ar)=="]]"and aq then
an=an.."]"

table.insert(am,an)
an=""

ap=false
aq=false
else
an=an..as
end
elseif ao then
if as==ao and al:sub(ar-1,ar-1)~="\\"or as=="\n"then
an=an..as
ao=false
else
an=an..as
end
else
if al:sub(ar,ar+1)=="--"then
table.insert(am,an)
an="-"
ap=true
aq=al:sub(ar+2,ar+3)=="[["
elseif as=="\""or as=="\'"then
table.insert(am,an)
an=as
ao=as
elseif ak[as]then
table.insert(am,an)
table.insert(am,as)
an=""
elseif as:match"[%w_]"then
an=an..as
else
table.insert(am,an)
table.insert(am,as)
an=""
end
end
end

table.insert(am,an)

local ar={}

for as,at in ipairs(am)do
local au=getHighlight(am,as)

if au then
local av=string.format("<font color = \"#%s\">%s</font>",au:ToHex(),at:gsub("<","&lt;"):gsub(">","&gt;"))

table.insert(ar,av)
else
table.insert(ar,at)
end
end

return table.concat(ar)
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

local aq=af("TextLabel",{
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
aq.Font="Code"

local ar=af("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticCanvasSize="X",
ScrollingDirection="X",
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
},{
aq
})

local as=af("TextButton",{
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

ae.AddSignal(as.MouseEnter,function()
ah(as.Button,.05,{ImageTransparency=.95}):Play()
ah(as.Button.UIScale,.05,{Scale=.9}):Play()
end)
ae.AddSignal(as.InputEnded,function()
ah(as.Button,.08,{ImageTransparency=1}):Play()
ah(as.Button.UIScale,.08,{Scale=1}):Play()
end)

local at=ae.NewRoundFrame(ap.Radius,"Squircle",{



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
Size=UDim2.new(1,as and-20-(ap.Padding*2),0,0)
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
ar,
af("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
})
}),
as,
})

ap.CodeFrame=at

ae.AddSignal(aq:GetPropertyChangedSignal"TextBounds",function()
ar.Size=UDim2.new(1,0,0,(aq.TextBounds.Y/(ao or 1))+((ap.Padding+3)*2))
end)

function ap.Set(au)
aq.Text=aj.run(au)
end

function ap.Destroy()
at:Destroy()
ap=nil
end

ap.Set(ak)

ae.AddSignal(as.MouseButton1Click,function()
if an then
an()
local au=ae.Icon"check"
as.Button.ImageLabel.Image=au[1]
as.Button.ImageLabel.ImageRectSize=au[2].ImageRectSize
as.Button.ImageLabel.ImageRectOffset=au[2].ImageRectPosition

task.wait(1)
local av=ae.Icon"copy"
as.Button.ImageLabel.Image=av[1]
as.Button.ImageLabel.ImageRectSize=av[2].ImageRectSize
as.Button.ImageLabel.ImageRectOffset=av[2].ImageRectPosition
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
local aq=a.load'k'.New

local ar={
UICorner=9,

}

function ar.Colorpicker(as,at,au,av)
local aw={
__type="Colorpicker",
Title=at.Title,
Desc=at.Desc,
Default=at.Default,
Callback=at.Callback,
Transparency=at.Transparency,
UIElements=at.UIElements,

TextPadding=10,
}

function aw.SetHSVFromRGB(ax,ay)
local az,aA,aB=Color3.toHSV(ay)
aw.Hue=az
aw.Sat=aA
aw.Vib=aB
end

aw:SetHSVFromRGB(aw.Default)

local ax=a.load'l'.Init(au)
local ay=ax.Create()

aw.ColorpickerFrame=ay

ay.UIElements.Main.Size=UDim2.new(1,0,0,0)



local az,aA,aB=aw.Hue,aw.Sat,aw.Vib

aw.UIElements.Title=ae("TextLabel",{
Text=aw.Title,
TextSize=20,
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=ay.UIElements.Main
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,aw.TextPadding/2),
PaddingLeft=UDim.new(0,aw.TextPadding/2),
PaddingRight=UDim.new(0,aw.TextPadding/2),
PaddingBottom=UDim.new(0,aw.TextPadding/2),
})
})





local b=ae("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=HueDragHolder,
BackgroundColor3=aw.Default
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

aw.UIElements.SatVibMap=ae("ImageLabel",{
Size=UDim2.fromOffset(160,158),
Position=UDim2.fromOffset(0,40+aw.TextPadding),
Image="rbxassetid://4155801252",
BackgroundColor3=Color3.fromHSV(az,1,1),
BackgroundTransparency=0,
Parent=ay.UIElements.Main,
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

b,
})

aw.UIElements.Inputs=ae("Frame",{
AutomaticSize="XY",
Size=UDim2.new(0,0,0,0),
Position=UDim2.fromOffset(aw.Transparency and 240 or 210,40+aw.TextPadding),
BackgroundTransparency=1,
Parent=ay.UIElements.Main
},{
ae("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Vertical",
})
})





local d=ae("Frame",{
BackgroundColor3=aw.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=aw.Transparency,
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
Position=UDim2.fromOffset(85,208+aw.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ay.UIElements.Main,
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







d,
})

local e=ae("Frame",{
BackgroundColor3=aw.Default,
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
Position=UDim2.fromOffset(0,208+aw.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ay.UIElements.Main,
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
e,
})

local f={}

for g=0,1,0.1 do
table.insert(f,ColorSequenceKeypoint.new(g,Color3.fromHSV(g,1,1)))
end

local g=ae("UIGradient",{
Color=ColorSequence.new(f),
Rotation=90,
})

local h=ae("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
})

local j=ae("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=h,


BackgroundColor3=aw.Default
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

local l=ae("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(180,40+aw.TextPadding),
Parent=ay.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
g,
h,
})


function CreateNewInput(m,p)
local r=aq(m,nil,aw.UIElements.Inputs)

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
Parent=r.Frame,
Text=m,
})

ae("UIScale",{
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

local m=CreateNewInput("Hex","#"..aw.Default:ToHex())

local p=CreateNewInput("Red",ToRGB(aw.Default).R)
local r=CreateNewInput("Green",ToRGB(aw.Default).G)
local u=CreateNewInput("Blue",ToRGB(aw.Default).B)
local v
if aw.Transparency then
v=CreateNewInput("Alpha",((1-aw.Transparency)*100).."%")
end

local x=ae("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="Y",
Position=UDim2.new(0,0,0,254+aw.TextPadding),
BackgroundTransparency=1,
Parent=ay.UIElements.Main,
LayoutOrder=4,
},{
ae("UIListLayout",{
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
Callback=function()av(Color3.fromHSV(aw.Hue,aw.Sat,aw.Vib),aw.Transparency)end
}
}

for A,B in next,z do
local C=ap(B.Title,B.Icon,B.Callback,B.Variant,x,ay,false)
C.Size=UDim2.new(0.5,-3,0,40)
C.AutomaticSize="None"
end



local A,B,C
if aw.Transparency then
local F=ae("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.fromOffset(0,0),
BackgroundTransparency=1,
})

B=ae("ImageLabel",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
ThemeTag={
BackgroundColor3="Text",
},
Parent=F,

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

C=ae("Frame",{
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

A=ae("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(210,40+aw.TextPadding),
Parent=ay.UIElements.Main,
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
C,
F,
})
end

function aw.Round(F,G,H)
if H==0 then
return math.floor(G)
end
G=tostring(G)
return G:find"%."and tonumber(G:sub(1,G:find"%."+H))or G
end


function aw.Update(F,G,H)
if G then az,aA,aB=Color3.toHSV(G)else az,aA,aB=aw.Hue,aw.Sat,aw.Vib end

aw.UIElements.SatVibMap.BackgroundColor3=Color3.fromHSV(az,1,1)
b.Position=UDim2.new(aA,0,1-aB,0)
b.BackgroundColor3=Color3.fromHSV(az,aA,aB)
e.BackgroundColor3=Color3.fromHSV(az,aA,aB)
j.BackgroundColor3=Color3.fromHSV(az,1,1)
j.Position=UDim2.new(0.5,0,az,0)

m.Frame.Frame.TextBox.Text="#"..Color3.fromHSV(az,aA,aB):ToHex()
p.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(az,aA,aB)).R
r.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(az,aA,aB)).G
u.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(az,aA,aB)).B

if H or aw.Transparency then
e.BackgroundTransparency=aw.Transparency or H
C.BackgroundColor3=Color3.fromHSV(az,aA,aB)
B.BackgroundColor3=Color3.fromHSV(az,aA,aB)
B.BackgroundTransparency=aw.Transparency or H
B.Position=UDim2.new(0.5,0,1-aw.Transparency or H,0)
v.Frame.Frame.TextBox.Text=aw:Round((1-aw.Transparency or H)*100,0).."%"
end
end

aw:Update(aw.Default,aw.Transparency)




local function GetRGB()
local F=Color3.fromHSV(aw.Hue,aw.Sat,aw.Vib)
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
aw.Hue,aw.Sat,aw.Vib=Color3.toHSV(J)
aw:Update()
aw.Default=J
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
aw.Hue,aw.Sat,aw.Vib=Color3.toHSV(N)
aw:Update()
end
end)
end

updateColorFromInput(p,"R")
updateColorFromInput(r,"G")
updateColorFromInput(u,"B")

if aw.Transparency then
aa.AddSignal(v.Frame.Frame.TextBox.FocusLost,function(F)
if F then
local G=v.Frame.Frame.TextBox
local H=clamp(G.Text,0,100)
G.Text=tostring(H)

aw.Transparency=1-H*0.01
aw:Update(nil,aw.Transparency)
end
end)
end



local F=aw.UIElements.SatVibMap
aa.AddSignal(F.InputBegan,function(G)
if G.UserInputType==Enum.UserInputType.MouseButton1 or G.UserInputType==Enum.UserInputType.Touch then
while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local H=F.AbsolutePosition.X
local J=H+F.AbsoluteSize.X
local L=math.clamp(ao.X,H,J)

local M=F.AbsolutePosition.Y
local N=M+F.AbsoluteSize.Y
local O=math.clamp(ao.Y,M,N)

aw.Sat=(L-H)/(J-H)
aw.Vib=1-((O-M)/(N-M))
aw:Update()

am:Wait()
end
end
end)

aa.AddSignal(l.InputBegan,function(G)
if G.UserInputType==Enum.UserInputType.MouseButton1 or G.UserInputType==Enum.UserInputType.Touch then
while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local H=l.AbsolutePosition.Y
local J=H+l.AbsoluteSize.Y
local L=math.clamp(ao.Y,H,J)

aw.Hue=((L-H)/(J-H))
aw:Update()

am:Wait()
end
end
end)

if aw.Transparency then
aa.AddSignal(A.InputBegan,function(G)
if G.UserInputType==Enum.UserInputType.MouseButton1 or G.UserInputType==Enum.UserInputType.Touch then
while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local H=A.AbsolutePosition.Y
local J=H+A.AbsoluteSize.Y
local L=math.clamp(ao.Y,H,J)

aw.Transparency=1-((L-H)/(J-H))
aw:Update()

am:Wait()
end
end
end)
end

return aw
end

function ar.New(as,at)
local au={
__type="Colorpicker",
Title=at.Title or"Colorpicker",
Desc=at.Desc or nil,
Locked=at.Locked or false,
Default=at.Default or Color3.new(1,1,1),
Callback=at.Callback or function()end,

UIScale=at.UIScale,
Transparency=at.Transparency,
UIElements={}
}

local av=true



au.ColorpickerFrame=a.load'z'{
Title=au.Title,
Desc=au.Desc,
TitleGradient=at.TitleGradient,
DescGradient=at.DescGradient,
Parent=at.Parent,
TextOffset=40,
Hover=false,
Tab=at.Tab,
Index=at.Index,
Window=at.Window,
ElementTable=au,
ParentConfig=at,
}

au.UIElements.Colorpicker=aa.NewRoundFrame(ar.UICorner,"Squircle",{
ImageTransparency=0,
Active=true,
ImageColor3=au.Default,
Parent=au.ColorpickerFrame.UIElements.Main,
Size=UDim2.new(0,26,0,26),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
ZIndex=2
},nil,true)


function au.Lock(aw)
au.Locked=true
av=false
return au.ColorpickerFrame:Lock()
end
function au.Unlock(aw)
au.Locked=false
av=true
return au.ColorpickerFrame:Unlock()
end

if au.Locked then
au:Lock()
end


function au.Update(aw,ax,ay)
au.UIElements.Colorpicker.ImageTransparency=ay or 0
au.UIElements.Colorpicker.ImageColor3=ax
au.Default=ax
if ay then
au.Transparency=ay
end
end

function au.Set(aw,ax,ay)
return au:Update(ax,ay)
end

aa.AddSignal(au.UIElements.Colorpicker.MouseButton1Click,function()
if av then
ar:Colorpicker(au,at.Window,function(aw,ax)
au:Update(aw,ax)
au.Default=aw
au.Transparency=ax
aa.SafeCallback(au.Callback,aw,ax)
end).ColorpickerFrame:Open()
end
end)

return au.__type,au
end

return ar end function a.P()
local aa=a.load'b'
local ae=aa.New
local af=aa.Tween

local ah={}




local function IconCacheName(aj,ak)
local al=aj
if type(aj)=="table"then
al=aj.url or aj.gif or aj.mp4 or aj.webm or aj.file or"SectionIcon"
end
return tostring(al)..":"..tostring(ak)
end

function ah.New(aj,ak)
local al={
__type="Section",
Title=ak.Title or"Section",
Icon=ak.Icon or ak.Image,
TextXAlignment=ak.TextXAlignment or"Left",
TextSize=ak.TextSize or 19,
Box=ak.Box or false,
FontWeight=ak.FontWeight or Enum.FontWeight.SemiBold,
TextTransparency=ak.TextTransparency or 0.05,
Opened=ak.Opened or false,
UIElements={},

HeaderSize=ak.HeaderSize or 42,
Padding=10,


IconSize=ak.IconSize or 20,
IconThemed=ak.IconThemed,
IconTransparency=ak.IconTransparency or 0,
IconScaleType=ak.IconScaleType or ak.ScaleType,
IconKeepAspect=ak.IconKeepAspect,


HeaderPadding=ak.HeaderPadding or 8,

Elements={},

Expandable=false,
}

local am=ak.ChevronSize or 20




al.InlineIcon=ak.InlineIcon~=false

local function InlineContext(an)
return{
Icon=al.Icon,
IconSize=al.IconSize,
IconThemed=al.IconThemed,
IconTransparency=al.IconTransparency,
IconScaleType=al.IconScaleType,
IconKeepAspect=al.IconKeepAspect,
Folder=ak.Window and ak.Window.Folder,
ImageKind=al.__type,
ThemeTagName="Text",
CachePrefix="SectionTitle",
Index=an,
}
end

local function HasInlineTitle()
return al.InlineIcon and aa.HasInlineIcons(al.Title)
end






local an=al.HeaderSize

local function FitHeaderSize()
local ao=al.IconSize
if HasInlineTitle()then
ao=aa.MaxInlineIconSize(al.Title,InlineContext(),ao)
end

al.HeaderSize=math.max(an,ao+12)
end

FitHeaderSize()

local ao
local ap
local aq
local ar
local as





local function RefreshHeader()
local at=al.HeaderSize
FitHeaderSize()

if as then as()end
if ar then ar()end

if al.HeaderSize==at or not ao then return end

if ao.Top.AutomaticSize==Enum.AutomaticSize.None then
ao.Top.Size=UDim2.new(1,0,0,al.HeaderSize)
end
ao.Content.Position=UDim2.new(0,0,0,al.HeaderSize)

if ao.AutomaticSize==Enum.AutomaticSize.None then
if al.Opened then
al:Open()
else
ao.Size=UDim2.new(1,0,0,al.HeaderSize)
end
end
end

local function CreateIcon(at)
local au=aa.Image(
at,
IconCacheName(at,al.Title),
0,
ak.Window and ak.Window.Folder,
al.__type,
true,
al.IconThemed,
nil,
{

ScaleType=al.IconScaleType,
KeepAspect=al.IconKeepAspect,
Size=UDim2.fromOffset(al.IconSize,al.IconSize),
}
)
if not au then return nil end

au.Name="Icon"
au.LayoutOrder=1
au.Size=UDim2.new(0,al.IconSize,0,al.IconSize)

local av=au:FindFirstChildOfClass"ImageLabel"
if av then
av.ImageTransparency=al.IconTransparency
end

return au,av
end

function al.SetIcon(at,au)
al.Icon=au or nil

if ap then
ap:Destroy()
ap,aq=nil,nil
end

if au then
ap,aq=CreateIcon(au)


if ap and ao and ao:FindFirstChild"Top"then
ap.Parent=ao.Top
end
end

al.UIElements.Icon=ap


RefreshHeader()

return al
end

function al.SetIconSize(at,au)
al.IconSize=au or al.IconSize
if ap then
ap.Size=UDim2.new(0,al.IconSize,0,al.IconSize)
end
RefreshHeader()
return al
end

function al.GetIcon(at)
return al.Icon
end

local at=ae("Frame",{
Name="Chevron",
Size=UDim2.new(0,am,0,am),
BackgroundTransparency=1,
LayoutOrder=3,
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

local au=ae("TextLabel",{
Name="Title",
BackgroundTransparency=1,
TextXAlignment=al.TextXAlignment,
AutomaticSize="Y",
LayoutOrder=2,
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



local av=ae("UIListLayout",{
FillDirection="Horizontal",
SortOrder="LayoutOrder",
Padding=UDim.new(0,math.max(2,math.floor(al.HeaderPadding/2))),
VerticalAlignment="Center",
HorizontalAlignment=al.TextXAlignment=="Right"and"Right"
or(al.TextXAlignment=="Center"and"Center"or"Left"),
})

aa.TrySetWraps(av,true)

local aw=ae("Frame",{
Name="TitleRich",
BackgroundTransparency=1,
LayoutOrder=2,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Visible=false,
},{
av,
})

local function CreateTitleTextPart(ax,ay)
return ae("TextLabel",{
Name="TitlePart",
BackgroundTransparency=1,
Text=ax,
TextXAlignment=al.TextXAlignment,
TextSize=al.TextSize,
TextTransparency=al.TextTransparency,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(aa.Font,al.FontWeight),
LayoutOrder=ay,
Size=UDim2.new(0,0,0,0),
AutomaticSize="XY",
TextWrapped=false,
})
end

as=function()
if not HasInlineTitle()then

au.Text=al.Title
au.Visible=true
aw.Visible=false
for ax,ay in ipairs(aw:GetChildren())do
if ay:IsA"GuiObject"then ay:Destroy()end
end
return
end

local ax=aa.ParseInlineText(al.Title,InlineContext())




local ay=0
local az={}
for aA,aB in ipairs(ax)do
if aB.Type=="Icon"then
ay=ay+1
else
table.insert(az,aB.Content)
end
end
if ay==0 then
au.Text=table.concat(az)
au.Visible=true
aw.Visible=false
return
end

for aA,aB in ipairs(aw:GetChildren())do
if aB:IsA"GuiObject"then aB:Destroy()end
end



for aA,aB in ipairs(ax)do
local b
if aB.Type=="Text"then
b=CreateTitleTextPart(aB.Content,aA)
else
b=aa.InlineIconFrame(aB,InlineContext(aA))
if b then b.LayoutOrder=aA end
end
if b then b.Parent=aw end
end

au.Visible=false
aw.Visible=true
end


ar=function()
local ax=0
if ap then
ax=ax-(al.IconSize+al.HeaderPadding)
end
if at.Visible then
ax=ax-(am+al.HeaderPadding)
end
au.Size=UDim2.new(1,ax,0,0)
aw.Size=UDim2.new(1,ax,0,0)
end


ao=aa.NewRoundFrame(ak.Window.ElementConfig.UICorner,"Squircle",{
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
ap,
au,
aw,
ae("UIListLayout",{
Padding=UDim.new(0,al.HeaderPadding),
SortOrder="LayoutOrder",
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
at,
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

al.ElementFrame=ao

al.UIElements.Main=ao
al.UIElements.Top=ao.Top
al.UIElements.Content=ao.Content
al.UIElements.Title=au
al.UIElements.TitleRich=aw
al.UIElements.Chevron=at
al.UIElements.Icon=ap







local ax=ak.ElementsModule

ax.Load(al,ao.Content,ax.Elements,ak.Window,ak.ANUI,function()
if not al.Expandable then
al.Expandable=true
at.Visible=true
ar()
end
end,ax,ak.UIScale,ak.Tab)


as()
ar()

function al.SetTitle(ay,az)
al.Title=az

RefreshHeader()
return al
end

function al.Destroy(ay)
for az,aA in next,al.Elements do
aA:Destroy()
end








ao:Destroy()
end

function al.Open(ay)
if al.Expandable then
al.Opened=true
af(ao,0.33,{
Size=UDim2.new(1,0,0,al.HeaderSize+(ao.Content.AbsoluteSize.Y/ak.UIScale))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

af(at.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function al.Close(ay)
if al.Expandable then
al.Opened=false
af(ao,0.26,{
Size=UDim2.new(1,0,0,al.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
af(at.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

aa.AddSignal(ao.Top.MouseButton1Click,function()
if al.Expandable then
if al.Opened then
al:Close()
else
al:Open()
end
end
end)

aa.AddSignal(ao.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if al.Opened then
al:Open()
end
end)

task.spawn(function()
task.wait(0.02)
if al.Expandable then








ao.Size=UDim2.new(1,0,0,al.HeaderSize)
ao.AutomaticSize="None"
ao.Top.Size=UDim2.new(1,0,0,al.HeaderSize)
ao.Top.AutomaticSize="None"
ao.Content.Visible=true
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
local aj,ak=ah:match"([%d%.]+)%s*[:xX]%s*([%d%.]+)"
if aj and ak and tonumber(ak)~=0 then
return tonumber(aj)/tonumber(ak)
end
elseif type(ah)=="number"then
return ah
end
return nil
end


local function IsNativeAspect(ah)
if type(ah)~="string"then return false end
ah=string.lower(ah)
return ah=="native"or ah=="original"or ah=="auto"
end

function af.New(ah,aj)
local ak={
__type="Image",
Image=aj.Image or"",
AspectRatio=aj.AspectRatio or"16:9",
Radius=aj.Radius or aj.Window.ElementConfig.UICorner,


ScaleType=aj.ScaleType or(aj.Crop and"Crop")or"Fit",

Native=aj.Native or aj.KeepAspect or IsNativeAspect(aj.AspectRatio)or false,
NativeSize=aj.NativeSize,
Height=aj.Height,
Size=aj.Size,
}

local al
local am




local an=aa.ToVector2(ak.NativeSize)
local ao
if an and an.Y>0 then
ao=an.X/an.Y
else
ao=ParseAspectRatio(ak.AspectRatio)or(ak.Native and 1.7777777777777777 or nil)
end

local function ApplyAspectRatio(ap)
if not ap or ap<=0 then return end
ao=ap
if am then
am.AspectRatio=ap
elseif al then
am=ae("UIAspectRatioConstraint",{
Parent=al,
AspectRatio=ap,
AspectType="ScaleWithParentSize",
DominantAxis="Width"
})
end
end

al=aa.Image(
ak.Image,
(type(ak.Image)=="table"and(ak.Image.url or"Image"))
or tostring(ak.Image),
ak.Radius,
aj.Window.Folder,
"Image",
false,
nil,
nil,
{
ScaleType=ak.ScaleType,
NativeSize=ak.NativeSize,


OnNativeSize=ak.Native and function(ap)
if ap.Y>0 then
ApplyAspectRatio(ap.X/ap.Y)
end
end or nil,
}
)
al.Parent=aj.Parent
al.BackgroundTransparency=1


if ak.Size then
al.Size=ak.Size
elseif ak.Height then
al.Size=UDim2.new(1,0,0,ak.Height)
else
al.Size=UDim2.new(1,0,0,0)
end


if ao and not ak.Size and not ak.Height then
ApplyAspectRatio(ao)
end

function ak.SetSize(ap,aq)
if typeof(aq)=="UDim2"then
al.Size=aq
elseif type(aq)=="number"then
al.Size=UDim2.new(1,0,0,aq)
end
return ak
end

function ak.SetScaleType(ap,aq)
ak.ScaleType=aq
if al.ImageLabel then
al.ImageLabel.ScaleType=aq
end
return ak
end

function ak.SetAspectRatio(ap,aq)
local ar=(type(ak.Image)=="table"and ak.Image.url)or ak.Image
if IsNativeAspect(aq)then
local as=aa.GetImageNativeSize(ar)
if as and as.Y>0 then
ApplyAspectRatio(as.X/as.Y)
else
aa.RequestImageNativeSize(ar,function(at)
if at.Y>0 then ApplyAspectRatio(at.X/at.Y)end
end)
end
else
ApplyAspectRatio(ParseAspectRatio(aq))
end
return ak
end

function ak.GetNativeSize(ap)
local aq=(type(ak.Image)=="table"and ak.Image.url)or ak.Image
return aa.GetImageNativeSize(aq)
end

ak.ElementFrame=al
ak.UIElements={Main=al}

function ak.Destroy(ap)
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

local aq={}
local ar=0

for as,at in next,ao do
if at.__type=="Space"then
ar=ar+(at.ElementFrame.Size.X.Offset or 6)
elseif at.__type=="Divider"then
ar=ar+(at.ElementFrame.Size.X.Offset or 1)
else
table.insert(aq,at)
end
end

local as=#aq
if as==0 then return end

local at=al.AbsoluteSize.X
local au
if at and at>0 then
local av=ap*(as-1)
local aw=math.max(at-av-ar,0)
au=(aw/at)/as
else
au=1/as
end

for av,aw in next,aq do
if aw.ElementFrame then
aw.ElementFrame.Size=UDim2.new(au,0,1,0)
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





local function ResolveOption(aj)
local ak
if type(aj)=="table"then
local al=aj.Title or aj.Name or aj.Value or aj[1]
ak={
Title=tostring(al or""),
Icon=aj.Icon or aj.Image,
IconSize=aj.IconSize,
ScaleType=aj.ScaleType,
KeepAspect=aj.KeepAspect~=nil and aj.KeepAspect or aj.Native,
NativeSize=aj.NativeSize,
Tint=aj.Tint,
ImageRectOffset=aj.ImageRectOffset,
ImageRectSize=aj.ImageRectSize,
Desc=aj.Desc,
Raw=aj,
}
else
ak={Title=tostring(aj),Raw=aj}
end

ak.Key=ak.Title
if aa.HasInlineIcons(ak.Title)then
local al=aa.StripInlineIcons(ak.Title,{Icon=ak.Icon})
if al~=""then
ak.Key=al
end
end

return ak
end


local function ResolveElementFrame(aj)
if typeof(aj)=="Instance"then
return aj
end
if type(aj)~="table"then
return nil
end

local ak=rawget(aj,"ElementFrame")
if typeof(ak)=="Instance"then
return ak
end

local al=rawget(aj,"UIElements")
if type(al)=="table"and typeof(al.Main)=="Instance"then
return al.Main
end

for am,an in ipairs{"GroupFrame","MainFrame","Main","Frame","Container"}do
local ao=rawget(aj,an)
if typeof(ao)=="Instance"then
return ao
end
end

return nil
end

function ah.New(aj,ak)
local al=ak.Window
local am=ak.Tab

local an={
__type="Category",
Title=ak.Title,
Desc=ak.Desc,
Options={},
Default=ak.Default,
Value=nil,
Callback=ak.Callback or ak.OnChanged or function()end,
Parent=ak.Parent,
UIElements={},


Height=ak.Height or 45,
ButtonHeight=ak.ButtonHeight or 32,
IconSize=ak.IconSize or 18,
TextSize=ak.TextSize or 14,
Radius=ak.Radius or 8,
Gap=ak.Gap or ak.Padding or 8,
SidePadding=ak.SidePadding or 12,
ScrollSpeed=ak.ScrollSpeed or 35,
ActiveTag=ak.ActiveTag or"Toggle",
InactiveTag=ak.InactiveTag or"Button",
TextTag=ak.TextTag or"Text",
Transparency=ak.Transparency or 0.5,


IconScaleType=ak.IconScaleType or ak.ScaleType,
IconKeepAspect=ak.IconKeepAspect~=false,
IconAutoWidth=ak.IconAutoWidth~=false,
TintIcon=ak.TintIcon,


ContentPadding=ak.ContentPadding or 5,
AlignWithContent=ak.AlignWithContent~=false,


AutoCapture=ak.AutoCapture~=false,
Registry={},
Owners={},
}


local ao=am and type(am.ReserveHeader)=="function"
and am.UIElements and ak.Parent==am.UIElements.ContainerFrame
local ap=ak.Sticky
if ap==nil then ap=ao end
ap=(ap and ao)and true or false


local aq=ae("Frame",{
Name="Category",
Size=UDim2.new(1,0,0,an.Height),
BackgroundTransparency=1,
})

local ar
if ap then

ar=am:ReserveHeader(an.Height,{
Name="CategoryHeader",
ContentPadding=an.ContentPadding,
AlignWithContent=an.AlignWithContent,
ZIndex=ak.ZIndex or 6,
})
aq.Size=UDim2.new(1,0,1,0)
aq.Parent=ar.Frame
else
aq.Parent=ak.Parent
end


local as=ae("ScrollingFrame",{
Name="Options",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScrollingDirection=Enum.ScrollingDirection.X,
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize=Enum.AutomaticSize.X,
Active=true,
Parent=aq,
},{
ae("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
SortOrder=Enum.SortOrder.LayoutOrder,
Padding=UDim.new(0,an.Gap),
VerticalAlignment=Enum.VerticalAlignment.Center,
}),
ae("UIPadding",{
PaddingLeft=UDim.new(0,2),
PaddingRight=UDim.new(0,2),
})
})

an.UIElements.Main=aq
an.UIElements.Container=as
an.UIElements.Header=ar and ar.Frame or nil
an.Header=ar
an.Sticky=ap
an.ElementFrame=aq


local at=false
local au=Vector2.new()
local av=Vector2.new()

aa.AddSignal(as.InputBegan,function(aw)
if aw.UserInputType==Enum.UserInputType.MouseButton1 then
at=true
au=aw.Position
av=as.CanvasPosition
end
end)

aa.AddSignal(as.InputEnded,function(aw)
if aw.UserInputType==Enum.UserInputType.MouseButton1 then
at=false
end
end)

aa.AddSignal(as.InputChanged,function(aw)
if aw.UserInputType==Enum.UserInputType.MouseMovement then
if at then
local ax=aw.Position-au
as.CanvasPosition=Vector2.new(av.X-ax.X,0)
end
elseif aw.UserInputType==Enum.UserInputType.MouseWheel then

as.CanvasPosition=as.CanvasPosition
+Vector2.new(aw.Position.Z*-an.ScrollSpeed,0)
end
end)




local aw={}



local function NormalizeName(ax)
if ax==nil then return nil end
ax=tostring(ax)
if aw[ax]or not aa.HasInlineIcons(ax)then
return ax
end
local ay=aa.StripInlineIcons(ax)
if ay~=""and aw[ay]then
return ay
end
return ax
end

local function UpdateVisuals(ax)
local ay=aa.Theme

for az,aA in pairs(aw)do
local aB=(az==ax)
local b=aB and an.ActiveTag or an.InactiveTag
local d=aa.GetThemeProperty(b,ay)
local e=aa.GetThemeProperty(an.TextTag,ay)
local f=aB and 0 or an.Transparency


local g=aa.Objects[aA.Background]
if g and g.Properties then
g.Properties.ImageColor3=b
end

if typeof(d)=="Color3"then
af(aA.Background,0.2,{ImageColor3=d}):Play()
end


for h,j in ipairs(aA.TitleParts or{})do
if j.Parent then
af(j,0.2,{
TextTransparency=f,
TextColor3=typeof(e)=="Color3"and e or j.TextColor3,
}):Play()
end
end


for h,j in ipairs(aA.TitleIcons or{})do
if j.Label and j.Label.Parent then
local l={ImageTransparency=f}
if j.Tint and typeof(e)=="Color3"then
l.ImageColor3=e
end
af(j.Label,0.2,l):Play()
end
end

if aA.IconLabel and aA.IconLabel.Parent then
local h={ImageTransparency=f}


if aA.Tint and typeof(e)=="Color3"then
h.ImageColor3=e
end
af(aA.IconLabel,0.2,h):Play()
end
end
end

local function CreateButton(ax,ay)
local az=ResolveOption(ax)
if az.Title==""then return nil end

local aA=ae("TextButton",{
Name="Option",
AutoButtonColor=false,
Size=UDim2.new(0,0,0,an.ButtonHeight),
AutomaticSize=Enum.AutomaticSize.X,
BackgroundTransparency=1,
Text="",
Parent=as,
LayoutOrder=ay or(#an.Options+1),
})

local aB=aa.NewRoundFrame(an.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={ImageColor3=an.InactiveTag},
Name="Background",
Parent=aA,
},{
ae("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
VerticalAlignment=Enum.VerticalAlignment.Center,
Padding=UDim.new(0,6),
HorizontalAlignment=Enum.HorizontalAlignment.Center,
}),
ae("UIPadding",{
PaddingLeft=UDim.new(0,an.SidePadding),
PaddingRight=UDim.new(0,an.SidePadding),
})
})

local b,d
local e=az.Tint
if e==nil then e=an.TintIcon end

if az.Icon then
local f=az.IconSize or an.IconSize
local g=az.KeepAspect
if g==nil then g=an.IconKeepAspect end



if e==nil then
e=aa.Icon(az.Icon)~=nil
end

b=aa.Image(
az.Icon,
"CategoryIcon-"..az.Key,
0,
al and al.Folder,
"Icon",
false,
nil,
nil,
{

ScaleType=az.ScaleType or an.IconScaleType,
KeepAspect=g,
NativeSize=az.NativeSize,
ImageRectOffset=az.ImageRectOffset,
ImageRectSize=az.ImageRectSize,
Size=UDim2.fromOffset(f,f),
OnNativeSize=an.IconAutoWidth and function(h,j)


if not j or not j.Parent or h.Y<=0 then return end
local l=h.X/h.Y
j.Size=UDim2.fromOffset(math.max(1,math.floor(f*l+0.5)),f)
end or nil,
}
)
b.Name="Icon"
b.BackgroundTransparency=1


b.LayoutOrder=-1

d=b:FindFirstChildOfClass"ImageLabel"
if d then
d.ImageTransparency=an.Transparency
end
b.Parent=aB
end

local function CreateTitleLabel(f,g)
return ae("TextLabel",{
Name="Title",
Text=f,
FontFace=Font.new(aa.Font,Enum.FontWeight.Bold),
TextSize=an.TextSize,
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.XY,
ThemeTag={TextColor3=an.TextTag},
TextTransparency=an.Transparency,
LayoutOrder=g,
Parent=aB,
})
end

local f={}
local g={}
local h


local j=aa.HasInlineIcons(az.Title)
and aa.ParseInlineText(az.Title,{
Icon=az.Icon,
IconSize=az.IconSize or an.IconSize,
})
or nil

local l=false
for m,p in ipairs(j or{})do
if p.Type=="Icon"then
l=true
break
end
end

if l then
for m,p in ipairs(j)do
if p.Type=="Text"then
local r=CreateTitleLabel(p.Content,m)
table.insert(f,r)
h=h or r
else
local r,u=aa.InlineIconFrame(p,{
Icon=az.Icon,
IconSize=az.IconSize or an.IconSize,
IconScaleType=az.ScaleType or an.IconScaleType,
IconKeepAspect=az.KeepAspect,
IconTransparency=an.Transparency,
Folder=al and al.Folder,
ImageKind="Icon",
ThemeTagName=an.TextTag,
CachePrefix="CategoryInline",
Index=m,
})
if r then
r.LayoutOrder=m
r.Parent=aB
table.insert(g,{
Frame=r,
Label=u,

Tint=(p.Options and p.Options.Color)==nil
and aa.Icon(p.Content)~=nil,
})
end
end
end
else
h=CreateTitleLabel(az.Title)
table.insert(f,h)
end

aw[az.Key]={
Frame=aA,
Background=aB,
Title=h,
TitleParts=f,
TitleIcons=g,
Icon=b,
IconLabel=d,
Tint=e,
Option=az,
}

aa.AddSignal(aA.MouseButton1Click,function()
an:Select(az.Key)
end)

return az
end





local function ApplyVisibility(ax)
for ay,az in pairs(an.Registry)do
local aA=(ay==ax)
for aB,b in ipairs(az)do
local d=ResolveElementFrame(b)
if d then
d.Visible=aA
end
end
end
end

function an.Select(ax,ay,az)
if ay==nil then return an end
ay=NormalizeName(ay)

an.Value=ay
an.Selected=ay

UpdateVisuals(ay)
ApplyVisibility(ay)

if not az and an.Callback then
local aA,aB=pcall(an.Callback,ay)
if not aA then
warn("[ ANUI.Category ] Callback error: "..tostring(aB))
end
end

return an
end
an.SetValue=an.Select

function an.GetSelected(ax)
return an.Value
end

function an.SetCallback(ax,ay)
an.Callback=ay or function()end
return an
end




function an.Add(ax,ay,...)
if ay==nil then return nil end
ay=NormalizeName(ay)

local az=an.Registry[ay]
if not az then
az={}
an.Registry[ay]=az
end

local aA
for aB=1,select("#",...)do
local b=select(aB,...)
if type(b)=="table"and rawget(b,"__type")==nil and#b>0 then
for d,e in ipairs(b)do
local f=an:Add(ay,e)
aA=aA or f
end
elseif b~=nil then
local d=an.Owners[b]
if d~=ay then
if d then
an:Remove(b)
end
table.insert(az,b)
an.Owners[b]=ay
end
local e=ResolveElementFrame(b)
if e then
e.Visible=(ay==an.Value)
end
aA=aA or b
end
end

return aA
end

function an.Remove(ax,ay)
local az=ay and an.Owners[ay]
if not az then return false end

local aA=an.Registry[az]
if aA then
for aB,b in ipairs(aA)do
if b==ay then
table.remove(aA,aB)
break
end
end
end
an.Owners[ay]=nil
return true
end

function an.GetElements(ax,ay)
if ay==nil then return an.Registry end
return an.Registry[NormalizeName(ay)]or{}
end

function an.Refresh(ax)
ApplyVisibility(an.Value)
return an
end





function an.Capture(ax,ay)
an.CaptureTarget=ay and NormalizeName(ay)or nil
return an
end

function an.StopCapture(ax)
an.CaptureTarget=nil
return an
end


function an.With(ax,ay,az)
local aA=an.CaptureTarget
an:Capture(ay)

local aB,b
if type(az)=="function"then
aB,b=pcall(az,function(...)
return an:Add(ay,...)
end)
end

an.CaptureTarget=aA
if aB==false then
warn("[ ANUI.Category ] With('"..tostring(ay).."') error: "..tostring(b))
end
return an
end

function an.AddOption(ax,ay,az)
local aA=CreateButton(ay,az)
if aA then
table.insert(an.Options,aA.Raw)
if an.Value==nil then
an:Select(aA.Key,true)
end
end
return an
end

function an.RemoveOption(ax,ay)
ay=NormalizeName(ay)
local az=aw[ay]
if az then
az.Frame:Destroy()
aw[ay]=nil
end
for aA,aB in ipairs(an.Options)do
local b=ResolveOption(aB)
if b.Key==ay then
table.remove(an.Options,aA)
break
end
end
an.Registry[ay]=nil
return an
end

function an.SetOptions(ax,ay,az)
for aA,aB in pairs(aw)do
aB.Frame:Destroy()
aw[aA]=nil
end
an.Options={}
an.Value=nil

for aA,aB in ipairs(ay or{})do
local b=CreateButton(aB,aA)
if b then
table.insert(an.Options,aB)
end
end

local aA=az or an.Default
if aA and aw[NormalizeName(aA)]then
an:Select(aA,true)
elseif an.Options[1]then
an:Select(ResolveOption(an.Options[1]).Key,true)
end

return an
end

function an.GetOptions(ax)
return an.Options
end

function an.SetHeight(ax,ay)
an.Height=ay
if ar then
ar:SetHeight(ay)
else
aq.Size=UDim2.new(1,0,0,ay)
end
return an
end

function an.Destroy(ax)
an:StopCapture()
an.Registry={}
an.Owners={}


if am and an.CaptureHook and rawget(am,"__OnElementCreated")==an.CaptureHook then
am.__OnElementCreated=an.PreviousHook
end

if ar then
ar:Release()
end
aq:Destroy()
end




for ax,ay in ipairs(ak.Options or{})do
local az=CreateButton(ay,ax)
if az then
table.insert(an.Options,ay)
end
end


if am and an.AutoCapture then
local ax=rawget(am,"__OnElementCreated")
local ay
ay=function(az,aA,aB)
if ax then
pcall(ax,az,aA,aB)
end
if an.CaptureTarget
and az~=an
and aA and aA.Parent==ak.Parent then
an:Add(an.CaptureTarget,az)
end
end

an.PreviousHook=ax
an.CaptureHook=ay
am.__OnElementCreated=ay
end

local ax=an.Default
if ax==nil and ak.Options and ak.Options[1]then
ax=ResolveOption(ak.Options[1]).Key
end
if ax~=nil then

an:Select(ax,true)
end

return an.__type,an
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
aa[ao]=function(aq,ar)
ar=ar or{}
ar.Tab=an or aa
ar.ParentType=aa.__type
ar.ParentTable=aa
ar.Index=#aa.Elements+1
ar.GlobalIndex=#ah.AllElements+1
ar.Parent=ae
ar.Window=ah
ar.ANUI=aj
ar.UIScale=am
ar.ElementsModule=al local

as, at=ap:New(ar)

if ar.Flag and typeof(ar.Flag)=="string"then
if ah.CurrentConfig then
ah.CurrentConfig:Register(ar.Flag,at)

if ah.PendingConfigData and ah.PendingConfigData[ar.Flag]then
local au=ah.PendingConfigData[ar.Flag]

local av=ah.ConfigManager
if av.Parser[au.__type]then
task.defer(function()
local aw,ax=pcall(function()
av.Parser[au.__type].Load(at,au)
end)

if aw then
ah.PendingConfigData[ar.Flag]=nil
else
warn("[ ANUI ] Failed to apply pending config for '"..ar.Flag.."': "..tostring(ax))
end
end)
end
end
else
ah.PendingFlags=ah.PendingFlags or{}
ah.PendingFlags[ar.Flag]=at
end
end

local au
for av,aw in pairs(at)do
if typeof(aw)=="table"and av:match"Frame$"then
au=aw
break
end
end

if au then
at.ElementFrame=au.UIElements.Main
function at.SetTitle(av,aw)
au:SetTitle(aw)
end
function at.SetDesc(av,aw)
au:SetDesc(aw)
end
function at.SetTitleGradient(av,aw)
au:SetTitleGradient(aw)
end
function at.SetDescGradient(av,aw)
au:SetDescGradient(aw)
end
function at.SetImage(av,aw,ax)
au:SetImage(aw,ax)
end
function at.SetIcon(av,aw,ax)
au:SetImage(aw,ax)
end
function at.Highlight(av)
au:Highlight()
end
function at.Destroy(av)
au:Destroy()

table.remove(ah.AllElements,ar.GlobalIndex)
table.remove(aa.Elements,ar.Index)
table.remove(an.Elements,ar.Index)
aa:UpdateAllElementShapes(aa)
end
end



ah.AllElements[ar.Index]=at
aa.Elements[ar.Index]=at
if an then an.Elements[ar.Index]=at end

if ah.NewElements then
aa:UpdateAllElementShapes(aa)
end

if ak then
ak(at,aa.Elements)
end




local av=rawget(aa,"__OnElementCreated")
if type(av)=="function"then
local aw,ax=pcall(av,at,ar,aa)
if not aw then
warn("[ ANUI ] __OnElementCreated error: "..tostring(ax))
end
end

return at
end
end
function aa.UpdateAllElementShapes(ao,ap)
for aq,ar in next,ap.Elements do
local as
for at,au in pairs(ar)do
if typeof(au)=="table"and at:match"Frame$"then
as=au
break
end
end

if as then

as.Index=aq
if as.UpdateShape then

as.UpdateShape(ap)
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

function am.Init(an,ao,ap,aq)
Window=an
ANUI=ao
am.ToolTipParent=ap
am.TabHighlight=aq
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

local aq=ap.Profile and ap.SidebarProfile
local ar=ap.Profile


local as=ar and(ap.Profile.Sticky~=false)

if aq then
ap.Locked=true
end

am.TabCount=am.TabCount+1

local at=am.TabCount
ap.Index=at


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

local au=0
local av
local aw


if ap.Icon and not aq then
av=af.Image(ap.Icon,ap.Icon..":"..ap.Title,0,Window.Folder,ap.__type,true,ap.IconThemed,"TabIcon")
av.Size=UDim2.new(0,16,0,16)
av.Parent=ap.UIElements.Main.Frame
av.ImageLabel.ImageTransparency=not ap.Locked and 0 or.7
ap.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,-30,0,0)
au=-30
ap.UIElements.Icon=av

aw=af.Image(ap.Icon,ap.Icon..":"..ap.Title,0,Window.Folder,ap.__type,true,ap.IconThemed)
aw.Size=UDim2.new(0,16,0,16)
aw.ImageLabel.ImageTransparency=not ap.Locked and 0 or.7
au=-30
end


if ap.Image and not aq then
local ax=af.Image(ap.Image,ap.Title,ap.UICorner,Window.Folder,"TabImage",false)
ax.Size=UDim2.new(1,0,0,100)
ax.Parent=ap.UIElements.Main.Frame
ax.ImageLabel.ImageTransparency=not ap.Locked and 0 or.7
ax.LayoutOrder=-1

ap.UIElements.Main.Frame.UIListLayout.FillDirection="Vertical"
ap.UIElements.Main.Frame.UIListLayout.Padding=UDim.new(0,0)
ap.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,0,0,30)
ap.UIElements.Main.Frame.TextLabel.TextXAlignment="Center"
ap.UIElements.Main.Frame.UIPadding.PaddingTop=UDim.new(0,0)
ap.UIElements.Main.Frame.UIPadding.PaddingLeft=UDim.new(0,0)
ap.UIElements.Main.Frame.UIPadding.PaddingRight=UDim.new(0,0)
ap.UIElements.Main.Frame.UIPadding.PaddingBottom=UDim.new(0,0)

ap.UIElements.Image=ax
end


if aq then
local ax=ap.UIElements.Main.Frame:FindFirstChild"UIListLayout"
if ax then ax:Destroy()end
local ay=ap.UIElements.Main.Frame:FindFirstChild"UIPadding"
if ay then ay:Destroy()end
local az=ap.UIElements.Main.Frame:FindFirstChild"TextLabel"
if az then az:Destroy()end

ap.UIElements.Main.Frame.AutomaticSize=Enum.AutomaticSize.None
ap.UIElements.Main.Frame.Size=UDim2.new(1,0,0,120)

local aA=55
if ap.Profile.Banner then
local aB=af.Image(
ap.Profile.Banner,"SidebarBanner",0,Window.Folder,"ProfileBanner",false
)
aB.Size=UDim2.new(1,0,0,aA)
aB.Position=UDim2.new(0,0,0,0)
aB.BackgroundTransparency=1
aB.Parent=ap.UIElements.Main.Frame
aB.ZIndex=1

if aB:FindFirstChild"ImageLabel"then
aB.ImageLabel.ScaleType=Enum.ScaleType.Crop
aB.ImageLabel.Size=UDim2.fromScale(1,1)
end
end


if ap.Profile.Badges then
local aB=ah("Frame",{
Name="SidebarBadgeContainer",
Size=UDim2.new(0,0,0,24),
AutomaticSize=Enum.AutomaticSize.X,
Position=UDim2.new(1,-6,0,aA-4),
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

for b,d in ipairs(ap.Profile.Badges)do
local e=d.Icon or"help-circle"
local f=d.Title~=nil

local g=ah("Frame",{
Name="BadgeWrapper",
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,24),
AutomaticSize=Enum.AutomaticSize.X,
Parent=aB,
})

local h=af.NewRoundFrame(6,"Squircle",{
ImageColor3=Color3.new(0,0,0),
ImageTransparency=0.4,
Size=UDim2.new(1,0,1,0),
Name="BG",
Parent=g
})

local j=ah("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Parent=g
},{
ah("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
VerticalAlignment=Enum.VerticalAlignment.Center,
HorizontalAlignment=Enum.HorizontalAlignment.Center,
Padding=UDim.new(0,4)
}),
ah("UIPadding",{
PaddingLeft=UDim.new(0,f and 6 or 4),
PaddingRight=UDim.new(0,f and 6 or 4),
})
})

local l=af.Image(e,"BadgeIcon",0,Window.Folder,"Badge",false)
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
ah("TextLabel",{
Text=d.Title,
TextSize=11,
FontFace=Font.new(af.Font,Enum.FontWeight.SemiBold),
TextColor3=Color3.new(1,1,1),
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.XY,
LayoutOrder=2,
Parent=j
})
end

local p=ah("TextButton",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Text="",
ZIndex=10,
Parent=g
})

if d.Callback then
af.AddSignal(p.MouseButton1Click,function()
d.Callback()
end)
end

af.AddSignal(p.MouseEnter,function()
aj(h,0.1,{ImageTransparency=0.2}):Play()
end)
af.AddSignal(p.MouseLeave,function()
aj(h,0.1,{ImageTransparency=0.4}):Play()
end)

if d.Desc then
local r
local u
local v
local x=false

af.AddSignal(p.MouseEnter,function()
x=true
u=task.spawn(function()
task.wait(0.35)
if x and not r then
r=ak(d.Desc,am.ToolTipParent)
local function updatePosition()
if r then
r.Container.Position=UDim2.new(0,ae.X,0,ae.Y-20)
end
end
updatePosition()
v=ae.Move:Connect(updatePosition)
r:Open()
end
end)
end)

af.AddSignal(p.MouseLeave,function()
x=false
if u then task.cancel(u)u=nil end
if v then v:Disconnect()v=nil end
if r then r:Close()r=nil end
end)
end
end
end

local aB=46
local b=ah("Frame",{
Name="Avatar",
Size=UDim2.new(0,aB,0,aB),
Position=UDim2.new(0,10,0,aA-(aB/2)),
BackgroundTransparency=1,
Parent=ap.UIElements.Main.Frame,
ZIndex=2
})

if ap.Profile.Avatar then
local d=af.Image(
ap.Profile.Avatar,"SidebarAvatar",0,Window.Folder,"ProfileAvatar",false
)
d.Size=UDim2.fromScale(1,1)
d.Parent=b
d.BackgroundTransparency=1

local e=d:FindFirstChild"ImageLabel"
if e then
e.Size=UDim2.fromScale(1,1)
e.BackgroundTransparency=1
local f=e:FindFirstChildOfClass"UICorner"
if f then f:Destroy()end
ah("UICorner",{CornerRadius=UDim.new(1,0),Parent=e})
end

ah("UIStroke",{
Parent=b,
Thickness=2.5,
ThemeTag={Color="TabBackground"},
Transparency=0,
ApplyStrokeMode=Enum.ApplyStrokeMode.Border
})
ah("UICorner",{CornerRadius=UDim.new(1,0),Parent=b})
end

if ap.Profile.Status then
ah("Frame",{
Size=UDim2.new(0,12,0,12),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundColor3=Color3.fromHex"#23a559",
Parent=b,
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
Size=UDim2.new(1,-(10+aB+8),1,-aA-6),
Position=UDim2.new(0,10+aB+8,0,aA+5),
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


local ax=0
local ay=0

local az=150

if ap.ShowTabTitle then
ax=((Window.UIPadding*2.4)+12)
ay=ay-ax
end


if ar and as then
ax=ax+az
ay=ay-az
end


ap.UIElements.ContainerFrame=ah("ScrollingFrame",{
Size=UDim2.new(1,0,1,ay),
Position=UDim2.new(0,0,0,ax),
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
aw,
ah("TextLabel",{
Text=ap.Title,
ThemeTag={
TextColor3="Text"
},
TextSize=20,
TextTransparency=.1,
Size=UDim2.new(1,-au,1,0),
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


if ar then
local aA=100
local aB=70

local b=ah("Frame",{
Name="ProfileHeader",
Size=UDim2.new(1,0,0,az),

Position=UDim2.new(0,0,0,ap.ShowTabTitle and((Window.UIPadding*2.4)+12)or 0),
BackgroundTransparency=1,
ZIndex=2
})


if as and not aq then
b.Parent=ap.UIElements.ContainerFrameCanvas
else
b.Parent=ap.UIElements.ContainerFrame
b.LayoutOrder=-999
end

local d=af.NewRoundFrame(12,"Squircle",{
Size=UDim2.new(1,0,0,aA),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
ImageColor3=Color3.fromRGB(30,30,30),
Parent=b,
ClipsDescendants=true
})

if ap.Profile.Banner then
local e=af.Image(ap.Profile.Banner,"Banner",0,Window.Folder,"ProfileBanner",false)
e.Size=UDim2.new(1,0,1,0)
e.Parent=d
end


if ap.Profile.Badges then
local e=ah("Frame",{
Name="BadgeContainer",
Size=UDim2.new(0,0,0,28),
AutomaticSize=Enum.AutomaticSize.X,
Position=UDim2.new(1,-8,1,-8),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
Parent=d,
ZIndex=5
},{
ah("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
HorizontalAlignment=Enum.HorizontalAlignment.Right,
VerticalAlignment=Enum.VerticalAlignment.Center,
Padding=UDim.new(0,6)
})
})

for f,g in ipairs(ap.Profile.Badges)do
local h=g.Icon or"help-circle"
local j=g.Title~=nil

local l=ah("Frame",{
Name="BadgeWrapper",
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,28),
AutomaticSize=Enum.AutomaticSize.X,
Parent=e,
})

local m=af.NewRoundFrame(6,"Squircle",{
ImageColor3=Color3.new(0,0,0),
ImageTransparency=0.4,
Size=UDim2.new(1,0,1,0),
Name="BG",
Parent=l
})

local p=ah("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Parent=l
},{
ah("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,
VerticalAlignment=Enum.VerticalAlignment.Center,
HorizontalAlignment=Enum.HorizontalAlignment.Center,
Padding=UDim.new(0,4)
}),
ah("UIPadding",{
PaddingLeft=UDim.new(0,j and 8 or 5),
PaddingRight=UDim.new(0,j and 8 or 5),
})
})

local r=af.Image(h,"BadgeIcon",0,Window.Folder,"Badge",false)
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
ah("TextLabel",{
Text=g.Title,
TextSize=12,
FontFace=Font.new(af.Font,Enum.FontWeight.SemiBold),
TextColor3=Color3.new(1,1,1),
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.XY,
LayoutOrder=2,
Parent=p
})
end

local v=ah("TextButton",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Text="",
ZIndex=10,
Parent=l
})

if g.Callback then
af.AddSignal(v.MouseButton1Click,function()
g.Callback()
end)
end

af.AddSignal(v.MouseEnter,function()
aj(m,0.1,{ImageTransparency=0.2}):Play()
end)
af.AddSignal(v.MouseLeave,function()
aj(m,0.1,{ImageTransparency=0.4}):Play()
end)

if g.Desc then
local x
local z
local A
local B=false

af.AddSignal(v.MouseEnter,function()
B=true
z=task.spawn(function()
task.wait(0.35)
if B and not x then
x=ak(g.Desc,am.ToolTipParent)
local function updatePosition()
if x then
x.Container.Position=UDim2.new(0,ae.X,0,ae.Y-20)
end
end
updatePosition()
A=ae.Move:Connect(updatePosition)
x:Open()
end
end)
end)

af.AddSignal(v.MouseLeave,function()
B=false
if z then task.cancel(z)z=nil end
if A then A:Disconnect()A=nil end
if x then x:Close()x=nil end
end)
end
end
end

local e=ah("Frame",{
Size=UDim2.new(0,aB,0,aB),
Position=UDim2.new(0,14,0,aA-(aB/2)+5),
BackgroundTransparency=1,
Parent=b,
ZIndex=2
})

ah("UIStroke",{
Parent=e,
Thickness=4,
ThemeTag={Color="WindowBackground"},
Transparency=0,
ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
})
ah("UICorner",{CornerRadius=UDim.new(1,0),Parent=e})

if ap.Profile.Avatar then
local f=af.Image(ap.Profile.Avatar,"Avatar",0,Window.Folder,"ProfileAvatar",false)
f.Size=UDim2.fromScale(1,1)
f.BackgroundTransparency=1
f.Parent=e

local g=f:FindFirstChild"ImageLabel"
if g then
g.Size=UDim2.fromScale(1,1)
g.BackgroundTransparency=1
local h=g:FindFirstChildOfClass"UICorner"
if h then h:Destroy()end
ah("UICorner",{CornerRadius=UDim.new(1,0),Parent=g})
end
end

if ap.Profile.Status then
ah("Frame",{
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(1,-3,1,-3),
AnchorPoint=Vector2.new(1,1),
BackgroundColor3=Color3.fromHex"#23a559",
Parent=e,
ZIndex=3
},{
ah("UICorner",{CornerRadius=UDim.new(1,0)}),
ah("UIStroke",{Thickness=3,ThemeTag={Color="WindowBackground"}})
})
end

local f=ah("Frame",{
Name="TextContainer",
BackgroundTransparency=1,
AutomaticSize=Enum.AutomaticSize.Y,
Size=UDim2.new(1,-(14+aB+14),0,0),
Position=UDim2.new(0,14+aB+14,0,aA+2),
Parent=b
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
Parent=f,
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
Parent=f,
LayoutOrder=2
})
end
end

ap.UIElements.ContainerFrame.Parent=ap.UIElements.ContainerFrameCanvas










ap.Headers={}
do
local aA=ap.UIElements.ContainerFrame
local aB=ap.UIElements.ContainerFrameCanvas
local b=aA:FindFirstChildOfClass"UIPadding"

local d=aA.Position.Y.Offset
local e=aA.Size.Y.Offset
local f=b and b.PaddingTop.Offset or 0

ap.HeaderOffset=0
ap.HeaderContentPadding=ap.HeaderContentPadding or 5

local function Relayout()
local g=0
for h,j in ipairs(ap.Headers)do
j.Frame.Position=UDim2.new(0,0,0,d+g)
j.Frame.Size=UDim2.new(1,0,0,j.Height)
g=g+j.Height
end

ap.HeaderOffset=g
aA.Position=UDim2.new(0,0,0,d+g)
aA.Size=UDim2.new(1,0,1,e-g)

if b then


b.PaddingTop=UDim.new(0,g>0 and ap.HeaderContentPadding or f)
end
end

ap.RelayoutHeaders=Relayout

function ap.ReserveHeader(g,h,j)
j=j or{}

local l=h or 0
local m=j.PaddingTop or f
local p=j.PaddingBottom or 0
local r=j.AlignWithContent~=false

if j.ContentPadding then
ap.HeaderContentPadding=j.ContentPadding
end

local u=ah("Frame",{
Name=j.Name or"TabHeader",
Size=UDim2.new(1,0,0,l+m+p),
BackgroundTransparency=1,
ZIndex=j.ZIndex or 6,
Parent=aB,
},{
ah("UIPadding",{
PaddingTop=UDim.new(0,m),
PaddingBottom=UDim.new(0,p),
PaddingLeft=(r and b)and b.PaddingLeft or UDim.new(0,0),
PaddingRight=(r and b)and b.PaddingRight or UDim.new(0,0),
})
})

local v={
Frame=u,
Tab=ap,
ContentHeight=l,
Height=l+m+p,
Released=false,
}

function v.SetHeight(x,z)
v.ContentHeight=z or 0
v.Height=v.ContentHeight+m+p
Relayout()
return v
end

function v.Release(x,z)
if v.Released then return end
v.Released=true

for A,B in ipairs(ap.Headers)do
if B==v then
table.remove(ap.Headers,A)
break
end
end
if not z then
u:Destroy()
end
Relayout()
end

table.insert(ap.Headers,v)
Relayout()

return v
end
end

am.Containers[at]=ap.UIElements.ContainerFrameCanvas
am.Tabs[at]=ap

ap.ContainerFrame=ContainerFrameCanvas

af.AddSignal(ap.UIElements.Main.MouseButton1Click,function()
if not ap.Locked then
am:SelectTab(at)
end
end)

if Window.ScrollBarEnabled then
al(ap.UIElements.ContainerFrame,ap.UIElements.ContainerFrameCanvas,Window,3)
end

local aA
local aB
local b
local d=false

if ap.Desc and not aq then
af.AddSignal(ap.UIElements.Main.InputBegan,function()
d=true
aB=task.spawn(function()
task.wait(0.35)
if d and not aA then
aA=ak(ap.Desc,am.ToolTipParent)
local function updatePosition()
if aA then
aA.Container.Position=UDim2.new(0,ae.X,0,ae.Y-20)
end
end
updatePosition()
b=ae.Move:Connect(updatePosition)
aA:Open()
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
if ap.Desc and not aq then
d=false
if aB then task.cancel(aB)aB=nil end
if b then b:Disconnect()b=nil end
if aA then aA:Close()aA=nil end
end

if not ap.Locked then
aj(ap.UIElements.Main.Frame,0.08,{ImageTransparency=1}):Play()
end
end)



function ap.ScrollToTheElement(e,f)
ap.UIElements.ContainerFrame.ScrollingEnabled=false
aj(ap.UIElements.ContainerFrame,.45,
{
CanvasPosition=Vector2.new(
0,

ap.Elements[f].ElementFrame.AbsolutePosition.Y
-ap.UIElements.ContainerFrame.AbsolutePosition.Y
-ap.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
)
},
Enum.EasingStyle.Quint,Enum.EasingDirection.Out
):Play()

task.spawn(function()
task.wait(.48)

if ap.Elements[f].Highlight then
ap.Elements[f]:Highlight()
ap.UIElements.ContainerFrame.ScrollingEnabled=true
end
end)

return ap
end

local e=a.load'U'
e.Load(ap,ap.UIElements.ContainerFrame,e.Elements,Window,ANUI,nil,e,ao)

function ap.LockAll(f)
for g,h in next,Window.AllElements do
if h.Tab and h.Tab.Index and h.Tab.Index==ap.Index and h.Lock then
h:Lock()
end
end
end
function ap.UnlockAll(f)
for g,h in next,Window.AllElements do
if h.Tab and h.Tab.Index and h.Tab.Index==ap.Index and h.Unlock then
h:Unlock()
end
end
end
function ap.GetLocked(f)
local g={}
for h,j in next,Window.AllElements do
if j.Tab and j.Tab.Index and j.Tab.Index==ap.Index and j.Locked==true then
table.insert(g,j)
end
end
return g
end
function ap.GetUnlocked(f)
local g={}
for h,j in next,Window.AllElements do
if j.Tab and j.Tab.Index and j.Tab.Index==ap.Index and j.Locked==false then
table.insert(g,j)
end
end
return g
end

function ap.Select(f)
return am:SelectTab(ap.Index)
end

task.spawn(function()
local f=ah("Frame",{
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

local g
g=af.AddSignal(ap.UIElements.ContainerFrame.ChildAdded,function()
f.Visible=false
g:Disconnect()
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

for ap,aq in next,am.Tabs do
if not aq.Locked then
aj(aq.UIElements.Main,0.15,{ImageTransparency=1}):Play()
aj(aq.UIElements.Main.Outline,0.15,{ImageTransparency=1}):Play()

if aq.UIElements.Main.Frame:FindFirstChild"TextLabel"then
aj(aq.UIElements.Main.Frame.TextLabel,0.15,{TextTransparency=0.3}):Play()
end

if aq.UIElements.Icon then
aj(aq.UIElements.Icon.ImageLabel,0.15,{ImageTransparency=0.4}):Play()
end
aq.Selected=false
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
for ap,aq in next,am.Containers do
aq.AnchorPoint=Vector2.new(0,0.05)
aq.Visible=false
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

local aq
if ap.Icon then
aq=ae.Image(
ap.Icon,
ap.Icon,
0,
am,
"Section",
true,
ap.IconThemed
)

aq.Size=UDim2.new(0,ap.IconSize,0,ap.IconSize)
aq.ImageLabel.ImageTransparency=.25
end

local ar=af("Frame",{
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

local as=af("Frame",{
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
aq,
af("TextLabel",{
Text=ap.Title,
TextXAlignment="Left",
Size=UDim2.new(
1,
aq and(-ap.IconSize-10)*2
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
ar,
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


function ap.Tab(at,au)
if not ap.Expandable then
ap.Expandable=true
ar.Visible=true
end
au.Parent=as.Content
return aj.New(au,an)
end

function ap.Open(at)
if ap.Expandable then
ap.Opened=true
ah(as,0.33,{
Size=UDim2.new(1,0,0,ap.HeaderSize+(as.Content.AbsoluteSize.Y/an))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ah(ar.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function ap.Close(at)
if ap.Expandable then
ap.Opened=false
ah(as,0.26,{
Size=UDim2.new(1,0,0,ap.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ah(ar.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

ae.AddSignal(as.TextButton.MouseButton1Click,function()
if ap.Expandable then
if ap.Opened then
ap:Close()
else
ap:Open()
end
end
end)

ae.AddSignal(as.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
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
Category="layout-grid",
Image="image",
Group="layers",
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

local aq=ah("ScrollingFrame",{
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

local ar=af.NewRoundFrame(an.Radius,"Squircle",{
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
aq,
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

local as=ah("Frame",{
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
ar,
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

local function CreateSearchTab(at,au,av,aw,ax,ay)
local az=ah("TextButton",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=aw or nil
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
Image=af.Icon(av)[1],
ImageRectSize=af.Icon(av)[2].ImageRectSize,
ImageRectOffset=af.Icon(av)[2].ImageRectPosition,
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
Text=at,
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
Text=au or"",
Visible=au and true or false,
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
Visible=ax,

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



az.Main.Size=UDim2.new(
1,
0,
0,
az.Main.Outline.Frame.Desc.Visible and(((an.Padding-2)*2)+az.Main.Outline.Frame.Title.TextBounds.Y+6+az.Main.Outline.Frame.Desc.TextBounds.Y)
or(((an.Padding-2)*2)+az.Main.Outline.Frame.Title.TextBounds.Y)
)

af.AddSignal(az.Main.MouseEnter,function()
aj(az.Main,.04,{ImageTransparency=.95}):Play()
aj(az.Main.Outline,.04,{ImageTransparency=.7}):Play()
end)
af.AddSignal(az.Main.InputEnded,function()
aj(az.Main,.08,{ImageTransparency=1}):Play()
aj(az.Main.Outline,.08,{ImageTransparency=1}):Play()
end)
af.AddSignal(az.Main.MouseButton1Click,function()
if ay then
ay()
end
end)

return az
end

local function ContainsText(at,au)
if not au or au==""then
return false
end

if not at or at==""then
return false
end

local av=string.lower(at)
local aw=string.lower(au)

return string.find(av,aw,1,true)~=nil
end

local function Search(at)
if not at or at==""then
return{}
end

local au={}
for av,aw in next,ak.Tabs do
local ax=ContainsText(aw.Title or"",at)
local ay={}

for az,aA in next,aw.Elements do
if aA.__type~="Section"then
local aB=ContainsText(aA.Title or"",at)
local b=ContainsText(aA.Desc or"",at)

if aB or b then
ay[az]={
Title=aA.Title,
Desc=aA.Desc,
Original=aA,
__type=aA.__type,
Index=az,
}
end
end
end

if ax or next(ay)~=nil then
au[av]={
Tab=aw,
Title=aw.Title,
Icon=aw.Icon,
Elements=ay,
}
end
end
return au
end

function an.Search(at,au)
au=au or""

local av=Search(au)

aq.Visible=true
ar.Frame.Results.Frame.Visible=true
for aw,ax in next,aq:GetChildren()do
if ax.ClassName~="UIListLayout"and ax.ClassName~="UIPadding"then
ax:Destroy()
end
end

if av and next(av)~=nil then
for aw,ax in next,av do
local ay=an.Icons.Tab
local az=CreateSearchTab(ax.Title,nil,ay,aq,true,function()
an:Close()
ak:SelectTab(aw)
end)
if ax.Elements and next(ax.Elements)~=nil then
for aA,aB in next,ax.Elements do
local b=an.Icons[aB.__type]
CreateSearchTab(aB.Title,aB.Desc,b,az:FindFirstChild"ParentContainer"and az.ParentContainer.Frame or nil,false,function()
an:Close()
ak:SelectTab(aw)
if ax.Tab.ScrollToTheElement then

ax.Tab:ScrollToTheElement(aB.Index)
end

end)

end
end
end
elseif au~=""then
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
Parent=aq,
Name="NotFound",
})
else
aq.Visible=false
ar.Frame.Results.Frame.Visible=false
end
end

af.AddSignal(ao:GetPropertyChangedSignal"Text",function()
an:Search(ao.Text)
end)

af.AddSignal(aq.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()

aj(aq,.06,{Size=UDim2.new(
1,
0,
0,
math.clamp(aq.UIListLayout.AbsoluteContentSize.Y+(an.Padding*2),0,an.MaxHeight)
)},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()






end)

function an.Open(at)
task.spawn(function()
ar.Frame.Visible=true
as.Visible=true
aj(as.UIScale,.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

function an.Close(at)
task.spawn(function()
am()
ar.Frame.Visible=false
aj(as.UIScale,.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(.12)
as.Visible=false
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

local aq=a.load'w'



return function(ar)
local as={
Title=ar.Title or"UI Library",
Author=ar.Author,
Icon=ar.Icon,
IconSize=ar.IconSize or 22,
IconThemed=ar.IconThemed,
Folder=ar.Folder,
Resizable=ar.Resizable~=false,
Background=ar.Background,
BackgroundImageTransparency=ar.BackgroundImageTransparency or 0,
ShadowTransparency=ar.ShadowTransparency or 0.7,
User=ar.User or{},

Size=ar.Size,

MinSize=ar.MinSize or Vector2.new(850,560),
MaxSize=ar.MaxSize or Vector2.new(1050,560),

TopBarButtonIconSize=ar.TopBarButtonIconSize or 16,

ToggleKey=ar.ToggleKey,
ElementsRadius=ar.ElementsRadius,
Radius=ar.Radius or 16,
Transparent=ar.Transparent or false,
HideSearchBar=ar.HideSearchBar~=false,
ScrollBarEnabled=ar.ScrollBarEnabled or false,
SideBarWidth=ar.SideBarWidth or 200,
Acrylic=ar.Acrylic or false,
NewElements=ar.NewElements or false,
IgnoreAlerts=ar.IgnoreAlerts or false,
HidePanelBackground=ar.HidePanelBackground or false,
AutoScale=ar.AutoScale~=false,
OpenButton=ar.OpenButton,

Position=UDim2.new(0.5,0,0.5,0),
UICorner=nil,
UIPadding=14,
UIElements={},
CanDropdown=true,
Closed=false,
Parent=ar.Parent,
Destroyed=false,
IsFullscreen=false,
CanResize=ar.Resizable~=false,
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
PendingConfigData={},

IsToggleDragging=false,
}

as.UICorner=as.Radius

as.ElementConfig={
UIPadding=(as.NewElements and 10 or 13),
UICorner=as.ElementsRadius or(as.NewElements and 23 or 12),
}

local at=as.Size or UDim2.new(0,580,0,460)
as.Size=UDim2.new(
at.X.Scale,
math.clamp(at.X.Offset,as.MinSize.X,as.MaxSize.X),
at.Y.Scale,
math.clamp(at.Y.Offset,as.MinSize.Y,as.MaxSize.Y)
)

if as.Folder then
if not isfolder("ANUI/"..as.Folder)then
makefolder("ANUI/"..as.Folder)
end
if not isfolder("ANUI/"..as.Folder.."/assets")then
makefolder("ANUI/"..as.Folder.."/assets")
end
if not isfolder(as.Folder)then
makefolder(as.Folder)
end
if not isfolder(as.Folder.."/assets")then
makefolder(as.Folder.."/assets")
end
end

local au=ak("UICorner",{
CornerRadius=UDim.new(0,as.UICorner)
})

if as.Folder then
as.ConfigManager=aq:Init(as)
end


if as.Acrylic then local
av=ah.AcrylicPaint{UseAcrylic=as.Acrylic}

as.AcrylicPaint=av
end

local av=ak("Frame",{
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
local aw=aj.NewRoundFrame(as.UICorner,"Squircle",{
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

local ax=aj.NewRoundFrame(as.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=999,
Active=false,
})










as.UIElements.SideBar=ak("ScrollingFrame",{
Size=UDim2.new(
1,
as.ScrollBarEnabled and-3-(as.UIPadding/2)or 0,
1,
not as.HideSearchBar and-45 or 0
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
PaddingTop=UDim.new(0,as.UIPadding/2),


PaddingBottom=UDim.new(0,as.UIPadding/2),
}),
ak("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,as.Gap)
})
}),
ak("UIPadding",{

PaddingLeft=UDim.new(0,as.UIPadding/2),
PaddingRight=UDim.new(0,as.UIPadding/2),

}),

})

as.UIElements.SideBarContainer=ak("Frame",{
Size=UDim2.new(0,as.SideBarWidth,1,as.User.Enabled and-94-(as.UIPadding*2)or-52),
Position=UDim2.new(0,0,0,52),
BackgroundTransparency=1,
Visible=true,
},{
aj.NewRoundFrame(as.UICorner-(as.UIPadding/2),"Squircle",{
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
not as.HideSearchBar and-45-as.UIPadding/2 or 0
),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
}),
as.UIElements.SideBar,
})

if as.ScrollBarEnabled then
ao(as.UIElements.SideBar,as.UIElements.SideBarContainer.Content,as,3)
end


as.UIElements.MainBar=ak("Frame",{
Size=UDim2.new(1,-as.UIElements.SideBarContainer.AbsoluteSize.X,1,-52),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
},{
aj.NewRoundFrame(as.UICorner-(as.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ZIndex=3,
ImageTransparency=.95,
Name="Background",
Visible=not as.HidePanelBackground
}),
ak("UIPadding",{
PaddingTop=UDim.new(0,as.UIPadding/2),
PaddingLeft=UDim.new(0,as.UIPadding/2),
PaddingRight=UDim.new(0,as.UIPadding/2),
PaddingBottom=UDim.new(0,as.UIPadding/2),
})
})

local function getScaledSidebarWidth()
return as.UIElements.SideBarContainer.AbsoluteSize.X/(ar.ANUI.UIScale or 1)
end

as.UIElements.MainBar.Size=UDim2.new(1,-as.SideBarWidth,1,-52)

aj.AddSignal(as.UIElements.SideBarContainer:GetPropertyChangedSignal"AbsoluteSize",function()
as.UIElements.MainBar.Size=UDim2.new(1,-getScaledSidebarWidth(),1,-52)
end)

local ay=ak("ImageLabel",{
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
as.IsPC=false
elseif ae.KeyboardEnabled then
as.IsPC=true
else
as.IsPC=nil
end










local az
if as.User then
local function GetUserThumb()local
aA=aa(game:GetService"Players"):GetUserThumbnailAsync(
as.User.Anonymous and 1 or game.Players.LocalPlayer.UserId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size420x420
)
return aA
end


az=ak("TextButton",{
Size=UDim2.new(0,
(as.UIElements.SideBarContainer.AbsoluteSize.X)-(as.UIPadding/2),
0,
42+(as.UIPadding)
),
Position=UDim2.new(0,as.UIPadding/2,1,-(as.UIPadding/2)),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
Visible=as.User.Enabled or false,
},{
aj.NewRoundFrame(as.UICorner-(as.UIPadding/2),"SquircleOutline",{
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
aj.NewRoundFrame(as.UICorner-(as.UIPadding/2),"Squircle",{
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
Text=as.User.Anonymous and"Anonymous"or game.Players.LocalPlayer.DisplayName,
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
Text=as.User.Anonymous and"anonymous"or game.Players.LocalPlayer.Name,
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
Padding=UDim.new(0,as.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ak("UIPadding",{
PaddingLeft=UDim.new(0,as.UIPadding/2),
PaddingRight=UDim.new(0,as.UIPadding/2),
})
})
})


function as.User.Enable(aA)
as.User.Enabled=true
al(as.UIElements.SideBarContainer,.25,{Size=UDim2.new(0,as.SideBarWidth,1,-94-(as.UIPadding*2))},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
az.Visible=true
end
function as.User.Disable(aA)
as.User.Enabled=false
al(as.UIElements.SideBarContainer,.25,{Size=UDim2.new(0,as.SideBarWidth,1,-52)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
az.Visible=false
end
function as.User.SetAnonymous(aA,aB)
if aB~=false then aB=true end
as.User.Anonymous=aB
az.UserIcon.ImageLabel.Image=GetUserThumb()
az.UserIcon.Frame.DisplayName.Text=aB and"Anonymous"or game.Players.LocalPlayer.DisplayName
az.UserIcon.Frame.UserName.Text=aB and"anonymous"or game.Players.LocalPlayer.Name
end

if as.User.Enabled then
as.User:Enable()
else
as.User:Disable()
end

if as.User.Callback then
aj.AddSignal(az.MouseButton1Click,function()
as.User.Callback()
end)
aj.AddSignal(az.MouseEnter,function()
al(az.UserIcon,0.04,{ImageTransparency=.95}):Play()
al(az.Outline,0.04,{ImageTransparency=.85}):Play()
end)
aj.AddSignal(az.InputEnded,function()
al(az.UserIcon,0.04,{ImageTransparency=1}):Play()
al(az.Outline,0.04,{ImageTransparency=1}):Play()
end)
end
end

local aA
local aB


local b=false
local d

local e=typeof(as.Background)=="string"and string.match(as.Background,"^video:(.+)")or nil
local f=typeof(as.Background)=="string"and not e and string.match(as.Background,"^https?://.+")or nil

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

if typeof(as.Background)=="string"and e then
b=true

if string.find(e,"http")then
local g=as.Folder.."/assets/."..aj.SanitizeFilename(e)..".webm"
if not isfile(g)then
local h,j=pcall(function()
local h=aj.Request{Url=e,Method="GET",Headers={["User-Agent"]="Roblox/Exploit"}}
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

d=ak("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=e,
Looped=true,
Volume=0,
},{
ak("UICorner",{
CornerRadius=UDim.new(0,as.UICorner)
}),
})
d:Play()

elseif f then
local g=as.Folder.."/assets/."..aj.SanitizeFilename(f)..GetImageExtension(f)
if not isfile(g)then
local h,j=pcall(function()
local h=aj.Request{Url=f,Method="GET",Headers={["User-Agent"]="Roblox/Exploit"}}
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

d=ak("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=j,
ImageTransparency=0,
ScaleType="Crop",
},{
ak("UICorner",{
CornerRadius=UDim.new(0,as.UICorner)
}),
})

elseif as.Background then
d=ak("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=typeof(as.Background)=="string"and as.Background or"",
ImageTransparency=1,
ScaleType="Crop",
},{
ak("UICorner",{
CornerRadius=UDim.new(0,as.UICorner)
}),
})
end


local g=aj.NewRoundFrame(99,"Squircle",{
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

function createAuthor(h)
return ak("TextLabel",{
Text=h,
FontFace=Font.new(aj.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
TextTransparency=0.35,
AutomaticSize="XY",
Parent=as.UIElements.Main and as.UIElements.Main.Main.Topbar.Left.Title,
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

if as.Author then
h=createAuthor(as.Author)
end


local l=ak("TextLabel",{
Text=as.Title,
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

as.UIElements.Main=ak("Frame",{
Size=as.Size,
Position=as.Position,
BackgroundTransparency=1,
Parent=ar.Parent,
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
},{
ar.ANUI.UIScaleObj,
as.AcrylicPaint and as.AcrylicPaint.Frame or nil,
ay,
aj.NewRoundFrame(as.UICorner,"Squircle",{
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
av,



}),
UIStroke,
au,
aw,
ax,
ak("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Main",

Visible=false,
ZIndex=97,
},{
ak("UICorner",{
CornerRadius=UDim.new(0,as.UICorner)
}),
as.UIElements.SideBarContainer,
as.UIElements.MainBar,

az,

aB,
ak("Frame",{
Size=UDim2.new(1,0,0,52),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(50,50,50),
Name="Topbar"
},{
aA,






ak("Frame",{
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
Name="Left"
},{
ak("UIListLayout",{
Padding=UDim.new(0,as.UIPadding+4),
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
l,
h,
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
Padding=UDim.new(0,as.UIPadding/2)
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
PaddingTop=UDim.new(0,as.UIPadding),
PaddingLeft=UDim.new(0,as.UIPadding),
PaddingRight=UDim.new(0,8),
PaddingBottom=UDim.new(0,as.UIPadding),
})
})
})
})

aj.AddSignal(as.UIElements.Main.Main.Topbar.Left:GetPropertyChangedSignal"AbsoluteSize",function()
local m=0
local p=as.UIElements.Main.Main.Topbar.Right.UIListLayout.AbsoluteContentSize.X/ar.ANUI.UIScale
if l and h then
m=math.max(l.TextBounds.X/ar.ANUI.UIScale,h.TextBounds.X/ar.ANUI.UIScale)
else
m=l.TextBounds.X/ar.ANUI.UIScale
end
if j then
m=m+(as.IconSize/ar.ANUI.UIScale)+(as.UIPadding/ar.ANUI.UIScale)+(4/ar.ANUI.UIScale)
end
as.UIElements.Main.Main.Topbar.Center.Position=UDim2.new(
0,
m+(as.UIPadding/ar.ANUI.UIScale),
0.5,
0
)
as.UIElements.Main.Main.Topbar.Center.Size=UDim2.new(
1,
-m-p-((as.UIPadding*2)/ar.ANUI.UIScale),
1,
0
)
end)

function as.CreateTopbarButton(m,p,r,u,v,x)
local z=aj.Image(
r,
r,
0,
as.Folder,
"WindowTopbarIcon",
true,
x,
"WindowTopbarButtonIcon"
)
z.Size=UDim2.new(0,as.TopBarButtonIconSize,0,as.TopBarButtonIconSize)
z.AnchorPoint=Vector2.new(0.5,0.5)
z.Position=UDim2.new(0.5,0,0.5,0)

local A=aj.NewRoundFrame(as.UICorner-(as.UIPadding/2),"Squircle",{
Size=UDim2.new(0,36,0,36),
LayoutOrder=v or 999,
Parent=as.UIElements.Main.Main.Topbar.Right,

ZIndex=9999,
ThemeTag={
ImageColor3="Text"
},
ImageTransparency=1
},{
aj.NewRoundFrame(as.UICorner-(as.UIPadding/2),"SquircleOutline",{
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
z
},true)



as.TopBarButtons[100-v]={
Name=p,
Object=A
}

aj.AddSignal(A.MouseButton1Click,function()
u()
end)
aj.AddSignal(A.MouseEnter,function()
al(A,.15,{ImageTransparency=.93}):Play()
al(A.Outline,.15,{ImageTransparency=.75}):Play()

end)
aj.AddSignal(A.MouseLeave,function()
al(A,.1,{ImageTransparency=1}):Play()
al(A.Outline,.1,{ImageTransparency=1}):Play()

end)

return A
end



local m=aj.Drag(
as.UIElements.Main,
{as.UIElements.Main.Main.Topbar,g.Frame},
function(m,p)
if not as.Closed then
if m and p==g.Frame then
al(g,.1,{ImageTransparency=.35}):Play()
else
al(g,.2,{ImageTransparency=.8}):Play()
end
as.Position=as.UIElements.Main.Position
as.Dragging=m
end
end
)

if not b and as.Background and typeof(as.Background)=="table"then

local p=ak"UIGradient"
for r,u in next,as.Background do
p[r]=u
end

as.UIElements.BackgroundGradient=aj.NewRoundFrame(as.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
Parent=as.UIElements.Main.Background,
ImageTransparency=as.Transparent and ar.ANUI.TransparencyValue or 0
},{
p
})
end














as.OpenButtonMain=a.load'x'.New(as)


task.spawn(function()
if as.Icon then

local p=ak("Frame",{
Size=UDim2.new(0,22,0,22),
BackgroundTransparency=1,
Parent=as.UIElements.Main.Main.Topbar.Left,
})

j=aj.Image(
as.Icon,
as.Title,
0,
as.Folder,
"Window",
true,
as.IconThemed,
"WindowTopbarIcon"
)
j.Parent=p
j.Size=UDim2.new(0,as.IconSize,0,as.IconSize)
j.Position=UDim2.new(0.5,0,0.5,0)
j.AnchorPoint=Vector2.new(0.5,0.5)

as.OpenButtonMain:SetIcon(as.Icon)











else
as.OpenButtonMain:SetIcon(as.Icon)

end
end)

function as.SetToggleKey(p,r)
as.ToggleKey=r
end

function as.SetTitle(p,r)
as.Title=r
l.Text=r
end

function as.SetAuthor(p,r)
as.Author=r
if not h then
h=createAuthor(as.Author)
end

h.Text=r
end

function as.SetBackgroundImage(p,r)
as.UIElements.Main.Background.ImageLabel.Image=r
end
function as.SetBackgroundImageTransparency(p,r)
if d and d:IsA"ImageLabel"then
d.ImageTransparency=math.floor(r*10+0.5)/10
end
as.BackgroundImageTransparency=math.floor(r*10+0.5)/10
end

function as.SetBackgroundTransparency(p,r)
local u=math.floor(tonumber(r)*10+0.5)/10
ar.ANUI.TransparencyValue=u
as:ToggleTransparency(u>0)
end




as.SidebarCollapsed=false

local function updateSidebarToggleIcon()
local p=as.UIElements.SidebarToggleButtonIcon
if p and p:FindFirstChild"ImageLabel"then
local r=as.SidebarCollapsed and"chevrons-right"or"chevrons-left"
local u=aj.Icon(r)
if u and u[1]and u[2]then
p.ImageLabel.Image=u[1]
p.ImageLabel.ImageRectOffset=u[2].ImageRectPosition
p.ImageLabel.ImageRectSize=u[2].ImageRectSize
end
end
end

function as.CollapseSidebar(p)
if as.SidebarCollapsed then return end
as.SidebarCollapsed=true
local r=as.User.Enabled and-94-(as.UIPadding*2)or-52
al(as.UIElements.SideBarContainer,.32,{Size=UDim2.new(0,0,1,r)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
al(as.UIElements.MainBar,.32,{Size=UDim2.new(1,0,1,-52)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
al(as.UIElements.SideBarContainer.SidebarBackdrop,.28,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
task.delay(.32,function()
al(as.UIElements.SideBarContainer,.16,{Size=UDim2.new(0,8,1,r)},Enum.EasingStyle.Sine,Enum.EasingDirection.Out):Play()
al(as.UIElements.MainBar,.16,{Size=UDim2.new(1,-(8/(ar.ANUI.UIScale or 1)),1,-52)},Enum.EasingStyle.Sine,Enum.EasingDirection.Out):Play()
end)
task.delay(.48,function()
al(as.UIElements.SideBarContainer,.16,{Size=UDim2.new(0,0,1,r)},Enum.EasingStyle.Sine,Enum.EasingDirection.In):Play()
al(as.UIElements.MainBar,.16,{Size=UDim2.new(1,0,1,-52)},Enum.EasingStyle.Sine,Enum.EasingDirection.In):Play()
end)
updateSidebarToggleIcon()
end

function as.ExpandSidebar(p)
if not as.SidebarCollapsed then return end
as.SidebarCollapsed=false
local r=as.User.Enabled and-94-(as.UIPadding*2)or-52
al(as.UIElements.SideBarContainer,.36,{Size=UDim2.new(0,as.SideBarWidth,1,r)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
al(as.UIElements.MainBar,.36,{Size=UDim2.new(1,-as.SideBarWidth,1,-52)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
al(as.UIElements.SideBarContainer.SidebarBackdrop,.30,{ImageTransparency=.95},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
task.delay(.36,function()
al(as.UIElements.SideBarContainer,.18,{Size=UDim2.new(0,as.SideBarWidth+10,1,r)},Enum.EasingStyle.Sine,Enum.EasingDirection.Out):Play()
al(as.UIElements.MainBar,.18,{Size=UDim2.new(1,-(as.SideBarWidth+10),1,-52)},Enum.EasingStyle.Sine,Enum.EasingDirection.Out):Play()
end)
task.delay(.54,function()
al(as.UIElements.SideBarContainer,.18,{Size=UDim2.new(0,as.SideBarWidth,1,r)},Enum.EasingStyle.Sine,Enum.EasingDirection.In):Play()
al(as.UIElements.MainBar,.18,{Size=UDim2.new(1,-as.SideBarWidth,1,-52)},Enum.EasingStyle.Sine,Enum.EasingDirection.In):Play()
end)
updateSidebarToggleIcon()
end

function as.ToggleSidebar(p,r)
if r==nil then
if as.SidebarCollapsed then
as:ExpandSidebar()
else
as:CollapseSidebar()
end
else
if r then
as:CollapseSidebar()
else
as:ExpandSidebar()
end
end
end

local p=as:CreateTopbarButton("Sidebar","chevrons-left",function()
as:ToggleSidebar()
end,998)
as.UIElements.SidebarToggleButton=p
as.UIElements.SidebarToggleButtonIcon=p:FindFirstChild("WindowTopbarButtonIcon",true)
updateSidebarToggleIcon()

as:CreateTopbarButton("Minimize","minus",function()
as:Close()






















end,997)

function as.OnOpen(r,u)
as.OnOpenCallback=u
end
function as.OnClose(r,u)
as.OnCloseCallback=u
end
function as.OnDestroy(r,u)
as.OnDestroyCallback=u
end

if ar.ANUI.UseAcrylic then
as.AcrylicPaint.AddParent(as.UIElements.Main)
end

function as.SetIconSize(r,u)
local v
if typeof(u)=="number"then
v=UDim2.new(0,u,0,u)
as.IconSize=u
elseif typeof(u)=="UDim2"then
v=u
as.IconSize=u.X.Offset
end

if j then
j.Size=v
end
end

function as.Open(r)
task.spawn(function()
if as.OnOpenCallback then
task.spawn(function()
aj.SafeCallback(as.OnOpenCallback)
end)
end


task.wait(.06)
as.Closed=false

al(as.UIElements.Main.Background,0.2,{
ImageTransparency=as.Transparent and ar.ANUI.TransparencyValue or 0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if as.UIElements.BackgroundGradient then
al(as.UIElements.BackgroundGradient,0.2,{
ImageTransparency=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

al(as.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,0),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()

if d then
if d:IsA"VideoFrame"then
d.Visible=true
else
al(d,0.2,{
ImageTransparency=as.BackgroundImageTransparency,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

if as.OpenButtonMain and as.IsOpenButtonEnabled then
as.OpenButtonMain:Visible(false)
end


al(ay,0.25,{ImageTransparency=as.ShadowTransparency},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if UIStroke then
al(UIStroke,0.25,{Transparency=.8},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

task.spawn(function()
task.wait(.3)
al(g,.45,{Size=UDim2.new(0,200,0,4),ImageTransparency=.8},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
m:Set(true)
task.wait(.45)
if as.Resizable then
al(av.ImageLabel,.45,{ImageTransparency=.8},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
as.CanResize=true
end
end)


as.CanDropdown=true

as.UIElements.Main.Visible=true
task.spawn(function()
task.wait(.05)
as.UIElements.Main:WaitForChild"Main".Visible=true

ar.ANUI:ToggleAcrylic(true)
end)
end)
end
function as.Close(r)
local u={}

if as.OnCloseCallback then
task.spawn(function()
aj.SafeCallback(as.OnCloseCallback)
end)
end

ar.ANUI:ToggleAcrylic(false)

as.UIElements.Main:WaitForChild"Main".Visible=false

as.CanDropdown=false
as.Closed=true

al(as.UIElements.Main.Background,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
if as.UIElements.BackgroundGradient then
al(as.UIElements.BackgroundGradient,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end

al(as.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,-240),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()


if d then
if d:IsA"VideoFrame"then
d.Visible=false
else
al(d,0.3,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
al(ay,0.25,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if UIStroke then
al(UIStroke,0.25,{Transparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

al(g,.3,{Size=UDim2.new(0,0,0,4),ImageTransparency=1},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()
al(av.ImageLabel,.3,{ImageTransparency=1},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()
m:Set(false)
as.CanResize=false

task.spawn(function()
task.wait(0.4)
as.UIElements.Main.Visible=false

if as.OpenButtonMain and not as.Destroyed and as.IsOpenButtonEnabled then
as.OpenButtonMain:Edit{OnlyIcon=true}
as.OpenButtonMain:Visible(true)
end
end)

function u.Destroy(v)
task.spawn(function()
if as.OnDestroyCallback then
task.spawn(function()
aj.SafeCallback(as.OnDestroyCallback)
end)
end
if as.AcrylicPaint and as.AcrylicPaint.Model then
as.AcrylicPaint.Model:Destroy()
end
as.Destroyed=true
task.wait(0.4)
ar.ANUI.ScreenGui:Destroy()
ar.ANUI.NotificationGui:Destroy()
ar.ANUI.DropdownGui:Destroy()

aj.DisconnectAll()

return
end)
end

return u
end
function as.Destroy(r)
return as:Close():Destroy()
end
function as.Toggle(r)
if as.Closed then
as:Open()
else
as:Close()
end
end


function as.ToggleTransparency(r,u)

as.Transparent=u
ar.ANUI.Transparent=u

as.UIElements.Main.Background.ImageTransparency=u and ar.ANUI.TransparencyValue or 0

as.UIElements.MainBar.Background.ImageTransparency=u and 0.97 or 0.95

end

function as.LockAll(r)
for u,v in next,as.AllElements do
if v.Lock then v:Lock()end
end
end
function as.UnlockAll(r)
for u,v in next,as.AllElements do
if v.Unlock then v:Unlock()end
end
end
function as.GetLocked(r)
local u={}

for v,x in next,as.AllElements do
if x.Locked then table.insert(u,x)end
end

return u
end
function as.GetUnlocked(r)
local u={}

for v,x in next,as.AllElements do
if x.Locked==false then table.insert(u,x)end
end

return u
end

function as.GetUIScale(r,u)
return ar.ANUI.UIScale
end

function as.SetUIScale(r,u)
ar.ANUI.UIScale=u
al(ar.ANUI.UIScaleObj,.2,{Scale=u},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return as
end

function as.SetToTheCenter(r)
al(as.UIElements.Main,0.45,{Position=UDim2.new(0.5,0,0.5,0)},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return as
end

function as.SetCurrentConfig(r,u)
as.CurrentConfig=u
end

do
local r=40
local u=af.ViewportSize
local v=as.UIElements.Main.AbsoluteSize

if not as.IsFullscreen and as.AutoScale then
local x=u.X-(r*2)
local z=u.Y-(r*2)

local A=x/v.X
local B=z/v.Y

local C=math.min(A,B)

local F=0.3
local G=1.0

local H=math.clamp(C,F,G)

local J=as:GetUIScale()or 1
local L=0.05

if math.abs(H-J)>L then
as:SetUIScale(H)
end
end
end


if as.OpenButtonMain and as.OpenButtonMain.Button then
aj.AddSignal(as.OpenButtonMain.Button.TextButton.MouseButton1Click,function()


as:Open()
end)
end

aj.AddSignal(ae.InputBegan,function(r,u)
if u then return end

if as.ToggleKey then
if r.KeyCode==as.ToggleKey then
as:Toggle()
end
end
end)

task.spawn(function()

as:Open()
end)

function as.EditOpenButton(r,u)
return as.OpenButtonMain:Edit(u)
end

if as.OpenButton and typeof(as.OpenButton)=="table"then
as:EditOpenButton(as.OpenButton)
end


local r=a.load'V'
local u=a.load'W'
local v=r.Init(as,ar.ANUI,ar.Parent.Parent.ToolTips)
v:OnChange(function(x)as.CurrentTab=x end)

as.TabModule=r

function as.Tab(x,z)
z.Parent=as.UIElements.SideBar.Frame
return v.New(z,ar.ANUI.UIScale)
end

function as.SelectTab(x,z)
v:SelectTab(z)
end

function as.Section(x,z)
return u.New(z,as.UIElements.SideBar.Frame,as.Folder,ar.ANUI.UIScale,as)
end

function as.IsResizable(x,z)
as.Resizable=z
as.CanResize=z
end

function as.Divider(x)
local z=ak("Frame",{
Size=UDim2.new(1,0,0,1),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local A=ak("Frame",{
Parent=as.UIElements.SideBar.Frame,

Size=UDim2.new(1,-7,0,5),
BackgroundTransparency=1,
},{
z
})

return A
end

local x=a.load'l'.Init(as,nil)
function as.Dialog(z,A)
local B={
Title=A.Title or"Dialog",
Width=A.Width or 320,
Content=A.Content,
Buttons=A.Buttons or{},

TextPadding=10,
}
local C=x.Create(false)

C.UIElements.Main.Size=UDim2.new(0,B.Width,0,0)

local F=ak("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=C.UIElements.Main
},{
ak("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,C.UIPadding),
VerticalAlignment="Center"
}),
ak("UIPadding",{
PaddingTop=UDim.new(0,B.TextPadding/2),
PaddingLeft=UDim.new(0,B.TextPadding/2),
PaddingRight=UDim.new(0,B.TextPadding/2),
})
})

local G
if A.Icon then
G=aj.Image(
A.Icon,
B.Title..":"..A.Icon,
0,
as,
"Dialog",
true,
A.IconThemed
)
G.Size=UDim2.new(0,22,0,22)
G.Parent=F
end

C.UIElements.UIListLayout=ak("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
Parent=C.UIElements.Main
})

ak("UISizeConstraint",{
MinSize=Vector2.new(180,20),
MaxSize=Vector2.new(400,math.huge),
Parent=C.UIElements.Main,
})


C.UIElements.Title=ak("TextLabel",{
Text=B.Title,
TextSize=20,
FontFace=Font.new(aj.Font,Enum.FontWeight.SemiBold),
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
ak("TextLabel",{
Text=B.Content,
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
Parent=C.UIElements.Main
},{
ak("UIPadding",{
PaddingLeft=UDim.new(0,B.TextPadding/2),
PaddingRight=UDim.new(0,B.TextPadding/2),
PaddingBottom=UDim.new(0,B.TextPadding/2),
})
})
end

local H=ak("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
})

local J=ak("Frame",{
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
local O=an(N.Title,N.Icon,N.Callback,N.Variant,J,C,false)
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

local M=H.AbsoluteContentSize.X/ar.ANUI.UIScale
local N=J.AbsoluteSize.X/ar.ANUI.UIScale

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
local T=S.AbsoluteSize.X/ar.ANUI.UIScale
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

aj.AddSignal(C.UIElements.Main:GetPropertyChangedSignal"AbsoluteSize",CheckButtonsOverflow)
CheckButtonsOverflow()

wait()
C:Open()

return C
end


as:CreateTopbarButton("Close","x",function()
if not as.IgnoreAlerts then
as:SetToTheCenter()
as:Dialog{

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

Callback=function()as:Destroy()end,
Variant="Primary",
}
}
}
else
as:Destroy()
end
end,999)

function as.Tag(z,A)
if as.UIElements.Main.Main.Topbar.Center.Visible==false then as.UIElements.Main.Main.Topbar.Center.Visible=true end
return ap:New(A,as.UIElements.Main.Main.Topbar.Center)
end


local function startResizing(z)
if as.CanResize then
isResizing=true
aw.Active=true
initialSize=as.UIElements.Main.Size
initialInputPosition=z.Position


al(av.ImageLabel,0.1,{ImageTransparency=.35}):Play()

aj.AddSignal(z.Changed,function()
if z.UserInputState==Enum.UserInputState.End then
isResizing=false
aw.Active=false


al(av.ImageLabel,0.17,{ImageTransparency=.8}):Play()
end
end)
end
end

aj.AddSignal(av.InputBegan,function(z)
if z.UserInputType==Enum.UserInputType.MouseButton1 or z.UserInputType==Enum.UserInputType.Touch then
if as.CanResize then
startResizing(z)
end
end
end)

aj.AddSignal(ae.InputChanged,function(z)
if z.UserInputType==Enum.UserInputType.MouseMovement or z.UserInputType==Enum.UserInputType.Touch then
if isResizing and as.CanResize then
local A=z.Position-initialInputPosition
local B=UDim2.new(0,initialSize.X.Offset+A.X*2,0,initialSize.Y.Offset+A.Y*2)

B=UDim2.new(
B.X.Scale,
math.clamp(B.X.Offset,as.MinSize.X,as.MaxSize.X),
B.Y.Scale,
math.clamp(B.Y.Offset,as.MinSize.Y,as.MaxSize.Y)
)

al(as.UIElements.Main,0,{
Size=B
}):Play()

as.Size=B
end
end
end)




local z=0
local A=0.4
local B
local C=0

function onDoubleClick()
as:SetToTheCenter()
end

g.Frame.MouseButton1Up:Connect(function()
local F=tick()
local G=as.Position

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





if not as.HideSearchBar then
local F=a.load'Y'
local G=false





















local H=am("Search","search",as.UIElements.SideBarContainer,true)
H.Size=UDim2.new(1,-as.UIPadding/2,0,39)
H.Position=UDim2.new(0,as.UIPadding/2,0,as.UIPadding/2)

aj.AddSignal(H.MouseButton1Click,function()
if G then return end

F.new(as.TabModule,as.UIElements.Main,function()

G=false
if as.Resizable then
as.CanResize=true
end

al(ax,0.1,{ImageTransparency=1}):Play()
ax.Active=false
end)
al(ax,0.1,{ImageTransparency=.65}):Play()
ax.Active=true

G=true
as.CanResize=false
end)
end




function as.DisableTopbarButtons(F,G)
for H,J in next,G do
for L,M in next,as.TopBarButtons do
if M.Name==J then
M.Object.Visible=false
end
end
end
end

return as
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

local ap=ao.New local aq=
ao.Tween


local ar=a.load'q'


local as=protectgui or(syn and syn.protect_gui)or function()end

local at=gethui and gethui()or(aj or game.Players.LocalPlayer:WaitForChild"PlayerGui")

local au=ap("UIScale",{
Scale=aa.Scale,
})

aa.UIScaleObj=au

aa.ScreenGui=ap("ScreenGui",{
Name="ANUI",
Parent=at,
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
Parent=at,
IgnoreGuiInset=true,
})
aa.DropdownGui=ap("ScreenGui",{
Name="ANUI/Dropdowns",
Parent=at,
IgnoreGuiInset=true,
})
as(aa.ScreenGui)
as(aa.NotificationGui)
as(aa.DropdownGui)

ao.Init(aa)


function aa.SetParent(av,aw)
aa.ScreenGui.Parent=aw
aa.NotificationGui.Parent=aw
aa.DropdownGui.Parent=aw
end
math.clamp(aa.TransparencyValue,0,1)

local av=aa.NotificationModule.Init(aa.NotificationGui)

function aa.Notify(aw,ax)
ax.Holder=av.Frame
ax.Window=aa.Window

return aa.NotificationModule.New(ax)
end

function aa.SetNotificationLower(aw,ax)
av.SetLower(ax)
end

function aa.SetFont(aw,ax)
ao.UpdateFont(ax)
end








function aa.SetImageScaleType(aw,ax,ay)
return ao.SetImageScaleType(ax,ay)
end

function aa.GetImageScaleTypes(aw)
return ao.ImageScaleTypes
end



function aa.SetImageNativeSize(aw,ax,ay)
return ao.SetImageNativeSize(ax,ay)
end

function aa.GetImageNativeSize(aw,ax)
return ao.GetImageNativeSize(ax)
end

function aa.OnThemeChange(aw,ax)
aa.OnThemeChangeFunction=ax
end

function aa.AddTheme(aw,ax)
aa.Themes[ax.Name]=ax
return ax
end

function aa.SetTheme(aw,ax)
if aa.Themes[ax]then
aa.Theme=aa.Themes[ax]
ao.SetTheme(aa.Themes[ax])

if aa.OnThemeChangeFunction then
aa.OnThemeChangeFunction(ax)
end


return aa.Themes[ax]
end
return nil
end

function aa.GetThemes(aw)
return aa.Themes
end
function aa.GetCurrentTheme(aw)
return aa.Theme.Name
end
function aa.GetTransparency(aw)
return aa.Transparent or false
end
function aa.GetWindowSize(aw)
return Window.UIElements.Main.Size
end
function aa.Localization(aw,ax)
return aa.LocalizationModule:New(ax,ao)
end

function aa.SetLanguage(aw,ax)
if ao.Localization then
return ao.SetLanguage(ax)
end
return false
end

function aa.ToggleAcrylic(aw,ax)
if aa.Window and aa.Window.AcrylicPaint and aa.Window.AcrylicPaint.Model then
aa.Window.Acrylic=ax
aa.Window.AcrylicPaint.Model.Transparency=ax and 0.98 or 1
if ax then
ar.Enable()
else
ar.Disable()
end
end
end



function aa.Gradient(aw,ax,ay)
local az={}
local aA={}

for aB,b in next,ax do
local d=tonumber(aB)
if d then
d=math.clamp(d/100,0,1)
table.insert(az,ColorSequenceKeypoint.new(d,b.Color))
table.insert(aA,NumberSequenceKeypoint.new(d,b.Transparency or 0))
end
end

table.sort(az,function(aB,b)return aB.Time<b.Time end)
table.sort(aA,function(aB,b)return aB.Time<b.Time end)


if#az<2 then
error"ColorSequence requires at least 2 keypoints"
end


local aB={
Color=ColorSequence.new(az),
Transparency=NumberSequence.new(aA),
}

if ay then
for b,d in pairs(ay)do
aB[b]=d
end
end

return aB
end


function aa.Popup(aw,ax)
ax.ANUI=aa
return a.load'r'.new(ax)
end


aa.Themes=a.load's'(aa)

ao.Themes=aa.Themes


aa:SetTheme"Dark"
aa:SetLanguage(ao.Language)


function aa.CreateWindow(aw,ax)
local ay=a.load'Z'

if not isfolder"ANUI"then
makefolder"ANUI"
end
if ax.Folder then
makefolder(ax.Folder)
else
makefolder(ax.Title)
end

ax.ANUI=aa
ax.Parent=aa.ScreenGui.Window

if aa.Window then
warn"You cannot create more than one window"
return
end

local az=true

local aA=aa.Themes[ax.Theme or"Dark"]


ao.SetTheme(aA)


local aB=gethwid or function()
return ah.LocalPlayer.UserId
end

local b=aB()

if ax.KeySystem then
az=false

local function loadKeysystem()
am.new(ax,b,function(d)az=d end)
end

local d=(ax.Folder or"Temp").."/"..b..".key"

if ax.KeySystem.KeyValidator then
if ax.KeySystem.SaveKey and isfile(d)then
local e=readfile(d)
local f=ax.KeySystem.KeyValidator(e)

if f then
az=true
else
loadKeysystem()
end
else
loadKeysystem()
end
elseif not ax.KeySystem.API then
if ax.KeySystem.SaveKey and isfile(d)then
local e=readfile(d)
local f=(type(ax.KeySystem.Key)=="table")
and table.find(ax.KeySystem.Key,e)
or tostring(ax.KeySystem.Key)==tostring(e)

if f then
az=true
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

for g,h in next,ax.KeySystem.API do
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

az=f
if not f then loadKeysystem()end
else
loadKeysystem()
end
end

repeat task.wait()until az
end

local d=ay(ax)

aa.Transparent=ax.Transparent
aa.Window=d

if ax.Acrylic then
ar.init()
end













return d
end

return aa