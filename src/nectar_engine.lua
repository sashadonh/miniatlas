-- Nectar V5 / independent Bee Swarm automation engine
-- No third-party script, no anti-cheat bypass.
return function(cfg, signal)
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RS = game:GetService("ReplicatedStorage")
    local VIM
    pcall(function() VIM = game:GetService("VirtualInputManager") end)
    local PathService = game:GetService("PathfindingService")
    local player = Players.LocalPlayer

    local E = {running = true, mode = "Idle", digMethod = "None", pollen = 0,
               capacity = 0, percent = nil, tokens = 0, digs = 0, converts = 0,
               world = {}, notices = {}, lastTarget = "None"}
    local listeners = {}
    local rng = Random.new()
    local lastMove, lastDig, lastSprinkler, lastNPC, lastToy = 0, 0, 0, 0, 0
    local lastFieldMove = 0
    local lastScan, lastPathCompute, lastStats = 0, 0, 0
    local walkTarget, route, routeIndex = nil, nil, 1
    local fieldStep, scanCache, seenStats = 0, {}, false
    local converting, convertStarted, convertPressed, pollenAtStart = false, 0, 0, 0
    local speedBefore = nil
    local currentObject = nil

    local function info(message, warning)
        E.lastMessage = message
        if signal then pcall(signal, message, warning or false) end
    end
    local function now() return os.clock() end
    local function char() return player.Character end
    local function root()
        local c = char()
        return c and c:FindFirstChild("HumanoidRootPart")
    end
    local function humanoid()
        local c = char()
        return c and c:FindFirstChildOfClass("Humanoid")
    end
    do
        local initialHumanoid=humanoid()
        if initialHumanoid then speedBefore=initialHumanoid.WalkSpeed end
    end
    local function part(obj)
        if not obj then return nil end
        if obj:IsA("BasePart") then return obj end
        if obj:IsA("Attachment") then return obj.Parent:IsA("BasePart") and obj.Parent or nil end
        if obj:IsA("Model") then
            return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
        end
        return obj:FindFirstChildWhichIsA("BasePart", true)
    end
    local function position(v)
        if typeof(v) == "Vector3" then return v end
        if typeof(v) == "CFrame" then return v.Position end
        if typeof(v) == "Instance" then
            if v:IsA("BasePart") then return v.Position end
            if v:IsA("Attachment") then return v.WorldPosition end
            if v:IsA("Vector3Value") or v:IsA("CFrameValue") then
                return position(v.Value)
            end
            if v:IsA("ObjectValue") then return position(v.Value) end
            local p = part(v)
            return p and p.Position or nil
        end
        return nil
    end
    local function distance(v)
        local r = root()
        local p = position(v)
        return (r and p) and (r.Position - p).Magnitude or math.huge
    end
    local function folder(name)
        return Workspace:FindFirstChild(name)
    end
    local function zone()
        local f = folder("FlowerZones")
        return f and f:FindFirstChild(cfg.Field) or nil
    end
    local function fieldCenter()
        local p = part(zone())
        return p and p.Position or nil
    end
    local function inField(p, radius)
        local center = fieldCenter()
        if not center or not p then return true end
        local flat = Vector3.new(center.X, 0, center.Z) - Vector3.new(p.X, 0, p.Z)
        return flat.Magnitude <= (radius or 70)
    end
    local function snapToField(localX, localZ)
        local p = part(zone())
        if not p then return nil end
        local halfX = p.Size.X * 0.45
        local halfZ = p.Size.Z * 0.45
        local x = math.clamp(localX, -halfX, halfX)
        local z = math.clamp(localZ, -halfZ, halfZ)
        return (p.CFrame * CFrame.new(x, p.Size.Y/2 + 2.6, z)).Position
    end
    local function nextFlowerPoint()
        local p = part(zone())
        if not p then return nil end
        fieldStep = fieldStep + 1
        local radius = math.min(cfg.Radius, p.Size.X*.40, p.Size.Z*.40)
        local pattern = cfg.Pattern
        local x,z = 0,0
        if pattern == "Zigzag" then
            local row = math.floor((fieldStep - 1)/6) % 6
            local col = (fieldStep-1)%6
            if row%2==1 then col=5-col end
            x = (col/5*2-1)*radius
            z = (row/5*2-1)*radius
        elseif pattern == "Spiral" then
            local a = fieldStep * 0.72
            local r = ((fieldStep % 18) + 2)/20*radius
            x,z = math.cos(a)*r,math.sin(a)*r
        elseif pattern == "Circle" then
            local a = fieldStep*0.48
            x,z = math.cos(a)*radius,math.sin(a)*radius
        else
            x,z = rng:NextNumber(-radius,radius),rng:NextNumber(-radius,radius)
        end
        return snapToField(x,z)
    end

    -- Pathfinding is only used to reach distant destinations; inside fields use walking.
    local function walk(goal)
        local h,r = humanoid(),root()
        if not h or not r or h.Health <= 0 or not goal then return false end
        local d = (r.Position-goal).Magnitude
        if d < 3.5 then return true end
        local changed = not walkTarget or (walkTarget-goal).Magnitude > 7
        if changed then
            walkTarget,route,routeIndex = goal,nil,1
            lastPathCompute = 0
        end
        if cfg.Movement == "Pathfinding" and d > 30 then
            if not route and now()-lastPathCompute > 3 then
                lastPathCompute = now()
                local ok,result = pcall(function()
                    local path = PathService:CreatePath({
                        AgentRadius = 2.0, AgentHeight = 5,
                        AgentCanJump = true, WaypointSpacing = 8
                    })
                    path:ComputeAsync(r.Position,goal)
                    if path.Status == Enum.PathStatus.Success then
                        return path:GetWaypoints()
                    end
                end)
                if ok and result and #result > 1 then
                    route,routeIndex = result,2
                end
            end
            if route then
                local waypoint = route[routeIndex]
                if waypoint and (r.Position-waypoint.Position).Magnitude < 5 then
                    routeIndex = routeIndex + 1
                    waypoint = route[routeIndex]
                end
                if waypoint then
                    if waypoint.Action == Enum.PathWaypointAction.Jump then h.Jump = true end
                    goal = waypoint.Position
                else
                    route = nil
                end
            end
        end
        if now()-lastMove > 0.37 then
            h:MoveTo(goal)
            lastMove=now()
        end
        return false
    end

    -- The game's collector can expose ClickEvent; Tool:Activate or simulated mouse are fallbacks.
    local function collectorRemote()
        local c=char()
        if not c then return nil end
        for _,obj in ipairs(c:GetDescendants()) do
            if obj.Name=="ClickEvent" and obj:IsA("RemoteEvent") then
                return obj
            end
        end
    end
    local function dig()
        if now()-lastDig < (cfg.DigTenths * 0.1) then return end
        local r = root()
        if not r then return end
        lastDig = now()
        local preferred = cfg.DigMethod
        local remote = collectorRemote()
        if (preferred=="Auto" or preferred=="ClickEvent") and remote then
            local ok = pcall(function() remote:FireServer() end)
            if ok then E.digMethod="ClickEvent"; E.digs=E.digs+1; return end
        end
        local c=char()
        local tool=c and c:FindFirstChildWhichIsA("Tool")
        if not tool then
            local backpack = player:FindFirstChildOfClass("Backpack")
            local available = backpack and backpack:FindFirstChildWhichIsA("Tool")
            local h = humanoid()
            if available and h then
                pcall(function() h:EquipTool(available) end)
                tool=available
            end
        end
        if (preferred=="Auto" or preferred=="Tool") and tool then
            local ok=pcall(function() tool:Activate() end)
            if ok then E.digMethod="Tool"; E.digs=E.digs+1; return end
        end
        if preferred=="Auto" or preferred=="Mouse" then
            local ok=pcall(function()
                assert(VIM, "VirtualInputManager unavailable")
                VIM:SendMouseButtonEvent(0,0,0,true,game,0)
                task.wait(0.05)
                VIM:SendMouseButtonEvent(0,0,0,false,game,0)
            end)
            if ok then E.digMethod="Mouse"; E.digs=E.digs+1; return end
        end
        E.digMethod="Unsupported"
        if not E.warnedDig then
            E.warnedDig = true
            info("Collector input unavailable: try changing Dig Method",true)
        end
    end

    -- BSS exposes CoreStats.Pollen, but capacity can live in the character's ProgressLabel.
    local function parseNumber(v)
        if not v then return nil end
        local s=tostring(v):gsub(",",""):gsub("%s","")
        local number,suffix=s:match("([%d%.]+)([kKmMbBtT]?)")
        number=tonumber(number)
        if not number then return nil end
        local suffixes={k=1e3,m=1e6,b=1e9,t=1e12}
        return number*(suffixes[string.lower(suffix)] or 1)
    end
    local function bagStats()
        local stat=player:FindFirstChild("CoreStats")
        local p=stat and stat:FindFirstChild("Pollen")
        local cap=stat and (stat:FindFirstChild("Capacity") or stat:FindFirstChild("PollenCapacity"))
        local pollen=p and tonumber(p.Value) or nil
        local capacity=cap and tonumber(cap.Value) or nil
        if not capacity or capacity<=0 then
            local ch=char()
            local meter=ch and ch:FindFirstChild("ProgressLabel",true)
            if not meter then
                local screen=player:FindFirstChild("PlayerGui")
                meter=screen and screen:FindFirstChild("ProgressLabel",true)
            end
            if meter and meter:IsA("TextLabel") then
                local left,right=meter.Text:match("([%d,%.]+[kKmMbBtT]?)%s*/%s*([%d,%.]+[kKmMbBtT]?)")
                if right then
                    capacity=parseNumber(right)
                    if not pollen then pollen=parseNumber(left) end
                end
            end
        end
        if pollen then
            E.pollen=pollen
            E.capacity=capacity or 0
            E.percent=capacity and capacity>0 and pollen/capacity*100 or nil
            seenStats=true
        else
            E.percent=nil
        end
        return pollen,capacity,E.percent
    end
    local function ownHive()
        local ref=player:FindFirstChild("Honeycomb")
        if ref and ref:IsA("ObjectValue") and ref.Value then return ref.Value end
        local f=folder("Honeycombs")
        if f then
            for _,obj in ipairs(f:GetChildren()) do
                local owner=obj:FindFirstChild("Owner")
                if owner and owner:IsA("ValueBase") then
                    local val=owner.Value
                    if val==player or tostring(val)==player.Name then return obj end
                end
            end
        end
    end
    local function spawnPos()
        local value=player:FindFirstChild("SpawnPos")
        if value then
            local pos=position(value)
            if pos then return pos end
        end
        local hive=ownHive()
        if hive then
            local sp=hive:FindFirstChild("SpawnPos")
            local pos=position(sp)
            if pos then return pos end
            local platform=hive:FindFirstChild("Platform")
            if platform then return position(platform) end
            return position(hive)
        end
    end
    local function convert()
        local pollen=E.pollen
        if pollen <= 0 then
            if converting then
                E.converts=E.converts+1
                info("Honey conversion completed")
            end
            converting=false
            return false
        end
        if not converting then
            local percent=E.percent
            if not cfg.AutoConvert or not percent or percent<cfg.ConvertPercent then return false end
            if not spawnPos() then
                info("Claim a hive first: cannot convert",true)
                return false
            end
            converting=true
            convertStarted=now()
            convertPressed=0
            pollenAtStart=pollen
            info("Bag full • returning to hive")
        end
        E.mode="Converting honey"
        local target=spawnPos()
        if not target then converting=false;return false end
        if distance(target)>10 then
            walk(target+Vector3.new(0,2,0))
            if now()-convertStarted>120 then converting=false;info("Cannot reach hive",true) end
            return true
        end
        -- Standard BSS hive command; use while close, never when bag is empty.
        if convertPressed==0 or (pollen>=pollenAtStart and now()-convertPressed>12) then
            local events=RS:FindFirstChild("Events")
            local cmd=events and events:FindFirstChild("PlayerHiveCommand")
            if cmd and cmd:IsA("RemoteEvent") then
                local ok=pcall(function() cmd:FireServer("ToggleHoneyMaking") end)
                if ok then
                    convertPressed=now()
                    pollenAtStart=pollen
                    info("Converting at hive")
                end
            else
                if not E.warnedHive then
                    E.warnedHive=true
                    info("PlayerHiveCommand unavailable • conversion unsupported",true)
                end
                converting=false
                return false
            end
        end
        if pollen<10 or (pollenAtStart>0 and pollen<0.001*pollenAtStart) then
            converting=false;E.converts=E.converts+1
            info("Honey converted")
        elseif now()-convertStarted>140 then
            converting=false
            info("Conversion timed out",true)
        end
        return true
    end

    local function visitPrompt(obj)
        if not obj then return false end
        for _,p in ipairs(obj:GetDescendants()) do
            if p:IsA("ProximityPrompt") then
                local target=part(p.Parent)
                if target then
                    if distance(target)>8 then walk(target.Position);return true end
                    if type(fireproximityprompt)=="function" then
                        pcall(function() fireproximityprompt(p) end)
                        return true
                    end
                    local ok=pcall(function()
                        assert(VIM, "VirtualInputManager unavailable")
                        VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game)
                        task.wait(.1)
                        VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game)
                    end)
                    return ok
                end
            elseif p:IsA("ClickDetector") then
                local target=part(p.Parent)
                if target then
                    if distance(target)>12 then walk(target.Position);return true end
                    if type(fireclickdetector)=="function" then
                        pcall(function() fireclickdetector(p) end)
                        return true
                    end
                end
            end
        end
        return false
    end
    local function tokenCandidate(obj)
        local p=part(obj)
        if not p then return nil end
        local name=string.lower(obj.Name)
        if cfg.IgnoreHoney and name:find("honey",1,true) then return nil end
        if obj.Name==player.Name or name:find("token",1,true) or name:find("collect",1,true) or obj:FindFirstChild("Sparkles") then
            return p
        end
        return nil
    end
    local function nearestToken()
        local f=folder("Collectibles")
        if not f then return nil end
        local target,score=nil,cfg.TokenRadius
        for _,obj in ipairs(f:GetChildren()) do
            local p=tokenCandidate(obj)
            if p and inField(p.Position,cfg.Radius+30) then
                local d=distance(p)
                if d<score then target=p;score=d end
            end
        end
        return target
    end
    local function scan(nameSet,fieldOnly,maxRange)
        local r=root()
        if not r then return nil end
        local winner,best=nil,maxRange or 125
        for _,container in ipairs({folder("Particles"),folder("Flowers"),folder("Sprouts"),folder("Puffshrooms"),folder("Monsters"),folder("Balloons")}) do
            if container then
                local entries=container:GetDescendants()
                local scanned=0
                for _,obj in ipairs(entries) do
                    scanned=scanned+1
                    if scanned>3500 then break end
                    if obj:IsA("BasePart") or obj:IsA("Model") then
                        local lowered=string.lower(obj.Name)
                        local matched=false
                        for _,word in ipairs(nameSet) do
                            if lowered:find(word,1,true) then matched=true;break end
                        end
                        if matched then
                            local p=part(obj)
                            if p and (not fieldOnly or inField(p.Position,cfg.Radius+35)) then
                                local d=distance(p)
                                if d<best then winner=p;best=d end
                            end
                        end
                    end
                end
            end
        end
        return winner
    end
    local function matchPriority()
        local tests={
            {cfg.FarmSprouts,{"sprout"},false,"Sprout"},
            {cfg.FarmPuffs,{"puffshroom"},false,"Puffshroom"},
            {cfg.FarmPrecise,{"precise","crosshair"},true,"Precise"},
            {cfg.FarmBubbles,{"bubble"},true,"Bubble"},
            {cfg.FarmCoconuts,{"coconut"},true,"Coconut"},
            {cfg.FarmFires,{"fire","flame"},true,"Fire"},
            {cfg.FarmLeaves,{"leaf"},true,"Leaf"},
            {cfg.FarmClouds,{"cloud"},true,"Cloud"},
        }
        for _,item in ipairs(tests) do
            if item[1] then
                local p=scan(item[2],item[3],120)
                if p then return p,item[4] end
            end
        end
    end
    local function nearestMob()
        local rootPart=root()
        if not rootPart then return nil end
        local target,best=nil,165
        for _,f in ipairs({folder("Monsters"),folder("Mobs")}) do
            if f then
                for _,obj in ipairs(f:GetChildren()) do
                    if obj:IsA("Model") then
                        local n=string.lower(obj.Name)
                        local choice=string.lower(cfg.Mob)
                        if choice=="any" or n:find(choice,1,true) then
                            local p=part(obj)
                            if p then
                                local d=distance(p)
                                if d<best then target=p;best=d end
                            end
                        end
                    end
                end
            end
        end
        return target
    end
    local function sprinkler()
        local h=hum()
        local ch=char()
        if not h or not ch then return end
        local f=player:FindFirstChildOfClass("Backpack")
        local function findTool(container)
            if not container then return nil end
            for _,obj in ipairs(container:GetChildren()) do
                if obj:IsA("Tool") and string.lower(obj.Name):find("sprinkler",1,true) then return obj end
            end
        end
        local tool=findTool(ch) or findTool(f)
        if tool then
            if tool.Parent~=ch then pcall(function() h:EquipTool(tool) end) end
            pcall(function() tool:Activate() end)
        end
    end
    local function quest()
        local npcs=folder("NPCs")
        local chosen=npcs and npcs:FindFirstChild(cfg.NPC)
        if not chosen then
            info("NPC not found: "..cfg.NPC,true)
            return
        end
        local target=part(chosen)
        if target then walk(target.Position) end
        visitPrompt(chosen)
    end
    local function toy()
        local toys=folder("Toys")
        local chosen=toys and toys:FindFirstChild(cfg.Toy)
        if not chosen then info("Toy not found: "..cfg.Toy,true);return end
        local target=part(chosen)
        if target then walk(target.Position) end
        visitPrompt(chosen)
    end
    local function getPollen()
        local stat=player:FindFirstChild("CoreStats")
        local p=stat and stat:FindFirstChild("Pollen")
        return p and tonumber(p.Value) or nil
    end

    local function tick()
        local h=hum()
        if not h or h.Health<=0 or not root() then E.mode="Waiting for character";return end
        if cfg.SpeedBoost and h.WalkSpeed~=cfg.Speed then h.WalkSpeed=cfg.Speed end
        if now()-lastStats>.7 then
            lastStats=now()
            bagStats()
        end
        if convert() then return end
        if cfg.QuestAssist and now()-lastNPC>25 then
            lastNPC=now();E.mode="Quest NPC";quest();return
        end
        if cfg.AutoToys and now()-lastToy>cfg.ToyCooldown then
            lastToy=now();E.mode="Visiting toy";toy();return
        end
        if cfg.AutoMobs then
            local m=nearestMob()
            if m then
                E.mode="Mob: "..cfg.Mob
                if distance(m)>10 then walk(m.Position+Vector3.new(3,0,3)) end
                return
            end
        end
        if cfg.AutoTokens then
            local token=nearestToken()
            if token then
                E.mode="Collecting tokens"
                E.lastTarget=token.Name
                if distance(token)>3 then walk(token.Position) else E.tokens=E.tokens+1 end
                return
            end
        end
        local special,kind
        if now()-lastScan>.8 and cfg.AutoFarm then
            special,kind=matchPriority()
            scanCache={part=special,kind=kind}
            lastScan=now()
        else
            special,kind=scanCache.part,scanCache.kind
        end
        if special and special.Parent and cfg.AutoFarm and distance(special)<120 then
            E.mode="Farming "..(kind or "ability")
            E.lastTarget=kind
            walk(special.Position+Vector3.new(0,1,0))
            return
        end
        if cfg.AutoFarm then
            local f=zone()
            if not f then
                E.mode="Field missing: "..cfg.Field
                if not E.warnedField then
                    E.warnedField=true
                    info("Selected field missing from Workspace.FlowerZones",true)
                end
                return
            end
            local center=fieldCenter()
            if not center then E.mode="Field has no BasePart";return end
            E.mode="Farming "..cfg.Field
            if not currentObject or distance(currentObject)<5 or now()-lastFieldMove>cfg.MoveDelay then
                currentObject=nextFlowerPoint()
                lastFieldMove=now()
            end
            if currentObject then walk(currentObject) end
        else
            E.mode="Idle"
        end
    end
    local errors=0
    local function guard(fn)
        local ok,err=pcall(fn)
        if not ok then
            errors=errors+1
            if errors<5 then info("Engine: "..tostring(err),true) end
        end
    end
    task.spawn(function()
        while E.running do
            task.wait(.48)
            guard(tick)
        end
    end)
    task.spawn(function()
        while E.running do
            task.wait(.08)
            guard(function()
                if cfg.AutoFarm or cfg.AutoDig then
                    if cfg.AutoDig or (cfg.AutoFarm and (inField(root() and root().Position or nil,cfg.Radius+35) or string.find(E.mode,"Farming ",1,true)==1)) then
                        dig()
                    end
                end
                if cfg.AutoSprinkler and cfg.AutoFarm and now()-lastSprinkler>22 and inField(root() and root().Position or nil,cfg.Radius+35) then
                    lastSprinkler=now();sprinkler()
                end
            end)
        end
    end)
    function E.ApplySpeed()
        local h=hum()
        if h then h.WalkSpeed=cfg.SpeedBoost and cfg.Speed or (speedBefore or 16) end
    end
    -- SpeedBoost public entrypoint
    function E.StopAll()
        for _,key in ipairs({"AutoFarm","AutoDig","AutoTokens","AutoConvert","AutoSprinkler","AutoMobs",
            "QuestAssist","AutoToys","FarmBubbles","FarmCoconuts","FarmPrecise","FarmFires",
            "FarmLeaves","FarmClouds","FarmSprouts","FarmPuffs","SpeedBoost"}) do
            cfg[key]=false
        end
        converting=false
        currentObject=nil
        local h=hum()
        if h then h.WalkSpeed=speedBefore or 16 end
        local h,r=hum(),root()
        if h and r then h:MoveTo(r.Position) end
        E.mode="Stopped"
        info("All Nectar functions stopped")
    end
    function E.ResetRoute()
        currentObject=nil
        route=nil
        walkTarget=nil
        E.warnedField=false
    end
    function E.Diagnostics()
        local f=folder("FlowerZones")
        local stat=player:FindFirstChild("CoreStats")
        local c=char()
        local click=collectorRemote()
        local honey=spawnPos()
        local msg={
            "Field: "..tostring(f and (f:FindFirstChild(cfg.Field)~=nil) or false),
            "Pollen: "..tostring(stat and stat:FindFirstChild("Pollen")~=nil or false),
            "Capacity: "..tostring(E.capacity),
            "Collector ClickEvent: "..tostring(click~=nil),
            "Hive/SpawnPos: "..tostring(honey~=nil),
            "Tokens folder: "..tostring(folder("Collectibles")~=nil),
            "Character: "..tostring(c~=nil),
        }
        local result=table.concat(msg," | ")
        info(result)
        return result
    end
    function E.Destroy()
        E.running=false
        E.StopAll()
        for _,c in ipairs(listeners) do c:Disconnect() end
    end
    table.insert(listeners,player.CharacterAdded:Connect(function(c)
        local h=c:WaitForChild("Humanoid",10)
        if h then
            speedBefore=h.WalkSpeed
            if cfg.SpeedBoost then
                h.WalkSpeed=cfg.Speed
            end
        end
        E.ResetRoute()
    end))
    return E
end