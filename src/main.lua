-- === MINI ATLAS FULL v3.1 by sashadonh ===
print("🚀 Запуск Mini Atlas Full v3.1...")

local player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Глобальные настройки
Settings = Settings or {
    AutoFarm = true,
    AutoCollect = true,
    AutoSprinkler = true,
    AutoDig = true,
    AutoQuest = true,
    AutoPlanters = false,
    SelectedField = "Sunflower Field",
    TweenSpeed = 0.7,
    FarmRadius = 45,
}

-- Загрузка модулей
local repo = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/"
local nc = "?nocache=" .. os.time()

loadstring(game:HttpGet(repo .. "ui.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "utils.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "farm.lua" .. nc, true))()

print("✅ Mini Atlas Full v3.1 загружен!")
