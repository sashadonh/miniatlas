-- Nectar V3 | modern client-side speed UI
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")
local env=getgenv and getgenv() or _G
if type(env.NectarCleanup)=="function" then pcall(env.NectarCleanup) end
local old=pg:FindFirstChild("NectarV3")
if old then old:Destroy() end
local conns={}
local running=true
local enabled=false
local speed=32
local original=16
local function bind(sig,fn)
 local c=sig:Connect(fn)
 table.insert(conns,c)
 return c
end
local colors={
 bg=Color3.fromRGB(12,11,19),panel=Color3.fromRGB(22,19,30),
 elevated=Color3.fromRGB(32,26,43),line=Color3.fromRGB(54,45,68),
 accent=Color3.fromRGB(169,113,245),soft=Color3.fromRGB(54,37,78),
 text=Color3.fromRGB(245,241,252),muted=Color3.fromRGB(158,147,172),
 green=Color3.fromRGB(96,213,157)
}
local function tween(o,props,t)
 TweenService:Create(o,TweenInfo.new(t or .2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),props):Play()
end
local function box(parent,w,h,x,y,color,r)
 local f=Instance.new("Frame")
 f.Size=UDim2.fromOffset(w,h)
 f.Position=UDim2.fromOffset(x,y)
 f.BackgroundColor3=color
 f.BorderSizePixel=0
 f.Parent=parent
 if r then local c=Instance.new("UICorner",f) c.CornerRadius=UDim.new(0,r) end
 return f
end
local function text(parent,s,w,h,x,y,size,color,bold)
 local l=Instance.new("TextLabel")
 l.Size=UDim2.fromOffset(w,h)
 l.Position=UDim2.fromOffset(x,y)
 l.BackgroundTransparency=1
 l.Text=s
 l.TextSize=size
 l.TextColor3=color
 l.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
 l.TextXAlignment=Enum.TextXAlignment.Left
 l.Parent=parent
 return l
end
local function button(parent,s,w,h,x,y,color)
 local b=Instance.new("TextButton")
 b.Size=UDim2.fromOffset(w,h)
 b.Position=UDim2.fromOffset(x,y)
 b.BackgroundColor3=color
 b.BorderSizePixel=0
 b.Text=s
 b.TextSize=13
 b.TextColor3=colors.text
 b.Font=Enum.Font.GothamMedium
 b.AutoButtonColor=false
 b.Parent=parent
 local c=Instance.new("UICorner",b) c.CornerRadius=UDim.new(0,9)
 return b
end
local function hum()
 local ch=player.Character
 return ch and ch:FindFirstChildOfClass("Humanoid")
end
local function apply()
 local h=hum()
 if h then h.WalkSpeed=enabled and speed or original end
end
local gui=Instance.new("ScreenGui")
gui.Name="NectarV3"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.Parent=pg
local main=box(gui,610,405,0,0,colors.bg,16)
main.Position=UDim2.new(.5,-305,.5,-202)
main.Active=true
local edge=Instance.new("UIStroke",main)
edge.Color=colors.line
edge.Thickness=1
local header=box(main,610,68,0,0,colors.bg)
header.BackgroundTransparency=1
header.Active=true
local logo=box(header,39,39,18,14,colors.soft,11)
local mark=text(logo,"◆",39,39,0,0,25,colors.accent,true)
mark.TextXAlignment=Enum.TextXAlignment.Center
text(header,"Nectar",180,25,68,12,19,colors.text,true)
text(header,"BEE SWARM UTILITY",200,17,69,38,10,colors.muted)
local minimize=button(header,"−",30,30,530,19,colors.panel)
local close=button(header,"×",30,30,567,19,colors.panel)
close.TextSize=20
minimize.TextSize=20
local separator=box(main,574,1,18,67,colors.line)
local sidebar=box(main,171,290,17,81,colors.bg)
sidebar.BackgroundTransparency=1
text(sidebar,"WORKSPACE",150,18,8,7,10,colors.muted,true)
local content=box(main,391,290,202,81,colors.bg)
content.BackgroundTransparency=1
local pages={}
for _,name in ipairs({"Movement","Settings","About"}) do
 local p=box(content,391,290,0,0,colors.bg)
 p.BackgroundTransparency=1
 p.Visible=false
 pages[name]=p
end
local navs={}
local function selectPage(name)
 for n,p in pairs(pages) do p.Visible=(n==name) end
 for n,b in pairs(navs) do
  tween(b,{BackgroundColor3=n==name and colors.soft or colors.bg,
   TextColor3=n==name and colors.text or colors.muted})
 end
end
for i,item in ipairs({{"Movement","◈"},{"Settings","⚙"},{"About","ⓘ"}}) do
 local name=item[1]
 local b=button(sidebar,item[2].."   "..name,166,40,0,35+(i-1)*47,colors.bg)
 b.TextXAlignment=Enum.TextXAlignment.Left
 navs[name]=b
 bind(b.MouseButton1Click,function() selectPage(name) end)
end
text(sidebar,"●  READY",150,22,9,260,11,colors.green,true)
local movement=pages.Movement
text(movement,"Movement",300,28,0,0,20,colors.text,true)
text(movement,"Control your walking speed",350,20,0,29,11,colors.muted)
local card=box(movement,389,169,0,59,colors.panel,12)
local stroke=Instance.new("UIStroke",card)
stroke.Color=colors.line
text(card,"Speed boost",220,25,16,13,14,colors.text,true)
local stateText=text(card,"Disabled",200,20,16,37,11,colors.muted)
local switch=button(card,"",49,26,321,18,colors.line)
local dot=box(switch,20,20,3,3,colors.text,10)
box(card,355,1,17,69,colors.line)
text(card,"Walk speed",180,20,16,81,11,colors.muted)
local value=text(card,"32",170,38,16,100,29,colors.text,true)
text(card,"studs/s",80,20,298,111,11,colors.muted)
local track=box(card,355,6,17,150,colors.line,6)
track.Active=true
local fill=box(track,1,6,0,0,colors.accent,6)
local handle=box(track,15,15,0,0,colors.text,8)
handle.AnchorPoint=Vector2.new(.5,.5)
handle.Position=UDim2.fromScale(0,.5)
handle.Active=true
local function setSpeed(v)
 speed=math.clamp(math.floor(v+.5),16,200)
 local ratio=(speed-16)/184
 value.Text=tostring(speed)
 tween(fill,{Size=UDim2.new(ratio,0,1,0)},.08)
 tween(handle,{Position=UDim2.fromScale(ratio,.5)},.08)
 if enabled then apply() end
end
local sliding=false
local function changeAt(x)
 local ratio=math.clamp((x-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1)
 setSpeed(16+ratio*184)
end
local function startSlide(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
  sliding=true
  changeAt(input.Position.X)
 end
end
bind(track.InputBegan,startSlide)
bind(handle.InputBegan,startSlide)
bind(UIS.InputChanged,function(input)
 if sliding and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
  changeAt(input.Position.X)
 end
end)
bind(UIS.InputEnded,function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
  sliding=false
 end
end)
local function updateSwitch()
 tween(switch,{BackgroundColor3=enabled and colors.accent or colors.line})
 tween(dot,{Position=enabled and UDim2.fromOffset(26,3) or UDim2.fromOffset(3,3)})
 stateText.Text=enabled and "Active" or "Disabled"
 stateText.TextColor3=enabled and colors.green or colors.muted
end
bind(switch.MouseButton1Click,function()
 if not enabled then
  local h=hum()
  if h then original=h.WalkSpeed end
 end
 enabled=not enabled
 apply()
 updateSwitch()
end)
for i,preset in ipairs({30,50,100}) do
 local b=button(movement,tostring(preset),122,33,(i-1)*133,239,colors.elevated)
 local s=Instance.new("UIStroke",b)
 s.Color=colors.line
 bind(b.MouseButton1Click,function() setSpeed(preset) end)
end
local reset=button(movement,"↺   Reset to default",389,35,0,280,colors.panel)
bind(reset.MouseButton1Click,function()
 enabled=false
 apply()
 setSpeed(16)
 updateSwitch()
end)
local settings=pages.Settings
text(settings,"Settings",300,30,0,0,20,colors.text,true)
local settingsLabel=text(settings,"RightShift — show / hide menu\n\nSpeed is set locally. The game may override it.\n\nNo anti-cheat bypass.",370,180,0,55,13,colors.muted)
settingsLabel.TextYAlignment=Enum.TextYAlignment.Top
local about=pages.About
text(about,"Nectar",350,40,0,0,24,colors.text,true)
local aboutLabel=text(about,"Version 3.0\n\nMinimal dark interface\nPurple accent theme\nSmooth transitions\nMovement controls",350,190,0,55,13,colors.muted)
aboutLabel.TextYAlignment=Enum.TextYAlignment.Top
local dragging=false
local dragStart
local startPos
bind(header.InputBegan,function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 then
  dragging=true
  dragStart=input.Position
  startPos=main.Position
 end
end)
bind(UIS.InputChanged,function(input)
 if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
  local d=input.Position-dragStart
  main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
 end
end)
bind(UIS.InputEnded,function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)
local minimized=false
bind(minimize.MouseButton1Click,function()
 minimized=not minimized
 sidebar.Visible=not minimized
 content.Visible=not minimized
 separator.Visible=not minimized
 tween(main,{Size=minimized and UDim2.fromOffset(610,67) or UDim2.fromOffset(610,405)})
 minimize.Text=minimized and "+" or "−"
end)
local function cleanup()
 if not running then return end
 running=false
 enabled=false
 apply()
 for _,c in ipairs(conns) do c:Disconnect() end
 gui:Destroy()
end
env.NectarCleanup=cleanup
bind(close.MouseButton1Click,cleanup)
bind(UIS.InputBegan,function(input,processed)
 if not processed and input.KeyCode==Enum.KeyCode.RightShift then
  main.Visible=not main.Visible
 end
end)
bind(player.CharacterAdded,function(ch)
 local h=ch:WaitForChild("Humanoid",10)
 if h and running then
  original=h.WalkSpeed
  if enabled then apply() end
 end
end)
selectPage("Movement")
setSpeed(32)
updateSwitch()
print("Nectar V3 ready")
