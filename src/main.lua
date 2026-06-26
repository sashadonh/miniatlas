-- === MINI ATLAS FULL v3.2 - FIXED ===
print("🚀 Запуск Mini Atlas v3.2 (Fixed)...")

local player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Глобальные настройки
_G.Settings = {
    AutoFarm = true,
    AutoCollect = true,
    AutoSprinkler = true,
    AutoDig = true,
    AutoQuest = true,
    SelectedField = "Sunflower Field",
    TweenSpeed = 0.65,
    FarmRadius = 50,
}

-- Загрузка модулей
local repo = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/"
local nc = "?nocache=" .. os.time()

loadstring(game:HttpGet(repo .. "ui.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "utils.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "farm.lua" .. nc, true))()

print("✅ Mini Atlas v3.2 Fixed загружен!")
