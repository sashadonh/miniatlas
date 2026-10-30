-- Nectar V5 - own code, self-hosted at sashadonh/miniatlas
-- Only modules in this repository are downloaded.
local Players=game:GetService("Players")
local Http=game:GetService("HttpService")
local player=Players.LocalPlayer
local env=(getgenv and getgenv()) or _G
if type(env.NectarCleanup)=="function" then
    pcall(env.NectarCleanup)
end
local base="https://raw.githubusercontent.com/sashadonh/miniatlas/main/"
local function module(path)
    local body=game:HttpGet(base..path,true)
    local chunk,err=loadstring(body)
    assert(chunk,err)
    return chunk()
end

local defaults={["AutoFarm"]=false, ["AutoDig"]=false, ["AutoTokens"]=false, ["AutoConvert"]=false, ["AutoSprinkler"]=false, ["AutoMobs"]=false, ["QuestAssist"]=false, ["AutoToys"]=false, ["SpeedBoost"]=false, ["IgnoreHoney"]=false, ["FarmSprouts"]=false, ["FarmPuffs"]=false, ["FarmBubbles"]=false, ["FarmCoconuts"]=false, ["FarmPrecise"]=false, ["FarmFires"]=false, ["FarmLeaves"]=false, ["FarmClouds"]=false, ["Field"]="Sunflower Field", ["Pattern"]="Zigzag", ["Movement"]="Direct", ["DigMethod"]="Auto", ["Radius"]=20, ["MoveDelay"]=7, ["DigTenths"]=4, ["TokenRadius"]=70, ["ConvertPercent"]=95, ["Mob"]="Any", ["NPC"]="Black Bear", ["Toy"]="Wealth Clock", ["ToyCooldown"]=600, ["Speed"]=32}
local cfg={}
for key,value in pairs(defaults) do cfg[key]=value end
local configFile="NectarV5_config.json"
if type(readfile)=="function" and type(isfile)=="function" then
    local ok,saved=pcall(function()
        if isfile(configFile) then
            return Http:JSONDecode(readfile(configFile))
        end
    end)
    if ok and type(saved)=="table" then
        for key,value in pairs(defaults) do
            if type(saved[key])==type(value) then
                cfg[key]=saved[key]
            end
        end
    end
end
-- Safety: never start automation automatically just because a saved config was enabled.
for key,value in pairs(defaults) do
    if type(value)=="boolean" then cfg[key]=false end
end
local function save()
    if type(writefile)~="function" then return false end
    return pcall(function()
        writefile(configFile,Http:JSONEncode(cfg))
    end)
end
local buildEngine=module("src/nectar_engine.lua")
local buildUI=module("src/nectar_ui.lua")
assert(type(buildEngine)=="function","Nectar engine failed to load")
assert(type(buildUI)=="function","Nectar UI failed to load")
local ui
local engine=buildEngine(cfg,function(message,warning)
    if ui then ui.Notify(message,warning) end
end)
engine.Defaults=defaults
local cleanup
ui=buildUI(cfg,engine,save,function()
    engine.Destroy()
    if env.NectarCleanup==cleanup then env.NectarCleanup=nil end
end)
cleanup=function()
    if ui then ui.Destroy() end
end
env.NectarCleanup=cleanup
print("Nectar V5 loaded • original code, no external scripts")
