-- Nectar Speed Edition V6 | Cyber Violet
-- Original GUI and client-side movement control; no anti-cheat bypass.
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")
local env=(getgenv and getgenv()) or _G
if type(env.NectarCleanup)=="function" then pcall(env.NectarCleanup) end
local old=pg:FindFirstChild("NectarGlassV11")
if old then old:Destroy() end

local C={
 bg=Color3.fromRGB(10,9,20),
 side=Color3.fromRGB(17,14,29),
 card=Color3.fromRGB(26,20,42),
 raised=Color3.fromRGB(35,25,56),
 violet=Color3.fromRGB(164,82,255),
 light=Color3.fromRGB(211,161,255),
 white=Color3.fromRGB(255,250,255),
 muted=Color3.fromRGB(204,190,227),
 line=Color3.fromRGB(78,49,105),
 green=Color3.fromRGB(96,218,158)
}
local alive=true
local enabled=false
local speed=75
local original=16
local connections={}
local function on(signal,callback)
 local conn=signal:Connect(callback)
 table.insert(connections,conn)
 return conn
end
local function radius(obj,r)
 local c=Instance.new("UICorner")
 c.CornerRadius=UDim.new(0,r or 10)
 c.Parent=obj
end
local function border(obj,col,thick,transparency)
 local st=Instance.new("UIStroke")
 st.Color=col or C.line
 st.Thickness=thick or 1
 st.Transparency=transparency or 0
 st.Parent=obj
 return st
end
local function frame(parent,size,pos,col,r)
 local f=Instance.new("Frame")
 f.Size=size;f.Position=pos
 f.BackgroundColor3=col
 f.BorderSizePixel=0
 f.Parent=parent
 if r then radius(f,r) end
 return f
end
local function text(parent,content,size,pos,fontsize,color,bold,alpha)
 local l=Instance.new("TextLabel")
 l.Size=size;l.Position=pos;l.Text=content
 l.Font=bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
 l.TextStrokeColor3=Color3.fromRGB(8,6,18)
 l.TextStrokeTransparency=.62
 l.TextSize=fontsize
 l.TextColor3=color or C.white
 l.TextTransparency=math.min(alpha or 0,.10)
 l.BackgroundTransparency=1
 l.TextXAlignment=Enum.TextXAlignment.Left
 l.Parent=parent
 return l
end
local function button(parent,content,size,pos,color)
 local b=Instance.new("TextButton")
 b.Text=content
 b.Size=size;b.Position=pos
 b.BackgroundColor3=color or C.card
 b.TextColor3=C.white
 b.Font=Enum.Font.GothamBold
 b.TextStrokeColor3=Color3.fromRGB(8,6,18)
 b.TextStrokeTransparency=.82
 b.TextSize=13
 b.AutoButtonColor=false
 b.BorderSizePixel=0
 b.Parent=parent
 radius(b,9)
 return b
end
local function animate(obj,props,duration)
 TweenService:Create(obj,TweenInfo.new(duration or .2,
    Enum.EasingStyle.Quint,Enum.EasingDirection.Out),props):Play()
end
local function humanoid()
 local character=player.Character
 return character and character:FindFirstChildOfClass("Humanoid")
end
local function apply()
 local h=humanoid()
 if h then h.WalkSpeed=enabled and speed or original end
end

local gui=Instance.new("ScreenGui")
gui.Name="NectarGlassV9"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Parent=pg

local shadow=frame(gui,UDim2.fromOffset(618,375),
 UDim2.new(.5,-309,.5,-187),C.violet,18)
shadow.BackgroundTransparency=.91
local main=frame(shadow,UDim2.fromOffset(612,369),UDim2.fromOffset(3,3),C.bg,16)
main.Active=true
main.ClipsDescendants=true
border(main,C.violet,1.2,.19)

-- Transparent glass only. No artwork or external images.
main.BackgroundTransparency=.42
local glassTint=Instance.new("UIGradient")
glassTint.Color=ColorSequence.new({
 ColorSequenceKeypoint.new(0,Color3.fromRGB(19,13,32)),
 ColorSequenceKeypoint.new(1,Color3.fromRGB(35,20,54))
})
glassTint.Rotation=35
glassTint.Parent=main
local header=frame(main,UDim2.new(1,0,0,62),UDim2.new(),C.bg)
header.BackgroundTransparency=.37;header.Active=true
header.ZIndex=5
local emblem=frame(header,UDim2.fromOffset(39,39),UDim2.fromOffset(17,12),C.raised,11)
local em=text(emblem,"◆",UDim2.fromScale(1,1),UDim2.new(),24,C.light,true)
em.TextXAlignment=Enum.TextXAlignment.Center
local headline=text(header,"NECTAR / GLASS V11",UDim2.fromOffset(300,27),UDim2.fromOffset(66,8),18,C.light,true)
headline.Font=Enum.Font.SciFi
text(header,"CYBER VIOLET  •  V11.0",UDim2.fromOffset(280,15),
 UDim2.fromOffset(67,34),10,C.muted,false,.12)
local btnMin=button(header,"−",UDim2.fromOffset(31,29),
 UDim2.new(1,-78,0,15),C.card)
btnMin.ZIndex=8
local btnClose=button(header,"×",UDim2.fromOffset(31,29),
 UDim2.new(1,-41,0,15),C.card)
btnClose.ZIndex=8
btnMin.TextSize=20;btnClose.TextSize=19
frame(main,UDim2.new(1,-34,0,1),UDim2.fromOffset(17,61),C.line)

local sidebar=frame(main,UDim2.fromOffset(171,267),
 UDim2.fromOffset(13,73),C.side,12)
sidebar.BackgroundTransparency=.29
sidebar.ZIndex=5
border(sidebar,C.light,1,.77)
text(sidebar,"WORKSPACE",UDim2.fromOffset(140,18),
 UDim2.fromOffset(13,14),10,C.muted,true,.2)
-- Vector-like interface icons, drawn with Roblox Frames (no emoji fonts)
local navSpeed=button(sidebar,"",UDim2.fromOffset(149,43),
 UDim2.fromOffset(11,46),C.raised)
navSpeed.BackgroundTransparency=.07
navSpeed.ZIndex=7
local navSettings=button(sidebar,"",UDim2.fromOffset(149,43),
 UDim2.fromOffset(11,96),C.side)
navSettings.BackgroundTransparency=.12
navSettings.ZIndex=7

local speedTitle=text(navSpeed,"Speed",UDim2.fromOffset(100,28),
 UDim2.fromOffset(42,7),14,C.white,true)
speedTitle.ZIndex=9
local settingsTitle=text(navSettings,"Settings",UDim2.fromOffset(100,28),
 UDim2.fromOffset(42,7),14,C.muted,true)
settingsTitle.ZIndex=9

local function iconBar(parent,w,h,x,y,rotation,color)
 local bar=frame(parent,UDim2.fromOffset(w,h),UDim2.fromOffset(x,y),color,2)
 bar.Rotation=rotation
 bar.ZIndex=9
 return bar
end
-- Speed: twin racing slashes
local speedMarkA=iconBar(navSpeed,5,22,19,10,32,C.light)
local speedMarkB=iconBar(navSpeed,5,17,27,13,32,C.violet)
-- Settings: adjustments icon, consistent with the Cyber Violet theme
local settingLines={}
local settingDots={}
for i=1,3 do
 local y=12+(i-1)*9
 settingLines[i]=iconBar(navSettings,21,2,15,y,0,C.muted)
 local dot=frame(navSettings,UDim2.fromOffset(6,6),
  UDim2.fromOffset((i==2 and 21 or 28),y-2),C.light,3)
 dot.ZIndex=10
 settingDots[i]=dot
end
text(sidebar,"●  UI READY",UDim2.fromOffset(140,20),
 UDim2.fromOffset(13,234),10,C.green,true,.1)

local panel=frame(main,UDim2.fromOffset(402,267),
 UDim2.fromOffset(196,73),C.side,12)
panel.BackgroundTransparency=.29
panel.ZIndex=5
border(panel,C.light,1,.77)
local speedPage=frame(panel,UDim2.fromScale(1,1),UDim2.new(),C.side)
speedPage.BackgroundTransparency=1
speedPage.ZIndex=7
local settingsPage=frame(panel,UDim2.fromScale(1,1),UDim2.new(),C.side)
settingsPage.BackgroundTransparency=1
settingsPage.ZIndex=7
settingsPage.Visible=false

text(speedPage,"Movement",UDim2.fromOffset(280,28),
 UDim2.fromOffset(18,14),19,C.white,true)
text(speedPage,"Control your walking speed",UDim2.fromOffset(330,18),
 UDim2.fromOffset(19,42),11,C.muted,false,.15)

local card=frame(speedPage,UDim2.fromOffset(365,130),
 UDim2.fromOffset(18,73),C.card,12)
card.BackgroundTransparency=.24
card.ZIndex=7
border(card,C.light,1,.80)
border(card,C.line,1,.47)
text(card,"WALK SPEED",UDim2.fromOffset(174,19),
 UDim2.fromOffset(15,13),11,C.muted,true,.1)
local value=text(card,"75",UDim2.fromOffset(138,46),
 UDim2.fromOffset(15,34),33,C.light,true)
value.Font=Enum.Font.Code
local units=text(card,"STUDS / SECOND",UDim2.fromOffset(135,21),
 UDim2.fromOffset(216,45),10,C.muted,false,.12)
units.TextXAlignment=Enum.TextXAlignment.Right
local rail=frame(card,UDim2.fromOffset(331,7),
 UDim2.fromOffset(17,104),C.line,7)
rail.Active=true
local fill=frame(rail,UDim2.fromScale(0,1),UDim2.new(),C.violet,7)
local knob=frame(rail,UDim2.fromOffset(17,17),
 UDim2.fromScale(0,.5),C.light,9)
knob.Active=true
knob.AnchorPoint=Vector2.new(.5,.5)
border(knob,C.white,1,.5)

local draggingSlider=false
local function updateSpeed(v)
 speed=math.clamp(math.floor(v+.5),16,200)
 local p=(speed-16)/184
 value.Text=tostring(speed)
 animate(fill,{Size=UDim2.fromScale(p,1)},.09)
 animate(knob,{Position=UDim2.fromScale(p,.5)},.09)
 if enabled then apply() end
end
local function fromX(x)
 local p=math.clamp((x-rail.AbsolutePosition.X)/
 math.max(rail.AbsoluteSize.X,1),0,1)
 updateSpeed(16+184*p)
end
local function sliderStart(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1
 or input.UserInputType==Enum.UserInputType.Touch then
  draggingSlider=true
  fromX(input.Position.X)
 end
end
on(rail.InputBegan,sliderStart)
on(knob.InputBegan,sliderStart)
on(UIS.InputChanged,function(input)
 if draggingSlider and (input.UserInputType==Enum.UserInputType.MouseMovement
 or input.UserInputType==Enum.UserInputType.Touch) then
  fromX(input.Position.X)
 end
end)
on(UIS.InputEnded,function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1
 or input.UserInputType==Enum.UserInputType.Touch then
  draggingSlider=false
 end
end)

local presetHolder=frame(speedPage,UDim2.fromOffset(227,34),
 UDim2.fromOffset(18,216),C.side)
presetHolder.BackgroundTransparency=1
local presets={30,50,100}
local presetButtons={}
for i,preset in ipairs(presets) do
 local b=button(presetHolder,tostring(preset),UDim2.fromOffset(69,33),
 UDim2.fromOffset((i-1)*79,0),C.raised)
 presetButtons[i]=b
 on(b.MouseButton1Click,function()
  updateSpeed(preset)
 end)
end

local switch=button(speedPage,"",UDim2.fromOffset(49,27),
 UDim2.fromOffset(331,219),C.line)
switch.ZIndex=9
radius(switch,16)
local switchDot=frame(switch,UDim2.fromOffset(21,21),
 UDim2.fromOffset(3,3),C.white,11)
switchDot.ZIndex=10
local state=text(speedPage,"OFF",UDim2.fromOffset(42,23),
 UDim2.fromOffset(277,221),12,C.muted,true)
state.ZIndex=9
state.TextXAlignment=Enum.TextXAlignment.Right
local function drawState()
 animate(switch,{BackgroundColor3=enabled and C.violet or C.line})
 animate(switchDot,{Position=enabled
  and UDim2.fromOffset(25,3) or UDim2.fromOffset(3,3)})
 state.Text=enabled and "ON" or "OFF"
 state.TextColor3=enabled and C.green or C.muted
end
on(switch.MouseButton1Click,function()
 if not enabled then
  local h=humanoid()
  if h then original=h.WalkSpeed end
 end
 enabled=not enabled
 apply()
 drawState()
end)

text(settingsPage,"Settings",UDim2.fromOffset(260,31),
 UDim2.fromOffset(20,18),20,C.white,true)
text(settingsPage,"General preferences",UDim2.fromOffset(280,20),
 UDim2.fromOffset(21,51),11,C.muted,false,.15)
local reset=button(settingsPage,"↺   Reset speed to default",
 UDim2.fromOffset(360,43),UDim2.fromOffset(20,87),C.raised)
on(reset.MouseButton1Click,function()
 enabled=false
 apply()
 updateSpeed(16)
 drawState()
end)
local detail=text(settingsPage,
 "RightShift  •  Show / hide interface\n\nTransparent violet glass UI.\nSpeed control is client-side.",
 UDim2.fromOffset(351,115),UDim2.fromOffset(22,153),
 12,C.muted,false,.13)
detail.TextWrapped=true
detail.TextYAlignment=Enum.TextYAlignment.Top

local function showPage(which)
 local isSpeed=which=="Speed"
 speedPage.Visible=isSpeed;settingsPage.Visible=not isSpeed
 animate(navSpeed,{BackgroundColor3=isSpeed and C.raised or C.side,
 TextColor3=isSpeed and C.light or C.muted})
 animate(navSettings,{BackgroundColor3=isSpeed and C.side or C.raised,
 TextColor3=isSpeed and C.muted or C.light})
 speedTitle.TextColor3=isSpeed and C.white or C.muted
 settingsTitle.TextColor3=isSpeed and C.muted or C.white
 for _,bar in ipairs(settingLines) do bar.BackgroundColor3=isSpeed and C.muted or C.light end
end
on(navSpeed.MouseButton1Click,function() showPage("Speed") end)
on(navSettings.MouseButton1Click,function() showPage("Settings") end)

local footer=text(main,"NECTAR  •  LIQUID GLASS V11.0",
 UDim2.fromOffset(290,16),UDim2.fromOffset(20,345),10,C.muted,false,.19)
local status=text(main,"●  GLASS MODE",UDim2.fromOffset(180,16),
 UDim2.fromOffset(420,345),10,C.green,true,.15)
status.TextXAlignment=Enum.TextXAlignment.Right
status.ZIndex=8

local moving=false
local mouseStart,windowStart
on(header.InputBegan,function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 then
  moving=true;mouseStart=input.Position;windowStart=shadow.Position
 end
end)
on(UIS.InputChanged,function(input)
 if moving and input.UserInputType==Enum.UserInputType.MouseMovement then
  local delta=input.Position-mouseStart
  shadow.Position=UDim2.new(windowStart.X.Scale,windowStart.X.Offset+delta.X,
   windowStart.Y.Scale,windowStart.Y.Offset+delta.Y)
 end
end)
on(UIS.InputEnded,function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 then moving=false end
end)
local minimized=false
on(btnMin.MouseButton1Click,function()
 minimized=not minimized
 sidebar.Visible=not minimized
 panel.Visible=not minimized
 footer.Visible=not minimized
 status.Visible=not minimized
 animate(main,{Size=minimized and UDim2.fromOffset(612,62)
  or UDim2.fromOffset(612,369)})
 animate(shadow,{Size=minimized and UDim2.fromOffset(618,68)
  or UDim2.fromOffset(618,375)})
 btnMin.Text=minimized and "+" or "−"
end)
local function cleanup()
 if not alive then return end
 alive=false
 enabled=false
 apply()
 for _,c in ipairs(connections) do c:Disconnect() end
 gui:Destroy()
 if env.NectarCleanup==cleanup then env.NectarCleanup=nil end
end
env.NectarCleanup=cleanup
on(btnClose.MouseButton1Click,cleanup)
on(UIS.InputBegan,function(input,used)
 if not used and input.KeyCode==Enum.KeyCode.RightShift then
  shadow.Visible=not shadow.Visible
 end
end)
on(player.CharacterAdded,function(char)
 local h=char:WaitForChild("Humanoid",10)
 if h and alive then
  original=h.WalkSpeed
  if enabled then apply() end
 end
end)

updateSpeed(75)
drawState()
print("[Nectar] Transparent glass GUI ready")
showPage("Speed")
print("Nectar Liquid Glass V11.0 loaded")
