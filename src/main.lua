-- === MINI ATLAS BSS v2.4 (Atlas Style) ===
print("🚀 Запуск MiniAtlas Atlas Style...")

local player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")

local repo = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/"
local nc = "?t=" .. os.time()

loadstring(game:HttpGet(repo .. "settings.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "utils.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "ui.lua" .. nc, true))()

print("✅ MiniAtlas Atlas Style загружен!")
