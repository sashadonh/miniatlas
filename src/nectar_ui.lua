-- Nectar V5 / original modern GUI
return function(cfg, engine, save, onClose)
    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    local TS = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer
    local pg=player:WaitForChild("PlayerGui")
    local old=pg:FindFirstChild("NectarV5")
    if old then old:Destroy() end
    local colors={
        bg=Color3.fromRGB(10,11,19),sidebar=Color3.fromRGB(18,18,29),
        surface=Color3.fromRGB(24,23,37),panel=Color3.fromRGB(31,28,46),
        purple=Color3.fromRGB(168,109,248),light=Color3.fromRGB(216,184,255),
        text=Color3.fromRGB(244,241,250),muted=Color3.fromRGB(151,145,166),
        stroke=Color3.fromRGB(59,51,75),green=Color3.fromRGB(112,226,165),
        red=Color3.fromRGB(248,126,142)
    }
    local connections, pageConnections = {}, {}
    local live = true
    local function attach(signal,callback,localPage)
        local c=signal:Connect(callback)
        table.insert(connections,c)
        if localPage then table.insert(pageConnections,c) end
        return c
    end
    local function color(r,g,b) return Color3.fromRGB(r,g,b) end
    local function round(parent,size)
        local x=Instance.new("UICorner")
        x.CornerRadius=UDim.new(0,size or 9)
        x.Parent=parent
    end
    local function border(parent,cl)
        local s=Instance.new("UIStroke")
        s.Color=cl or colors.stroke;s.Thickness=1;s.Parent=parent
    end
    local function fr(parent,size,pos,bg,radius)
        local x=Instance.new("Frame")
        x.Size=size;x.Position=pos;x.BackgroundColor3=bg
        x.BorderSizePixel=0;x.Parent=parent
        if radius then round(x,radius) end
        return x
    end
    local function lbl(parent,str,size,pos,fontsize,clr,bold)
        local l=Instance.new("TextLabel")
        l.Size=size;l.Position=pos;l.Text=str
        l.TextColor3=clr or colors.text;l.TextSize=fontsize or 13
        l.BackgroundTransparency=1
        l.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
        l.TextXAlignment=Enum.TextXAlignment.Left
        l.TextYAlignment=Enum.TextYAlignment.Center
        l.TextTruncate=Enum.TextTruncate.AtEnd
        l.Parent=parent;return l
    end
    local function btn(parent,str,size,pos,bg)
        local b=Instance.new("TextButton")
        b.Size=size;b.Position=pos;b.Text=str
        b.TextColor3=colors.text;b.BackgroundColor3=bg or colors.panel
        b.Font=Enum.Font.GothamMedium;b.TextSize=13
        b.AutoButtonColor=false;b.BorderSizePixel=0
        b.Parent=parent;round(b,8)
        return b
    end
    local function animate(obj,props)
        TS:Create(obj,TweenInfo.new(.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),props):Play()
    end

    local gui=Instance.new("ScreenGui")
    gui.Name="NectarV5";gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=true;gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    gui.Parent=pg

    local main=fr(gui,UDim2.fromOffset(818,523),UDim2.new(.5,-409,.5,-261),
        colors.bg,15)
    main.Active=true;border(main)
    local header=fr(main,UDim2.new(1,0,0,64),UDim2.new(),colors.bg)
    header.BackgroundTransparency=1;header.Active=true
    local iconFrame=fr(header,UDim2.fromOffset(38,38),UDim2.fromOffset(17,13),colors.panel,10)
    local symbol=lbl(iconFrame,"◆",UDim2.fromScale(1,1),UDim2.new(),23,colors.light,true)
    symbol.TextXAlignment=Enum.TextXAlignment.Center
    lbl(header,"Nectar",UDim2.fromOffset(150,25),UDim2.fromOffset(66,10),19,colors.text,true)
    lbl(header,"BEE SWARM  /  INDEPENDENT V5",UDim2.fromOffset(320,20),
        UDim2.fromOffset(67,37),10,colors.muted)
    local minButton=btn(header,"−",UDim2.fromOffset(32,29),UDim2.new(1,-83,0,17))
    local exitButton=btn(header,"×",UDim2.fromOffset(32,29),UDim2.new(1,-44,0,17))
    minButton.TextSize=20;exitButton.TextSize=19
    fr(main,UDim2.new(1,-36,0,1),UDim2.fromOffset(18,63),colors.stroke)
    local left=fr(main,UDim2.fromOffset(186,434),UDim2.fromOffset(13,74),colors.sidebar,11)
    lbl(left,"WORKSPACE",UDim2.fromOffset(158,22),UDim2.fromOffset(15,11),
        10,colors.muted,true)
    local nav=Instance.new("ScrollingFrame")
    nav.Size=UDim2.new(1,-14,1,-87)
    nav.Position=UDim2.fromOffset(7,38)
    nav.BackgroundTransparency=1;nav.BorderSizePixel=0
    nav.ScrollBarThickness=2;nav.ScrollBarImageColor3=colors.purple
    nav.AutomaticCanvasSize=Enum.AutomaticSize.Y;nav.CanvasSize=UDim2.new()
    nav.Parent=left
    local nl=Instance.new("UIListLayout",nav)
    nl.Padding=UDim.new(0,5)
    lbl(left,"●  ENGINE ACTIVE",UDim2.fromOffset(165,20),
        UDim2.new(0,14,1,-29),10,colors.green,true)
    local body=fr(main,UDim2.fromOffset(600,434),UDim2.fromOffset(208,74),
        colors.sidebar,11)
    local pageTitle=lbl(body,"Dashboard",UDim2.fromOffset(335,30),
        UDim2.fromOffset(19,14),20,colors.text,true)
    local subTitle=lbl(body,"Independent Bee Swarm automation",UDim2.fromOffset(370,19),
        UDim2.fromOffset(20,44),11,colors.muted)
    local search=Instance.new("TextBox")
    search.Size=UDim2.fromOffset(175,29)
    search.Position=UDim2.new(1,-191,0,18)
    search.BackgroundColor3=colors.panel;search.BorderSizePixel=0
    search.PlaceholderText="Search controls";search.Text=""
    search.TextColor3=colors.text;search.PlaceholderColor3=colors.muted
    search.Font=Enum.Font.Gotham;search.TextSize=12
    search.ClearTextOnFocus=false;search.Parent=body;round(search,8)

    local content=Instance.new("ScrollingFrame")
    content.Size=UDim2.new(1,-29,1,-116)
    content.Position=UDim2.fromOffset(15,74)
    content.BackgroundTransparency=1;content.BorderSizePixel=0
    content.ScrollBarThickness=3;content.ScrollBarImageColor3=colors.purple
    content.AutomaticCanvasSize=Enum.AutomaticSize.Y
    content.CanvasSize=UDim2.new();content.Parent=body
    local list=Instance.new("UIListLayout",content)
    list.Padding=UDim.new(0,8)
    local contentPadding=Instance.new("UIPadding",content)
    contentPadding.PaddingRight=UDim.new(0,6)
    contentPadding.PaddingTop=UDim.new(0,3)
    contentPadding.PaddingBottom=UDim.new(0,10)
    local footer=lbl(body,"Nectar V5  •  Ready",UDim2.new(1,-34,0,18),
        UDim2.new(0,18,1,-30),10,colors.muted)
    local entries,buttons,pageLabel={},{},"Dashboard"
    local dynamic={}
    local function inform(msg,warn)
        footer.Text=tostring(msg):sub(1,100)
        footer.TextColor3=warn and colors.red or colors.muted
    end
    engine.Notify=inform
    local function applyFilter()
        local query=string.lower(search.Text)
        for _,entry in ipairs(entries) do
            entry.row.Visible=query=="" or string.find(entry.search,query,1,true)~=nil
        end
    end
    local function addEntry(row,name)
        table.insert(entries,{row=row,search=string.lower(name)})
    end
    local function clearPage()
        for _,c in ipairs(pageConnections) do c:Disconnect() end
        pageConnections={}
        for _,o in ipairs(content:GetChildren()) do
            if o:IsA("Frame") or o:IsA("TextButton") or o:IsA("TextLabel") then o:Destroy() end
        end
        entries={};dynamic={}
    end
    local function sec(text)
        local r=fr(content,UDim2.new(1,-3,0,26),UDim2.new(),colors.sidebar)
        r.BackgroundTransparency=1
        lbl(r,string.upper(text),UDim2.new(1,-4,1,0),UDim2.fromOffset(3,0),
            11,colors.light,true)
        addEntry(r,text)
    end
    local function note(title,text,warning)
        local r=fr(content,UDim2.new(1,-3,0,69),UDim2.new(),
            warning and color(48,32,45) or colors.surface,9)
        lbl(r,title,UDim2.new(1,-20,0,22),UDim2.fromOffset(12,7),
            13,warning and colors.red or colors.text,true)
        local desc=lbl(r,text,UDim2.new(1,-22,0,39),UDim2.fromOffset(12,27),
            11,colors.muted)
        desc.TextYAlignment=Enum.TextYAlignment.Top
        desc.TextWrapped=true;desc.TextTruncate=Enum.TextTruncate.None
        addEntry(r,title.." "..text)
    end
    local function togg(title,key,description)
        local r=fr(content,UDim2.new(1,-3,0,description and 58 or 48),UDim2.new(),
            colors.surface,9)
        lbl(r,title,UDim2.new(1,-97,0,23),UDim2.fromOffset(13,description and 6 or 12),
            13,colors.text,true)
        if description then
            lbl(r,description,UDim2.new(1,-100,0,17),
                UDim2.fromOffset(13,32),10,colors.muted)
        end
        local switch=btn(r,"",UDim2.fromOffset(49,25),
            UDim2.new(1,-64,0.5,-12),colors.stroke)
        round(switch,13)
        local bubble=fr(switch,UDim2.fromOffset(19,19),UDim2.fromOffset(3,3),
            colors.text,10)
        local function update()
            animate(switch,{BackgroundColor3=cfg[key] and colors.purple or colors.stroke})
            animate(bubble,{Position=cfg[key] and UDim2.fromOffset(27,3)
                or UDim2.fromOffset(3,3)})
        end
        attach(switch.MouseButton1Click,function()
            cfg[key]=not cfg[key]
            if key=="SpeedBoost" and not cfg[key] then
                local c=player.Character
                local h=c and c:FindFirstChildOfClass("Humanoid")
                if h then h.WalkSpeed=16 end
            end
            if key=="AutoFarm" then engine.ResetRoute() end
            save();update()
        end,true)
        update();addEntry(r,title.." "..(description or ""))
    end
    local function dropdown(title,key,values,description)
        local r=fr(content,UDim2.new(1,-3,0,description and 70 or 53),UDim2.new(),
            colors.surface,9)
        local titleText=lbl(r,title,UDim2.fromOffset(192,21),UDim2.fromOffset(13,10),
            13,colors.text,true)
        if description then
            lbl(r,description,UDim2.fromOffset(190,28),UDim2.fromOffset(13,33),
                10,colors.muted)
        end
        local choose=btn(r,"",UDim2.new(1,-235,0,31),
            UDim2.new(0,219,0,11),colors.panel)
        choose.TextSize=11
        local expanded=false
        local options=Instance.new("ScrollingFrame")
        options.Size=UDim2.new(1,-24,0,0)
        options.Position=UDim2.fromOffset(12,description and 67 or 48)
        options.BackgroundTransparency=1;options.BorderSizePixel=0
        options.ScrollBarThickness=2;options.ScrollBarImageColor3=colors.purple
        options.CanvasSize=UDim2.new(0,0,0,#values*30)
        options.Parent=r
        options.Visible=false
        for i,val in ipairs(values) do
            local option=btn(options,val,UDim2.new(1,-5,0,27),
                UDim2.fromOffset(0,(i-1)*30),
                val==cfg[key] and colors.hover or colors.panel)
            option.TextSize=12
            attach(option.MouseButton1Click,function()
                cfg[key]=val
                choose.Text=val.."  ▾"
                expanded=false;options.Visible=false
                r.Size=UDim2.new(1,-3,0,description and 70 or 53)
                if key=="Field" then engine.ResetRoute() end
                save()
            end,true)
        end
        choose.Text=tostring(cfg[key]).."  ▾"
        attach(choose.MouseButton1Click,function()
            expanded=not expanded
            local extra=math.min(5,#values)*30+5
            options.Size=UDim2.new(1,-24,0,extra)
            options.Visible=expanded
            r.Size=UDim2.new(1,-3,0,
                (description and 70 or 53)+(expanded and extra+3 or 0))
            choose.Text=tostring(cfg[key])..(expanded and "  ▴" or "  ▾")
        end,true)
        addEntry(r,title.." "..table.concat(values," "))
    end
    local function slider(title,key,lower,upper,description)
        local r=fr(content,UDim2.new(1,-3,0,description and 92 or 75),UDim2.new(),
            colors.surface,9)
        lbl(r,title,UDim2.fromOffset(310,22),UDim2.fromOffset(13,8),13,colors.text,true)
        local display=lbl(r,tostring(cfg[key]),UDim2.fromOffset(90,24),
            UDim2.new(1,-106,0,7),17,colors.light,true)
        display.TextXAlignment=Enum.TextXAlignment.Right
        if description then
            lbl(r,description,UDim2.new(1,-24,0,20),
                UDim2.fromOffset(13,33),10,colors.muted)
        end
        local rail=fr(r,UDim2.new(1,-28,0,7),
            UDim2.fromOffset(14,description and 69 or 49),colors.stroke,6)
        rail.Active=true
        local fill=fr(rail,UDim2.fromScale(0,1),UDim2.new(),colors.purple,5)
        local knob=fr(rail,UDim2.fromOffset(16,16),UDim2.fromScale(0,0.5),
            colors.text,10)
        knob.AnchorPoint=Vector2.new(.5,.5);knob.Active=true
        local hold=false
        local function update()
            local ratio=(cfg[key]-lower)/(upper-lower)
            display.Text=tostring(cfg[key])
            fill.Size=UDim2.fromScale(ratio,1)
            knob.Position=UDim2.fromScale(ratio,.5)
        end
        local function change(x)
            local ratio=math.clamp((x-rail.AbsolutePosition.X)/
                math.max(1,rail.AbsoluteSize.X),0,1)
            cfg[key]=math.clamp(math.floor(lower+ratio*(upper-lower)+.5),
                lower,upper)
            update()
            if key=="Radius" then engine.ResetRoute() end
        end
        local function start(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or
                input.UserInputType==Enum.UserInputType.Touch then
                hold=true;change(input.Position.X)
            end
        end
        attach(rail.InputBegan,start,true)
        attach(knob.InputBegan,start,true)
        attach(UIS.InputChanged,function(input)
            if hold and (input.UserInputType==Enum.UserInputType.MouseMovement or
                input.UserInputType==Enum.UserInputType.Touch) then
                change(input.Position.X)
            end
        end,true)
        attach(UIS.InputEnded,function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or
                input.UserInputType==Enum.UserInputType.Touch then
                if hold then save() end
                hold=false
            end
        end,true)
        update();addEntry(r,title.." "..(description or ""))
    end
    local function action(title,fn,description,danger)
        local height=description and 67 or 49
        local r=fr(content,UDim2.new(1,-3,0,height),UDim2.new(),colors.surface,9)
        local b=btn(r,title,UDim2.new(1,-25,0,33),UDim2.fromOffset(12,description and 8 or 8),
            danger and color(68,35,54) or colors.panel)
        if description then
            lbl(r,description,UDim2.new(1,-26,0,17),
                UDim2.fromOffset(13,44),10,colors.muted)
        end
        attach(b.MouseButton1Click,function()
            local ok,err=pcall(fn)
            if not ok then inform("Error: "..tostring(err),true) end
        end,true)
        addEntry(r,title.." "..(description or ""))
    end
    local function statusCard()
        local r=fr(content,UDim2.new(1,-3,0,125),UDim2.new(),colors.surface,11)
        border(r)
        lbl(r,"LIVE FARM STATUS",UDim2.fromOffset(300,22),
            UDim2.fromOffset(14,10),11,colors.light,true)
        local mode=lbl(r,"Idle",UDim2.new(1,-28,0,24),
            UDim2.fromOffset(14,38),16,colors.text,true)
        local line=fr(r,UDim2.new(1,-29,0,7),UDim2.fromOffset(14,75),colors.stroke,5)
        local fill=fr(line,UDim2.fromScale(0,1),UDim2.new(),colors.purple,5)
        local stats=lbl(r,"Pollen: detecting...  |  Digs: 0",UDim2.new(1,-29,0,20),
            UDim2.fromOffset(14,91),11,colors.muted)
        table.insert(dynamic,function()
            mode.Text=engine.mode
            local pct=engine.percent
            fill.Size=UDim2.fromScale(pct and math.clamp(pct/100,0,1) or 0,1)
            stats.Text=string.format("Pollen: %s / %s   |   Digs: %d   |   Input: %s",
                tostring(math.floor(engine.pollen or 0)),
                engine.capacity and engine.capacity>0 and tostring(math.floor(engine.capacity)) or "?",
                engine.digs or 0,engine.digMethod or "None")
        end)
        addEntry(r,"Status pollen farming")
    end
    local fields={
        "Sunflower Field","Dandelion Field","Mushroom Field","Blue Flower Field",
        "Clover Field","Spider Field","Strawberry Field","Bamboo Field",
        "Pineapple Patch","Pumpkin Patch","Cactus Field","Pine Tree Forest",
        "Rose Field","Mountain Top Field","Coconut Field","Pepper Patch","Stump Field"
    }
    local npcs={"Black Bear","Brown Bear","Mother Bear","Panda Bear","Science Bear","Polar Bear",
        "Bucko Bee","Riley Bee","Spirit Bear","Honey Bee"}
    local toys={"Wealth Clock","Blueberry Dispenser","Strawberry Dispenser",
        "Royal Jelly Dispenser","Glue Dispenser","Treat Dispenser","Field Booster",
        "Blue Field Booster","Red Field Booster","Wind Shrine","Sticker Stacker"}
    local tabs={
        {"Dashboard","⌂"},{"Farming","✿"},{"Collection","◇"},{"Combat","⚔"},
        {"Quests","▤"},{"Sprouts","✦"},{"Planters","▱"},
        {"Toys","▣"},{"Settings","⚙"},{"Debug","⌘"}
    }
    local show
    show=function(page)
        pageLabel=page
        clearPage()
        pageTitle.Text=page
        subTitle.Text="Nectar V5 • own script, no external Atlas"
        search.Text=""
        if page=="Dashboard" then
            statusCard()
            sec("Quick start")
            togg("Autofarm","AutoFarm","Automatically digs and walks selected field")
            togg("Auto Tokens","AutoTokens","Collect nearby token drops")
            togg("Auto Convert Honey","AutoConvert","Return home at bag threshold")
            action("STOP ALL FEATURES",function()
                engine.StopAll();save();show("Dashboard")
            end,nil,true)
            note("Working order","Field movement → Dig → Abilities/tokens → Honey at hive → Field.")
        elseif page=="Farming" then
            sec("Farm controls")
            dropdown("Flower field","Field",fields)
            togg("Auto Farm","AutoFarm","Automatically activates collector input")
            togg("Auto Dig","AutoDig","Collect pollen even without Auto Farm")
            togg("Auto Sprinkler","AutoSprinkler","Attempts to activate a sprinkler Tool")
            dropdown("Farm pattern","Pattern",{"Zigzag","Spiral","Circle","Random"})
            dropdown("Movement","Movement",{"Direct","Pathfinding"})
            slider("Field radius","Radius",7,35)
            slider("Change position after (s)","MoveDelay",3,20)
            sec("Collector")
            dropdown("Dig method","DigMethod",{"Auto","ClickEvent","Tool","Mouse"})
            slider("Dig interval (x0.1 s)","DigTenths",2,15,
                "Smaller value makes the tool click more often")
            note("Troubleshooting","If pollen stays at 0, try ClickEvent, Tool or Mouse manually; watch Debug.")
        elseif page=="Collection" then
            sec("Token collection")
            togg("Auto Tokens","AutoTokens","Priority over field walking, only nearby field tokens")
            slider("Token pickup radius","TokenRadius",15,120)
            togg("Ignore honey tokens","IgnoreHoney","Skips obvious honey tokens by name")
            sec("Hive conversion")
            togg("Auto Convert Honey","AutoConvert","Uses pollen meter and owned hive")
            slider("Convert at capacity %","ConvertPercent",60,100)
            note("Convert requirements","Claim your hive first. Uses CoreStats.Pollen, progress meter and hive command.")
        elseif page=="Combat" then
            sec("Monster helper")
            togg("Auto Approach Mobs","AutoMobs","Approach matching monster; bees do damage")
            dropdown("Mob target","Mob",{"Any","Ladybug","Rhino Beetle","Spider",
                "Mantis","Werewolf","Scorpion","Windy Bee","Vicious Bee","Stump Snail"})
            note("Boss fights","No invincibility or instant kills. Boss-specific tactics need more in-game testing.")
        elseif page=="Quests" then
            sec("Quest helper")
            dropdown("NPC","NPC",npcs)
            togg("Talk to NPC automatically","QuestAssist","Visits selected bear; attempts NPC prompt")
            note("Automatic completion","Collect/mob tasks are completed by the game while farming. Reading and planning every quest objective is not implemented.")
        elseif page=="Sprouts" then
            sec("Special targets (experimental)")
            note("Requires Auto Farm","These options scan visible game objects and prioritize matches over ordinary flower patterns.")
            togg("Farm Sprouts","FarmSprouts","Looks for visible sprout objects")
            togg("Farm Puffshrooms","FarmPuffs","Looks for visible puffshroom objects")
            togg("Farm Bubbles","FarmBubbles","Looks for bubble objects in selected field")
            togg("Farm Coconuts","FarmCoconuts","Looks for coconut markers")
            togg("Farm Precise","FarmPrecise","Looks for precise/crosshair markers")
            togg("Farm Fires","FarmFires","Looks for flames and fire objects")
            togg("Farm Leaves","FarmLeaves","Looks for leaf collectibles")
            togg("Farm Clouds","FarmClouds","Looks for visible cloud objects")
        elseif page=="Planters" then
            sec("Planter management")
            note("Coming after game validation","Planting and harvesting require validating live planter inventory and placement events. This version does not claim automatic planters are working.",true)
            action("Inspect visible planter models",function()
                local folders={"Planters","PlanterModels"}
                local results={}
                for _,name in ipairs(folders) do
                    local f=workspace:FindFirstChild(name)
                    table.insert(results,name..": "..(f and #f:GetChildren() or 0))
                end
                inform(table.concat(results," | "))
            end)
        elseif page=="Toys" then
            sec("Toy assistant")
            dropdown("Selected toy","Toy",toys)
            togg("Auto Visit/Activate Toy","AutoToys","Attempts visible prompts/click detectors")
            slider("Toy cooldown (seconds)","ToyCooldown",60,900)
            note("Toys","Not all BSS toys use prompts. If an interaction is not exposed, this cannot force it.")
        elseif page=="Settings" then
            sec("Movement")
            togg("Speed Boost","SpeedBoost","Local WalkSpeed; game may override")
            slider("WalkSpeed","Speed",16,200)
            sec("Preferences")
            action("Save settings",function()
                inform(save() and "Saved" or "Executor lacks writefile",false)
            end)
            action("Restore settings",function()
                for k,v in pairs(engine.Defaults) do cfg[k]=v end
                engine.StopAll();save();show("Settings")
            end,nil,true)
            note("Hotkeys","RightShift shows/hides menu. Drag the header to reposition.")
        elseif page=="Debug" then
            sec("Live diagnostics")
            statusCard()
            action("Run BSS compatibility check",function()
                inform(engine.Diagnostics())
            end)
            action("Force reset farm route",function()
                engine.ResetRoute()
                inform("Route reset")
            end)
            note("Compatibility","This is a standalone script. Executor APIs and current BSS map layout may differ.")
            note("Support","If pollen does not increase, send Debug output and a screenshot of your equipped collector.")
        end
        applyFilter()
    end
    local navButtons={}
    for _,item in ipairs(tabs) do
        local name=item[1]
        local b=btn(nav,item[2].."   "..name,UDim2.new(1,-5,0,32),UDim2.new(),colors.sidebar)
        b.TextXAlignment=Enum.TextXAlignment.Left;b.TextSize=12;b.TextColor3=colors.muted
        table.insert(navButtons,{name=name,button=b})
        attach(b.MouseButton1Click,function()
            for _,entry in ipairs(navButtons) do
                animate(entry.button,{BackgroundColor3=entry.name==name and colors.panel or colors.sidebar,
                    TextColor3=entry.name==name and colors.light or colors.muted})
            end
            show(name)
        end)
    end
    attach(search:GetPropertyChangedSignal("Text"),applyFilter)
    local moving=false
    local mouseDown,beginPos
    attach(header.InputBegan,function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            moving=true;mouseDown=input.Position;beginPos=main.Position
        end
    end)
    attach(UIS.InputChanged,function(input)
        if moving and input.UserInputType==Enum.UserInputType.MouseMovement then
            local delta=input.Position-mouseDown
            main.Position=UDim2.new(beginPos.X.Scale,beginPos.X.Offset+delta.X,
                beginPos.Y.Scale,beginPos.Y.Offset+delta.Y)
        end
    end)
    attach(UIS.InputEnded,function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then moving=false end
    end)
    local minimized=false
    attach(minButton.MouseButton1Click,function()
        minimized=not minimized
        left.Visible=not minimized;body.Visible=not minimized
        animate(main,{Size=minimized and UDim2.fromOffset(818,64) or UDim2.fromOffset(818,523)})
        minButton.Text=minimized and "+" or "−"
    end)
    attach(UIS.InputBegan,function(input,processed)
        if not processed and input.KeyCode==Enum.KeyCode.RightShift then
            main.Visible=not main.Visible
        end
    end)
    local function closeUI()
        if not live then return end
        live=false
        for _,c in ipairs(connections) do c:Disconnect() end
        gui:Destroy()
        onClose()
    end
    attach(exitButton.MouseButton1Click,closeUI)
    for _,entry in ipairs(navButtons) do
        if entry.name=="Dashboard" then
            entry.button.BackgroundColor3=colors.panel
            entry.button.TextColor3=colors.light
        end
    end
    show("Dashboard")
    task.spawn(function()
        while live do
            task.wait(.65)
            if not live then break end
            for _,draw in ipairs(dynamic) do pcall(draw) end
        end
    end)
    return {Destroy=closeUI,Notify=inform,Show=show}
end