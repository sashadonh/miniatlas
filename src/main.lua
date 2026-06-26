-- === MINI ATLAS FULL CLONE v3.0 ===
print("🚀 Запуск Mini Atlas Full Clone...")

local player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")

Settings = Settings or {
    AutoFarm = true,
    AutoCollect = true,
    AutoSprinkler = true,
    AutoDig = true,
    AutoQuest = true,
    AutoPlanters = false,
    SelectedField = "Sunflower Field",
    TweenSpeed = 0.65,
    FarmRadius = 45,
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/ui.lua", true))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/utils.lua", true))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/farm.lua", true))()

print("✅ Mini Atlas Full Clone загружен! Проверяй GUI.")
