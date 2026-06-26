-- === MINI ATLAS FULL v3.4 - FIXED AUTO FARM ===
print("🚀 Запуск Mini Atlas v3.4 (Fixed Auto Farm)...")

local player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

_G.Settings = {
    AutoFarm = false,
    AutoCollect = false,
    AutoSprinkler = false,
    AutoDig = false,
    AutoQuest = false,
    SelectedField = "Sunflower Field",
    TweenSpeed = 0.55,      -- быстрее и плавнее
    FarmRadius = 60,
}

local repo = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/"
local nc = "?nocache=" .. os.time()

loadstring(game:HttpGet(repo .. "ui.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "utils.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "farm.lua" .. nc, true))()

print("✅ v3.4 Fixed | Все функции выключены")
