-- Nectar V4: Atlas-inspired interface, independent helpers + opt-in Atlas
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local WS=game:GetService("Workspace")
local HTTP=game:GetService("HttpService")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")
local env=(getgenv and getgenv()) or _G
if type(env.NectarCleanup)=="function" then pcall(env.NectarCleanup) end
local old=pg:FindFirstChild("NectarV4")
if old then old:Destroy() end
local running=true
local events={}
local pageEvents={}
local function watch(ev,fn)
 local c=ev:Connect(fn)
 table.insert(events,c)
 return c
end
local function watchPage(ev,fn)
 local c=watch(ev,fn)
 table.insert(pageEvents,c)
 return c
end
local function rgb(a,b,c) return Color3.fromRGB(a,b,c) end
local col={
 bg=rgb(12,11,19),side=rgb(19,18,29),card=rgb(28,26,40),
 hover=rgb(49,36,70),line=rgb(60,49,76),purple=rgb(173,114,246),
 light=rgb(225,195,255),white=rgb(241,237,249),
 gray=rgb(157,148,171),green=rgb(101,218,161),orange=rgb(245,174,104)
}
local zones={"Sunflower Field","Dandelion Field","Mushroom Field","Blue Flower Field","Clover Field","Spider Field","Strawberry Field","Bamboo Field","Pineapple Patch","Pumpkin Patch","Cactus Field","Pine Tree Forest","Rose Field","Mountain Top Field","Coconut Field","Pepper Patch","Stump Field"}
local mobs={"Any","Ladybug","Rhino Beetle","Spider","Mantis","Werewolf","Scorpion"}
local npcs={"Black Bear","Brown Bear","Mother Bear","Panda Bear","Science Bear","Polar Bear","Bucko Bee","Riley Bee"}
local default={
 AutoFarm=false,AutoDig=false,AutoTokens=false,AutoConvert=false,
 AutoSprinkler=false,AutoMobs=false,QuestAssist=false,SpeedBoost=false,
 Field=zones[1],Mob="Any",NPC=npcs[1],
 Speed=32,ConvertPercent=95,TokenRadius=70,FarmRadius=20
}
local cfg={}
for k,v in pairs(default) do cfg[k]=v end
if type(readfile)=="function" and type(isfile)=="function" then
 local ok,val=pcall(function()
  if isfile("NectarV4.json") then return HTTP:JSONDecode(readfile("NectarV4.json")) end
 end)
 if ok and type(val)=="table" then
  for k,v in pairs(default) do
   if type(val[k])==type(v) then cfg[k]=val[k] end
  end
 end
end
local function save()
 if type(writefile)~="function" then return false end
 return pcall(function() writefile("NectarV4.json",HTTP:JSONEncode(cfg)) end)
end
local function character()
 return player.Character
end
local function hum()
 local ch=character()
 return ch and ch:FindFirstChildOfClass("Humanoid")
end
local function root()
 local ch=character()
 return ch and ch:FindFirstChild("HumanoidRootPart")
end
local initial=16
local function speedApply()
 local h=hum()
 if h then h.WalkSpeed=cfg.SpeedBoost and cfg.Speed or initial end
end
local gui=Instance.new("ScreenGui")
gui.Name="NectarV4";gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true;gui.Parent=pg
local function corner(o,n)
 local c=Instance.new("UICorner",o)
 c.CornerRadius=UDim.new(0,n or 9)
end
local function frame(par,size,pos,bg,r)
 local f=Instance.new("Frame")
 f.Size=size;f.Position=pos
 f.BorderSizePixel=0;f.BackgroundColor3=bg
 f.Parent=par;if r then corner(f,r) end
 return f
end
local function label(par,str,size,pos,pts,color,bold)
 local l=Instance.new("TextLabel")
 l.Size=size;l.Position=pos;l.Text=str
 l.BackgroundTransparency=1
 l.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
 l.TextColor3=color or col.white;l.TextSize=pts or 13
 l.TextXAlignment=Enum.TextXAlignment.Left
 l.TextTruncate=Enum.TextTruncate.AtEnd
 l.Parent=par;return l
end
local function button(par,str,size,pos,bg)
 local b=Instance.new("TextButton")
 b.Size=size;b.Position=pos;b.Text=str;b.BorderSizePixel=0
 b.TextSize=13;b.Font=Enum.Font.GothamMedium
 b.TextColor3=col.white;b.BackgroundColor3=bg or col.card
 b.AutoButtonColor=false;b.Parent=par;corner(b,8)
 return b
end
local function tween(obj,props)
 TS:Create(obj,TweenInfo.new(.18,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),props):Play()
end
local main=frame(gui,UDim2.fromOffset(790,500),UDim2.new(.5,-395,.5,-250),col.bg,14)
main.Active=true
local border=Instance.new("UIStroke",main)
border.Color=col.line
local header=frame(main,UDim2.new(1,0,0,58),UDim2.new(),col.bg)
header.BackgroundTransparency=1;header.Active=true
local symbol=frame(header,UDim2.fromOffset(35,35),UDim2.fromOffset(15,12),col.hover,9)
local logo=label(symbol,"◆",UDim2.fromScale(1,1),UDim2.new(),24,col.purple,true)
logo.TextXAlignment=Enum.TextXAlignment.Center
label(header,"Nectar",UDim2.fromOffset(175,26),UDim2.fromOffset(60,9),19,col.white,true)
label(header,"ATLAS-STYLE WORKSPACE • V4",UDim2.fromOffset(260,18),UDim2.fromOffset(61,34),10,col.gray)
local btnMin=button(header,"−",UDim2.fromOffset(30,28),UDim2.new(1,-77,0,15),col.card)
local btnClose=button(header,"×",UDim2.fromOffset(30,28),UDim2.new(1,-41,0,15),col.card)
frame(main,UDim2.new(1,-28,0,1),UDim2.fromOffset(14,57),col.line)
local side=frame(main,UDim2.fromOffset(171,423),UDim2.fromOffset(12,66),col.side,10)
label(side,"WORKSPACE",UDim2.fromOffset(145,18),UDim2.fromOffset(11,12),10,col.gray,true)
local nav=Instance.new("ScrollingFrame")
nav.Size=UDim2.new(1,-12,1,-73);nav.Position=UDim2.fromOffset(6,36)
nav.BorderSizePixel=0;nav.BackgroundTransparency=1
nav.ScrollBarThickness=2;nav.ScrollBarImageColor3=col.purple
nav.AutomaticCanvasSize=Enum.AutomaticSize.Y
nav.CanvasSize=UDim2.new();nav.Parent=side
local navFlow=Instance.new("UIListLayout",nav)
navFlow.Padding=UDim.new(0,5)
label(side,"●  READY",UDim2.fromOffset(149,21),UDim2.new(0,11,1,-27),11,col.green,true)
local panel=frame(main,UDim2.fromOffset(587,423),UDim2.fromOffset(193,66),col.side,10)
local title=label(panel,"Home",UDim2.fromOffset(300,30),UDim2.fromOffset(16,13),21,col.white,true)
local subtitle=label(panel,"Independent helpers + Original Atlas",UDim2.fromOffset(430,20),UDim2.fromOffset(17,43),11,col.gray)
local search=Instance.new("TextBox")
search.Size=UDim2.fromOffset(164,29);search.Position=UDim2.new(1,-180,0,15)
search.BackgroundColor3=col.card;search.BorderSizePixel=0
search.PlaceholderText="Search";search.Text="";search.ClearTextOnFocus=false
search.Font=Enum.Font.Gotham;search.TextSize=12
search.TextColor3=col.white;search.PlaceholderColor3=col.gray
search.Parent=panel;corner(search,8)
local scroll=Instance.new("ScrollingFrame")
scroll.Size=UDim2.fromOffset(555,314);scroll.Position=UDim2.fromOffset(16,72)
scroll.BackgroundTransparency=1;scroll.BorderSizePixel=0
scroll.ScrollBarThickness=3;scroll.ScrollBarImageColor3=col.purple
scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
scroll.CanvasSize=UDim2.new();scroll.Parent=panel
local flow=Instance.new("UIListLayout",scroll)
flow.Padding=UDim.new(0,8)
local pad=Instance.new("UIPadding",scroll)
pad.PaddingBottom=UDim.new(0,10);pad.PaddingTop=UDim.new(0,3);pad.PaddingRight=UDim.new(0,4)
local status=label(panel,"Ready; all features off by default",UDim2.fromOffset(550,19),UDim2.fromOffset(17,396),10,col.gray)
local function report(msg,warning)
 status.Text=msg;status.TextColor3=warning and col.orange or col.gray
end
local rows={}
local function rowAdd(r,str)
 table.insert(rows,{r=r,name=string.lower(str)})
end
local function filter()
 local needle=string.lower(search.Text)
 for _,entry in ipairs(rows) do
  entry.r.Visible=(needle=="" or string.find(entry.name,needle,1,true)~=nil)
 end
end
local function clear()
 for _,c in ipairs(pageEvents) do c:Disconnect() end
 pageEvents={}
 for _,c in ipairs(scroll:GetChildren()) do
  if c:IsA("Frame") or c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
 end
 rows={}
end
local function section(name)
 local r=frame(scroll,UDim2.new(1,-4,0,24),UDim2.new(),col.side)
 r.BackgroundTransparency=1
 label(r,string.upper(name),UDim2.new(1,0,1,0),UDim2.fromOffset(4,0),11,col.purple,true)
 rowAdd(r,name)
end
local function note(name,description)
 local r=frame(scroll,UDim2.new(1,-4,0,68),UDim2.new(),col.card,9)
 label(r,name,UDim2.new(1,-24,0,22),UDim2.fromOffset(12,8),13,col.white,true)
 local detail=label(r,description,UDim2.new(1,-24,0,35),UDim2.fromOffset(12,30),11,col.gray)
 detail.TextWrapped=true;detail.TextTruncate=Enum.TextTruncate.None
 detail.TextYAlignment=Enum.TextYAlignment.Top
 rowAdd(r,name.." "..description)
end
local function toggle(name,key,help)
 local r=frame(scroll,UDim2.new(1,-4,0,help and 58 or 46),UDim2.new(),col.card,9)
 label(r,name,UDim2.new(1,-95,0,22),UDim2.fromOffset(12,help and 7 or 12),13,col.white,true)
 if help then
  label(r,help,UDim2.new(1,-95,0,17),UDim2.fromOffset(12,33),10,col.gray)
 end
 local b=button(r,"",UDim2.fromOffset(48,25),UDim2.new(1,-62,.5,-12),col.line)
 corner(b,14)
 local nub=frame(b,UDim2.fromOffset(19,19),UDim2.fromOffset(3,3),col.white,10)
 local function update()
  local on=cfg[key]
  tween(b,{BackgroundColor3=on and col.purple or col.line})
  tween(nub,{Position=on and UDim2.fromOffset(26,3) or UDim2.fromOffset(3,3)})
 end
 watchPage(b.MouseButton1Click,function()
  if key=="SpeedBoost" and not cfg.SpeedBoost then
   local h=hum()
   if h then initial=h.WalkSpeed end
  end
  cfg[key]=not cfg[key]
  if key=="SpeedBoost" then speedApply() end
  update();save()
 end)
 update();rowAdd(r,name.." "..(help or ""))
end
local function choose(name,key,options)
 local r=frame(scroll,UDim2.new(1,-4,0,51),UDim2.new(),col.card,9)
 label(r,name,UDim2.fromOffset(175,28),UDim2.fromOffset(12,11),13,col.white,true)
 local b=button(r,"",UDim2.fromOffset(302,31),UDim2.new(1,-313,0,10),col.hover)
 b.TextSize=12
 local function draw() b.Text=tostring(cfg[key]).."  ▾" end
 draw()
 watchPage(b.MouseButton1Click,function()
  local i=table.find(options,cfg[key]) or 0
  cfg[key]=options[(i%#options)+1]
  draw();save()
 end)
 rowAdd(r,name.." "..table.concat(options," "))
end
local function slider(name,key,lo,hi)
 local r=frame(scroll,UDim2.new(1,-4,0,74),UDim2.new(),col.card,9)
 label(r,name,UDim2.fromOffset(310,25),UDim2.fromOffset(12,7),13,col.white,true)
 local val=label(r,tostring(cfg[key]),UDim2.fromOffset(85,25),UDim2.new(1,-100,0,7),17,col.light,true)
 val.TextXAlignment=Enum.TextXAlignment.Right
 local rail=frame(r,UDim2.new(1,-28,0,6),UDim2.fromOffset(14,49),col.line,6)
 rail.Active=true
 local line=frame(rail,UDim2.fromScale(0,1),UDim2.new(),col.purple,6)
 local nub=frame(rail,UDim2.fromOffset(15,15),UDim2.fromScale(0,.5),col.white,8)
 nub.AnchorPoint=Vector2.new(.5,.5);nub.Active=true
 local hold=false
 local function paint()
  val.Text=tostring(cfg[key])
  local v=(cfg[key]-lo)/(hi-lo)
  line.Size=UDim2.fromScale(v,1);nub.Position=UDim2.fromScale(v,.5)
 end
 local function locate(x)
  local ratio=math.clamp((x-rail.AbsolutePosition.X)/math.max(rail.AbsoluteSize.X,1),0,1)
  cfg[key]=math.clamp(math.floor(lo+ratio*(hi-lo)+.5),lo,hi)
  paint()
  if key=="Speed" and cfg.SpeedBoost then speedApply() end
 end
 local function press(i)
  if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
   hold=true;locate(i.Position.X)
  end
 end
 watchPage(rail.InputBegan,press);watchPage(nub.InputBegan,press)
 watchPage(UIS.InputChanged,function(i)
  if hold and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
   locate(i.Position.X)
  end
 end)
 watchPage(UIS.InputEnded,function(i)
  if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
   if hold then save() end
   hold=false
  end
 end)
 paint();rowAdd(r,name)
end
local function action(name,callback,help)
 local r=frame(scroll,UDim2.new(1,-4,0,help and 63 or 48),UDim2.new(),col.card,9)
 local b=button(r,name,UDim2.new(1,-22,0,32),UDim2.fromOffset(11,help and 7 or 8),col.hover)
 if help then label(r,help,UDim2.new(1,-26,0,17),UDim2.fromOffset(12,42),10,col.gray) end
 watchPage(b.MouseButton1Click,function()
  local ok,err=pcall(callback)
  if not ok then report(tostring(err),true) end
 end)
 rowAdd(r,name.." "..(help or ""))
end
local atlasURL="https://raw.githubusercontent.com/Chris12089/atlasbss/main/script.lua"
local atlasBusy=false
local function originalAtlas()
 if atlasBusy then return end
 atlasBusy=true
 report("Launching external Atlas code (obfuscated by its author)...",true)
 task.spawn(function()
  local ok,err=pcall(function()
   assert(type(loadstring)=="function","loadstring not supported")
   local source=game:HttpGet(atlasURL,true)
   local fn,compileError=loadstring(source)
   assert(fn,compileError)
   fn()
  end)
  atlasBusy=false
  report(ok and "Original Atlas launched in its own GUI" or ("Atlas error: "..tostring(err)),not ok)
 end)
end
local navItems={
 {"Home","⌂"},{"Farming","✿"},{"Collection","◇"},
 {"Combat","⚔"},{"Quests","▤"},{"Planters","▱"},
 {"Toys","▣"},{"RBC","◈"},{"Atlas","★"},{"Config","⚙"}
}
local navBtns={}
local render
render=function(page)
 clear();title.Text=page;search.Text=""
 subtitle.Text=page=="Atlas" and "Official Atlas (external)" or "Independent Nectar controls"
 if page=="Home" then
  section("Overview")
  note("Nectar V4","Atlas-inspired navigation and independent basic helpers. For all advanced Atlas tools use the Atlas tab.")
  note("Compatibility","Best-effort Roblox client helpers. Solara and game support may vary. No ban-protection guarantees.")
  action("Stop all Nectar functions",function()
   for k,v in pairs(default) do if type(v)=="boolean" then cfg[k]=false end end
   speedApply();save();render("Home");report("All Nectar functions disabled")
  end)
  action("Launch Original Atlas",originalAtlas,"Opens the original GUI with advanced features")
 elseif page=="Farming" then
  section("Field farming")
  choose("Selected field","Field",zones)
  toggle("Autofarm","AutoFarm","Move around selected flower field")
  toggle("Auto Dig","AutoDig","Activate equipped collector tool")
  toggle("Auto Sprinkler","AutoSprinkler","Use sprinkler Tool if one is accessible")
  slider("Farm radius","FarmRadius",7,35)
  action("Atlas: advanced farm and sprouts",originalAtlas)
 elseif page=="Collection" then
  section("Collection")
  toggle("Auto Tokens","AutoTokens","Approach nearby collectibles")
  slider("Token range","TokenRadius",15,120)
  toggle("Auto Convert","AutoConvert","Requires detectable bag stats and hive")
  slider("Convert at %","ConvertPercent",60,100)
  note("Conversion","This is only a local attempt using a hive prompt. It cannot force server conversion.")
  action("Atlas: advanced token and honey tools",originalAtlas)
 elseif page=="Combat" then
  section("Mob farming")
  choose("Mob type","Mob",mobs)
  toggle("Auto Approach Mobs","AutoMobs","Walk near matching spawned monster")
  note("Combat","Bees attack normally; this does not defeat bosses automatically.")
  action("Atlas: bosses and timers",originalAtlas)
 elseif page=="Quests" then
  section("Quests")
  choose("Quest NPC","NPC",npcs)
  toggle("Quest NPC Assistant","QuestAssist","Walk to selected NPC; attempt proximity prompt")
  note("Quest progress","This helper does not read objectives or auto-complete quests. Use original Atlas for that.")
  action("Atlas: full quest features",originalAtlas)
 elseif page=="Planters" then
  section("Advanced planters")
  note("Original Atlas planters","Auto plant, auto harvest, nectar configuration and timers require Atlas integration.")
  action("Launch Atlas Planters",originalAtlas)
 elseif page=="Toys" then
  section("Toys and events")
  note("Original Atlas tools","Dispensers, boosters, memory match, Wind Shrine and stickers are handled by Atlas.")
  action("Launch Atlas Toys",originalAtlas)
 elseif page=="RBC" then
  section("Robo Bear Challenge")
  note("Original Atlas RBC","RBC preset, drives, sprouts and puffshrooms require the original Atlas engine.")
  action("Launch Atlas RBC",originalAtlas)
 elseif page=="Atlas" then
  section("Full Atlas features")
  note("Original Atlas by Chris12089","The author's script includes advanced farming, combat, planters, quests, toys and RBC.")
  note("Trust warning","Upstream Lua is obfuscated and cannot be audited. It is downloaded only when you click Launch.")
  action("Launch Original Atlas GUI",originalAtlas,"This opens a second window and does not wire into Nectar toggles")
 elseif page=="Config" then
  section("Movement")
  toggle("Speed Boost","SpeedBoost","Client-only WalkSpeed")
  slider("WalkSpeed","Speed",16,200)
  section("Preferences")
  action("Save preferences",function()
   local ok=save()
   report(ok and "Preferences saved" or "Local file write not available",not ok)
  end)
  action("Reset settings",function()
   for k,v in pairs(default) do cfg[k]=v end
   speedApply();save();render("Config");report("Preferences reset")
  end)
  note("Hotkey","Use RightShift to show/hide the window; drag from its header.")
 end
 filter()
end
local function selectPage(page)
 for name,b in pairs(navBtns) do
  tween(b,{BackgroundColor3=name==page and col.hover or col.side,
   TextColor3=name==page and col.light or col.gray})
 end
 render(page)
end
for _,info in ipairs(navItems) do
 local name=info[1]
 local b=button(nav,info[2].."   "..name,UDim2.new(1,-7,0,31),UDim2.new(),col.side)
 b.TextXAlignment=Enum.TextXAlignment.Left
 b.TextColor3=col.gray;b.TextSize=12
 navBtns[name]=b
 watch(b.MouseButton1Click,function() selectPage(name) end)
end
watch(search:GetPropertyChangedSignal("Text"),filter)
local moving=false
local dragStart,windowStart
watch(header.InputBegan,function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 then
  moving=true;dragStart=i.Position;windowStart=main.Position
 end
end)
watch(UIS.InputChanged,function(i)
 if moving and i.UserInputType==Enum.UserInputType.MouseMovement then
  local d=i.Position-dragStart
  main.Position=UDim2.new(windowStart.X.Scale,windowStart.X.Offset+d.X,windowStart.Y.Scale,windowStart.Y.Offset+d.Y)
 end
end)
watch(UIS.InputEnded,function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 then moving=false end
end)
local small=false
watch(btnMin.MouseButton1Click,function()
 small=not small;side.Visible=not small;panel.Visible=not small
 tween(main,{Size=small and UDim2.fromOffset(790,58) or UDim2.fromOffset(790,500)})
 btnMin.Text=small and "+" or "−"
end)
local function cleanup()
 if not running then return end
 running=false
 for k,v in pairs(default) do if type(v)=="boolean" then cfg[k]=false end end
 speedApply()
 for _,event in ipairs(events) do event:Disconnect() end
 gui:Destroy()
 if env.NectarCleanup==cleanup then env.NectarCleanup=nil end
end
env.NectarCleanup=cleanup
watch(btnClose.MouseButton1Click,cleanup)
watch(UIS.InputBegan,function(i,processed)
 if not processed and i.KeyCode==Enum.KeyCode.RightShift then main.Visible=not main.Visible end
end)
watch(player.CharacterAdded,function(char)
 local h=char:WaitForChild("Humanoid",10)
 if h and running then
  initial=h.WalkSpeed
  if cfg.SpeedBoost then speedApply() end
 end
end)
local function part(obj)
 if not obj then return nil end
 if obj:IsA("BasePart") then return obj end
 if obj:IsA("Model") then return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true) end
end
local function move(pos)
 local h,r=hum(),root()
 if not h or not r or not pos then return false end
 if (r.Position-pos).Magnitude>3 then h:MoveTo(pos) end
 return true
end
local function field()
 local folder=WS:FindFirstChild("FlowerZones")
 return part(folder and folder:FindFirstChild(cfg.Field))
end
local function farm()
 local p=field()
 if not p then report("Field not found: "..cfg.Field,true);return end
 local r=root()
 if not r then return end
 if (r.Position-p.Position).Magnitude>60 then move(p.Position+Vector3.new(0,3,0))
 else
  local a=math.random()*math.pi*2
  local distance=math.random(5,cfg.FarmRadius)
  move(p.Position+Vector3.new(math.cos(a)*distance,2,math.sin(a)*distance))
 end
end
local function tokens()
 local folder=WS:FindFirstChild("Collectibles")
 local r=root()
 if not folder or not r then return false end
 local best,d=nil,cfg.TokenRadius
 local center=field()
 for _,obj in ipairs(folder:GetChildren()) do
  local p=part(obj)
  if p then
   local distance=(p.Position-r.Position).Magnitude
   if distance<d and (not center or (p.Position-center.Position).Magnitude<95) then
    best=p;d=distance
   end
  end
 end
 if best then move(best.Position);return true end
 return false
end
local function dig()
 local ch=character()
 local h=hum()
 if not ch or not h then return end
 local tool=ch:FindFirstChildWhichIsA("Tool")
 if not tool then
  local bag=player:FindFirstChild("Backpack")
  tool=bag and bag:FindFirstChildWhichIsA("Tool")
  if tool then pcall(function() h:EquipTool(tool) end) end
 end
 if tool then pcall(function() tool:Activate() end) end
end
local function sprinkler()
 local h=hum()
 if not h then return end
 local function find(container)
  if not container then return nil end
  for _,obj in ipairs(container:GetChildren()) do
   if obj:IsA("Tool") and string.find(string.lower(obj.Name),"sprinkler",1,true) then return obj end
  end
 end
 local tool=find(character()) or find(player:FindFirstChild("Backpack"))
 if tool then
  if tool.Parent~=character() then pcall(function() h:EquipTool(tool) end) end
  pcall(function() tool:Activate() end)
 else report("Sprinkler tool not accessible",true) end
end
local function percentage()
 for _,name in ipairs({"CoreStats","leaderstats","Stats"}) do
  local f=player:FindFirstChild(name)
  if f then
   local a=f:FindFirstChild("Pollen")
   local b=f:FindFirstChild("Capacity") or f:FindFirstChild("PollenCapacity")
   if a and b and a:IsA("ValueBase") and b:IsA("ValueBase") then
    local ok,p=pcall(function() return tonumber(a.Value)/tonumber(b.Value)*100 end)
    if ok and p and p>=0 and p<=999 then return p end
   end
  end
 end
end
local function hive()
 local folder=WS:FindFirstChild("Honeycombs") or WS:FindFirstChild("Hives")
 if not folder then return nil end
 for _,v in ipairs(folder:GetChildren()) do
  local owner=v:FindFirstChild("Owner",true)
  if owner and owner:IsA("ValueBase") then
   local ok,result=pcall(function() return owner.Value end)
   if ok and (result==player or tostring(result)==player.Name or tostring(result)==tostring(player.UserId)) then return v end
  end
 end
end
local function prompt(obj)
 local r=root()
 if not r or not obj then return false end
 for _,p in ipairs(obj:GetDescendants()) do
  if p:IsA("ProximityPrompt") then
   local target=part(p.Parent)
   if target then
    if (target.Position-r.Position).Magnitude>10 then move(target.Position);return true end
    if type(fireproximityprompt)=="function" then
     pcall(function() fireproximityprompt(p) end)
     return true
    else report("Executor has no proximity prompt helper",true) end
   end
  end
 end
 return false
end
local function convert()
 local p=percentage()
 if not p then report("Cannot read pollen/capacity for auto convert",true);return false end
 if p<cfg.ConvertPercent then return false end
 local h=hive()
 if not h then report("Unable to identify owned hive",true);return false end
 local target=part(h)
 if target then move(target.Position+Vector3.new(0,2,0)) end
 prompt(h)
 return true
end
local function monsters()
 local r=root()
 if not r then return false end
 local chosen,d=nil,165
 for _,name in ipairs({"Monsters","Mobs"}) do
  local f=WS:FindFirstChild(name)
  if f then
   for _,obj in ipairs(f:GetChildren()) do
    local p=part(obj)
    if p and obj:IsA("Model") and (cfg.Mob=="Any" or string.find(string.lower(obj.Name),string.lower(cfg.Mob),1,true)) then
     local dist=(p.Position-r.Position).Magnitude
     if dist<d then chosen=p;d=dist end
    end
   end
  end
 end
 if chosen then
  if d>11 then move(chosen.Position+Vector3.new(3,0,3)) end
  return true
 end
 return false
end
local function quest()
 local folder=WS:FindFirstChild("NPCs")
 local npc=folder and folder:FindFirstChild(cfg.NPC)
 if not npc then report("Quest NPC not found: "..cfg.NPC,true);return end
 local p=part(npc)
 if p then move(p.Position+Vector3.new(0,2,0)) end
 prompt(npc)
end
task.spawn(function()
 while running do
  task.wait(.7)
  if cfg.SpeedBoost then
   local h=hum()
   if h and h.WalkSpeed~=cfg.Speed then speedApply() end
  end
  if cfg.AutoDig then pcall(dig) end
 end
end)
task.spawn(function()
 local count=0
 while running do
  task.wait(2)
  count=count+1
  local ok,err=pcall(function()
   if cfg.AutoConvert and convert() then return end
   if cfg.AutoTokens and tokens() then return end
   if cfg.AutoMobs and monsters() then return end
   if cfg.AutoFarm then farm() end
  end)
  if not ok then report("Automation error: "..tostring(err),true) end
  if count%8==0 then
   if cfg.AutoSprinkler then pcall(sprinkler) end
   if cfg.QuestAssist then pcall(quest) end
  end
 end
end)
selectPage("Home")
report("Ready • independent Nectar helpers / original Atlas optional")
print("Nectar V4 loaded")
