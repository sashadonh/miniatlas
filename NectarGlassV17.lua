-- Nectar Speed Edition V6 | Cyber Violet
-- Original GUI and client-side movement control; no anti-cheat bypass.
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
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
local speedLock=true
local speedMode="Smart" -- Smart preserves Haste; Fixed keeps a constant WalkSpeed.
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
-- Treat the slider value as a FLOOR, not a fixed cap.
-- If Haste or another in-game buff raises WalkSpeed, leave it alone.
-- Smart: hold a minimum speed and let Haste bonuses raise it.
-- Fixed: maintain the exact chosen WalkSpeed even after a Haste token.
-- When Lock is off, only apply on user input, not every frame.
local function correctSpeed(h)
 if not h or h.Health<=0 or not enabled then return end
 if speedMode=="Fixed" then
  if math.abs(h.WalkSpeed-speed)>.02 then h.WalkSpeed=speed end
 elseif h.WalkSpeed<speed then
  h.WalkSpeed=speed
 end
end
local function apply()
 local h=humanoid()
 if not h then return end
 if not enabled then
  h.WalkSpeed=original
 else
  correctSpeed(h)
 end
end
local speedWatch
local function bindSpeedWatch()
 if speedWatch then speedWatch:Disconnect();speedWatch=nil end
 local h=humanoid()
 if not h then return end
 speedWatch=h:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
  if not alive or not enabled or not speedLock then return end
  correctSpeed(h)
 end)
end
local refreshElapsed=0
on(RunService.Heartbeat,function(dt)
 if not alive or not enabled or not speedLock then return end
 refreshElapsed=refreshElapsed+dt
 if refreshElapsed<0.12 then return end
 refreshElapsed=0
 correctSpeed(humanoid())
end)

local gui=Instance.new("ScreenGui")
gui.Name="NectarGlassV17"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Parent=pg

-- Transparent positioning wrapper: no second rectangular/violet layer at the corners.
local shadow=frame(gui,UDim2.fromOffset(618,375),
 UDim2.new(.5,-309,.5,-187),C.bg,20)
shadow.BackgroundTransparency=1
shadow.ClipsDescendants=false
-- Single rounded surface carries the only outer border.
local main=frame(shadow,UDim2.fromOffset(618,375),
 UDim2.fromOffset(0,0),C.bg,20)
main.Active=true
main.ClipsDescendants=true
border(main,C.violet,1.3,.12)

-- Transparent glass only. No artwork or external images.
main.BackgroundTransparency=.42
local glassTint=Instance.new("UIGradient")
glassTint.Color=ColorSequence.new({
 ColorSequenceKeypoint.new(0,Color3.fromRGB(19,13,32)),
 ColorSequenceKeypoint.new(1,Color3.fromRGB(35,20,54))
})
glassTint.Rotation=35
glassTint.Parent=main
-- No colored header rectangle: UICorner does not round a child's corners.
local header=frame(main,UDim2.new(1,-24,0,54),UDim2.fromOffset(12,7),C.bg)
header.BackgroundTransparency=1;header.Active=true
header.ZIndex=5
local emblem=frame(header,UDim2.fromOffset(39,39),UDim2.fromOffset(17,12),C.raised,11)
local em=text(emblem,"◆",UDim2.fromScale(1,1),UDim2.new(),24,C.light,true)
em.TextXAlignment=Enum.TextXAlignment.Center
local headline=text(header,"NECTAR / GLASS V17",UDim2.fromOffset(300,27),UDim2.fromOffset(66,8),18,C.light,true)
headline.Font=Enum.Font.SciFi
text(header,"CYBER VIOLET  •  V17.0",UDim2.fromOffset(280,15),
 UDim2.fromOffset(67,34),10,C.muted,false,.12)
local btnMin=button(header,"−",UDim2.fromOffset(31,29),
 UDim2.new(1,-78,0,15),C.card)
btnMin.ZIndex=8
local btnClose=button(header,"×",UDim2.fromOffset(31,29),
 UDim2.new(1,-41,0,15),C.card)
btnClose.ZIndex=8
btnMin.TextSize=20;btnClose.TextSize=19
local divider=frame(main,UDim2.new(1,-48,0,1),UDim2.fromOffset(24,61),C.line)
divider.BackgroundTransparency=.45
divider.ZIndex=4

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
 if enabled then bindSpeedWatch() end
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
-- Speed Lock controls
local lockLabel=text(settingsPage,"SPEED LOCK",UDim2.fromOffset(210,20),
 UDim2.fromOffset(21,144),12,C.white,true)
local lockToggle=button(settingsPage,"",UDim2.fromOffset(49,25),
 UDim2.fromOffset(328,140),C.violet)
local lockDot=frame(lockToggle,UDim2.fromOffset(19,19),
 UDim2.fromOffset(27,3),C.white,10)
local lockState=text(settingsPage,"ON",UDim2.fromOffset(72,24),
 UDim2.fromOffset(248,140),12,C.green,true)
lockState.TextXAlignment=Enum.TextXAlignment.Right
local function refreshLock()
 animate(lockToggle,{BackgroundColor3=speedLock and C.violet or C.line})
 animate(lockDot,{Position=speedLock and UDim2.fromOffset(27,3)
  or UDim2.fromOffset(3,3)})
 lockState.Text=speedLock and "ON" or "OFF"
 lockState.TextColor3=speedLock and C.green or C.muted
end
on(lockToggle.MouseButton1Click,function()
 speedLock=not speedLock
 if speedLock then apply() end
 refreshLock()
end)

local modeLabel=text(settingsPage,"LOCK MODE",UDim2.fromOffset(210,20),
 UDim2.fromOffset(21,181),12,C.white,true)
local smartButton=button(settingsPage,"Smart",UDim2.fromOffset(100,31),
 UDim2.fromOffset(168,177),C.violet)
local fixedButton=button(settingsPage,"Fixed",UDim2.fromOffset(100,31),
 UDim2.fromOffset(277,177),C.raised)
local function refreshMode()
 animate(smartButton,{BackgroundColor3=speedMode=="Smart" and C.violet or C.raised})
 animate(fixedButton,{BackgroundColor3=speedMode=="Fixed" and C.violet or C.raised})
end
on(smartButton.MouseButton1Click,function()
 speedMode="Smart"
 refreshMode()
 if enabled and speedLock then apply() end
end)
on(fixedButton.MouseButton1Click,function()
 speedMode="Fixed"
 refreshMode()
 if enabled and speedLock then apply() end
end)
refreshLock()
refreshMode()

local detail=text(settingsPage,
 "Smart: minimum speed, Haste works.  Fixed: exact selected speed.\nRightShift: show/hide. Server restrictions still apply.",
 UDim2.fromOffset(355,51),UDim2.fromOffset(22,220),
 11,C.muted,false,.05)
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

local footer=text(main,"NECTAR  •  LIQUID GLASS V17.0",
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
-- Compact draggable dock, custom Nectar N monogram
local miniShadow=frame(gui,UDim2.fromOffset(64,64),shadow.Position,C.bg,16)
miniShadow.BackgroundTransparency=1
miniShadow.Visible=false
miniShadow.ClipsDescendants=false
local mini=frame(miniShadow,UDim2.fromOffset(64,64),
 UDim2.fromOffset(0,0),C.bg,16)
mini.BackgroundTransparency=.53
border(mini,C.violet,1.5,.25)
local miniGradient=Instance.new("UIGradient")
miniGradient.Color=ColorSequence.new({
 ColorSequenceKeypoint.new(0,Color3.fromRGB(45,23,74)),
 ColorSequenceKeypoint.new(1,Color3.fromRGB(14,10,27))
})
miniGradient.Rotation=45
miniGradient.Transparency=NumberSequence.new({
 NumberSequenceKeypoint.new(0,.15),
 NumberSequenceKeypoint.new(1,.34)
})
miniGradient.Parent=mini
local logoPlate=frame(mini,UDim2.fromOffset(36,36),
 UDim2.fromOffset(12,12),C.raised,10)
logoPlate.BackgroundTransparency=.38
border(logoPlate,C.light,1,.57)
local logoDiamond=frame(logoPlate,UDim2.fromOffset(18,18),
 UDim2.fromOffset(9,9),C.violet,4)
logoDiamond.Rotation=45
logoDiamond.BackgroundTransparency=.12
local logoLetter=text(logoPlate,"N",UDim2.fromScale(1,1),
 UDim2.new(),18,C.white,true)
logoLetter.Font=Enum.Font.SciFi
logoLetter.TextXAlignment=Enum.TextXAlignment.Center
logoLetter.TextYAlignment=Enum.TextYAlignment.Center
logoLetter.ZIndex=3
local miniButton=Instance.new("TextButton")
miniButton.Name="ExpandNectar"
miniButton.Size=UDim2.fromScale(1,1)
miniButton.BackgroundTransparency=1
miniButton.Text=""
miniButton.ZIndex=5
miniButton.Parent=mini

local minimized=false
local wasHidden=false
local miniDragging=false
local miniDragged=false
local miniStartPointer=nil
local miniStartPosition=nil
local miniInputType=nil

local function collapse()
 minimized=true
 miniShadow.Position=shadow.Position
 shadow.Visible=false
 miniShadow.Visible=true
 wasHidden=false
end
local function expand()
 minimized=false
 shadow.Position=miniShadow.Position
 shadow.Visible=true
 miniShadow.Visible=false
 wasHidden=false
end
on(btnMin.MouseButton1Click,collapse)

on(miniButton.InputBegan,function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
  miniDragging=true
  miniDragged=false
  miniStartPointer=input.Position
  miniStartPosition=miniShadow.Position
  miniInputType=input.UserInputType
 end
end)
on(UIS.InputChanged,function(input)
 if not miniDragging or not miniStartPointer then return end
 local matching=(miniInputType==Enum.UserInputType.MouseButton1
    and input.UserInputType==Enum.UserInputType.MouseMovement)
    or (miniInputType==Enum.UserInputType.Touch
    and input.UserInputType==Enum.UserInputType.Touch)
 if not matching then return end
 local delta=input.Position-miniStartPointer
 if delta.Magnitude>6 then miniDragged=true end
 if miniDragged then
  miniShadow.Position=UDim2.new(
   miniStartPosition.X.Scale,miniStartPosition.X.Offset+delta.X,
   miniStartPosition.Y.Scale,miniStartPosition.Y.Offset+delta.Y
  )
 end
end)
on(UIS.InputEnded,function(input)
 if miniDragging and input.UserInputType==miniInputType then
  miniDragging=false
  if not miniDragged then expand() end
 end
end)

local function cleanup()
 if not alive then return end
 alive=false
 enabled=false
 apply()
 if speedWatch then speedWatch:Disconnect();speedWatch=nil end
 for _,c in ipairs(connections) do c:Disconnect() end
 gui:Destroy()
 if env.NectarCleanup==cleanup then env.NectarCleanup=nil end
end
env.NectarCleanup=cleanup
on(btnClose.MouseButton1Click,cleanup)
on(UIS.InputBegan,function(input,used)
 if not used and input.KeyCode==Enum.KeyCode.RightShift then
  if minimized then
   miniShadow.Visible=not miniShadow.Visible
  else
   shadow.Visible=not shadow.Visible
  end
 end
end)
on(player.CharacterAdded,function(char)
 local h=char:WaitForChild("Humanoid",10)
 if h and alive then
  original=h.WalkSpeed
  bindSpeedWatch()
  if enabled then apply() end
 end
end)

bindSpeedWatch()
updateSpeed(75)
drawState()
print("[Nectar] Transparent glass GUI ready")
showPage("Speed")
print("Nectar Liquid Glass V17.0 loaded")
