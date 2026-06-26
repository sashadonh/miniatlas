-- === MINI ATLAS FULL v3.3 by sashadonh ===
print("🚀 Запуск Mini Atlas v3.3...")

local player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Все функции ВЫКЛЮЧЕНЫ по умолчанию
_G.Settings = {
    AutoFarm = false,
    AutoCollect = false,
    AutoSprinkler = false,
    AutoDig = false,
    AutoQuest = false,
    SelectedField = "Sunflower Field",
    TweenSpeed = 0.7,
    FarmRadius = 50,
}

-- Загрузка модулей
local repo = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/"
local nc = "?nocache=" .. os.time()

loadstring(game:HttpGet(repo .. "ui.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "utils.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "farm.lua" .. nc, true))()

print("✅ Mini Atlas v3.3 загружен! Все функции выключены по умолчанию.")
