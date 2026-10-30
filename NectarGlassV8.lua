-- Nectar Speed Edition V6 | Cyber Violet
-- Original GUI and client-side movement control; no anti-cheat bypass.
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")
local env=(getgenv and getgenv()) or _G
if type(env.NectarCleanup)=="function" then pcall(env.NectarCleanup) end
local old=pg:FindFirstChild("NectarGlassV8")
if old then old:Destroy() end

local C={
 bg=Color3.fromRGB(10,9,20),
 side=Color3.fromRGB(17,14,29),
 card=Color3.fromRGB(26,20,42),
 raised=Color3.fromRGB(35,25,56),
 violet=Color3.fromRGB(164,82,255),
 light=Color3.fromRGB(211,161,255),
 white=Color3.fromRGB(246,241,255),
 muted=Color3.fromRGB(144,129,166),
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
 l.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
 l.TextSize=fontsize
 l.TextColor3=color or C.white
 l.TextTransparency=alpha or 0
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
 b.Font=Enum.Font.GothamMedium
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
gui.Name="NectarGlassV8"
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

-- User-supplied artwork, stored in this repository as base64 JPEG.
-- Custom local assets require executor support; there is no Roblox asset ID.
local artURL="https://raw.githubusercontent.com/sashadonh/miniatlas/main/assets/nectar_character_base64.txt"
local function decodeBase64(input)
 local alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
 input=input:gsub("[^"..alphabet:gsub("%+","%%+").."/=]","")
 local output={}
 local bitBuffer,bitCount=0,0
 for i=1,#input do
  local char=input:sub(i,i)
  if char=="=" then break end
  local n=alphabet:find(char,1,true)
  if n then
   bitBuffer=bitBuffer*64+(n-1)
   bitCount=bitCount+6
   if bitCount>=8 then
    bitCount=bitCount-8
    local div=2^bitCount
    local byte=math.floor(bitBuffer/div)
    output[#output+1]=string.char(byte%256)
    bitBuffer=bitBuffer%div
   end
  end
 end
 return table.concat(output)
end
local animeImage=Instance.new("ImageLabel")
animeImage.Name="CharacterArtwork"
animeImage.BackgroundTransparency=1
animeImage.Size=UDim2.fromOffset(315,425)
animeImage.Position=UDim2.new(1,-293,0,-17)
animeImage.ImageTransparency=.08
animeImage.ImageColor3=Color3.fromRGB(255,246,255)
animeImage.ScaleType=Enum.ScaleType.Fit
animeImage.Visible=true
animeImage.ZIndex=2
animeImage.Parent=main
local artStatus="Loading artwork..."
task.spawn(function()
 local ok,result=pcall(function()
  local assetFn=(type(getcustomasset)=="function" and getcustomasset)
   or (type(getsynasset)=="function" and getsynasset)
  assert(type(assetFn)=="function" and type(writefile)=="function",
   "local custom assets unsupported")
  local encoded=game:HttpGet(artURL.."?cache="..tostring(math.floor(os.clock()*1000000)),true)
  local imageData=decodeBase64(encoded)
  assert(#imageData>1000,"invalid image data")
  local path="nectar_character_v6.jpg"
  writefile(path,imageData)
  return assetFn(path)
 end)
 if ok and alive and animeImage.Parent then
  animeImage.Image=result
  artStatus="Asset assigned, checking render"
  task.spawn(function()
   local deadline=os.clock()+7
   while alive and animeImage.Parent and not animeImage.IsLoaded and os.clock()<deadline do
    task.wait(.2)
   end
   if alive then
    artStatus=animeImage.IsLoaded and "Character loaded" or "Artwork needs local asset support"
   end
  end)
 else
  artStatus="Artwork needs local asset support"
  warn("[Nectar V6] "..tostring(result))
 end
end)
local purpleVeil=frame(main,UDim2.fromScale(1,1),UDim2.new(),Color3.fromRGB(14,8,31),16)
purpleVeil.BackgroundTransparency=.78
purpleVeil.ZIndex=3
local veilGradient=Instance.new("UIGradient")
veilGradient.Transparency=NumberSequence.new({
 NumberSequenceKeypoint.new(0,.2),
 NumberSequenceKeypoint.new(.43,.43),
 NumberSequenceKeypoint.new(1,.72)
})
veilGradient.Parent=purpleVeil
local highlight=frame(main,UDim2.new(1,-35,0,1),UDim2.fromOffset(18,64),
 Color3.fromRGB(186,117,255))
highlight.BackgroundTransparency=.55
highlight.ZIndex=4
-- Noticeable frosted-glass reflections even when the image API is unavailable.
local glassSheen=frame(main,UDim2.fromOffset(255,450),
 UDim2.fromOffset(230,-60),Color3.fromRGB(175,110,255),60)
glassSheen.Rotation=-24
glassSheen.BackgroundTransparency=.90
glassSheen.ZIndex=4
local sheenGradient=Instance.new("UIGradient")
sheenGradient.Transparency=NumberSequence.new({
 NumberSequenceKeypoint.new(0,1),
 NumberSequenceKeypoint.new(.42,.89),
 NumberSequenceKeypoint.new(.5,.65),
 NumberSequenceKeypoint.new(.58,.89),
 NumberSequenceKeypoint.new(1,1)
})
sheenGradient.Parent=glassSheen
local cornerGlow=frame(main,UDim2.fromOffset(220,170),
 UDim2.new(1,-155,0,-85),C.violet,80)
cornerGlow.BackgroundTransparency=.89
cornerGlow.ZIndex=4

local grad=Instance.new("UIGradient")
grad.Color=ColorSequence.new({
 ColorSequenceKeypoint.new(0,C.bg),
 ColorSequenceKeypoint.new(1,Color3.fromRGB(22,12,38))
})
grad.Rotation=38
grad.Parent=main
local header=frame(main,UDim2.new(1,0,0,62),UDim2.new(),C.bg)
header.BackgroundTransparency=.74;header.Active=true
header.ZIndex=5
local emblem=frame(header,UDim2.fromOffset(39,39),UDim2.fromOffset(17,12),C.raised,11)
local em=text(emblem,"◆",UDim2.fromScale(1,1),UDim2.new(),24,C.light,true)
em.TextXAlignment=Enum.TextXAlignment.Center
text(header,"NECTAR  /  GLASS V8.0",UDim2.fromOffset(250,27),UDim2.fromOffset(66,8),18,C.light,true)
text(header,"CYBER VIOLET  •  V8.0",UDim2.fromOffset(280,15),
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
sidebar.BackgroundTransparency=.52
sidebar.ZIndex=5
border(sidebar,C.light,1,.77)
text(sidebar,"WORKSPACE",UDim2.fromOffset(140,18),
 UDim2.fromOffset(13,14),10,C.muted,true,.2)
local navSpeed=button(sidebar,"⚡   Speed",UDim2.fromOffset(149,43),
 UDim2.fromOffset(11,46),C.raised)
navSpeed.BackgroundTransparency=.18
navSpeed.ZIndex=7
local navSettings=button(sidebar,"⚙   Settings",UDim2.fromOffset(149,43),
 UDim2.fromOffset(11,96),C.side)
navSettings.BackgroundTransparency=.25
navSettings.ZIndex=7
navSpeed.TextXAlignment=Enum.TextXAlignment.Left
navSettings.TextXAlignment=Enum.TextXAlignment.Left
text(sidebar,"●  UI READY",UDim2.fromOffset(140,20),
 UDim2.fromOffset(13,234),10,C.green,true,.1)

local panel=frame(main,UDim2.fromOffset(402,267),
 UDim2.fromOffset(196,73),C.side,12)
panel.BackgroundTransparency=.88
panel.ZIndex=5
border(panel,C.light,1,.77)
-- Place character *inside* the frosted content panel, behind its controls.
-- It was previously hidden by higher-layer opaque surfaces.
animeImage.Parent=panel
animeImage.Position=UDim2.fromOffset(72,-55)
animeImage.Size=UDim2.fromOffset(340,390)
animeImage.ZIndex=6
animeImage.ImageTransparency=.05

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
card.BackgroundTransparency=.74
card.ZIndex=7
border(card,C.light,1,.80)
border(card,C.line,1,.47)
text(card,"WALK SPEED",UDim2.fromOffset(174,19),
 UDim2.fromOffset(15,13),11,C.muted,true,.1)
local value=text(card,"75",UDim2.fromOffset(138,46),
 UDim2.fromOffset(15,34),33,C.light,true)
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
radius(switch,16)
local switchDot=frame(switch,UDim2.fromOffset(21,21),
 UDim2.fromOffset(3,3),C.white,11)
local state=text(speedPage,"OFF",UDim2.fromOffset(75,23),
 UDim2.fromOffset(275,222),12,C.muted,true)
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
 "RightShift  •  Show / hide interface\n\nClient-side movement only.\nGame rules can override WalkSpeed.",
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
end
on(navSpeed.MouseButton1Click,function() showPage("Speed") end)
on(navSettings.MouseButton1Click,function() showPage("Settings") end)

local footer=text(main,"NECTAR  •  LIQUID GLASS V8.0",
 UDim2.fromOffset(290,16),UDim2.fromOffset(20,345),10,C.muted,false,.19)
local status=text(main,"●  GLASS V8 ACTIVE",UDim2.fromOffset(200,16),
 UDim2.fromOffset(396,345),10,C.light,true,.15)
status.TextXAlignment=Enum.TextXAlignment.Right
status.ZIndex=8
local function updateArtStatus()
 if artStatus=="Character loaded" then
  status.Text="●  IMAGE RENDERED"
  status.TextColor3=C.green
 elseif artStatus=="Artwork needs local asset support" then
  status.Text="●  IMAGE NOT LOADED"
  status.TextColor3=Color3.fromRGB(247,176,111)
 else
  status.Text="●  LOADING ART"
 end
end
task.spawn(function()
 while alive and (artStatus=="Loading artwork..." or artStatus=="Asset assigned, checking render") do task.wait(.25) end
 if alive then updateArtStatus() end
end)


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
print("[Nectar] Liquid glass artwork loading; "..artStatus)
showPage("Speed")
print("Nectar Liquid Glass V8.0 loaded")
