-- === MINI ATLAS BSS v2.5 (Anti-Cache + Atlas Style) ===
print("🚀 Запуск MiniAtlas v2.5...")

-- Мощная очистка старого GUI
local player = game.Players.LocalPlayer
for _, gui in pairs(player:WaitForChild("PlayerGui"):GetChildren()) do
    if gui.Name:find("MiniAtlas") or gui.Name:find("Atlas") then
        gui:Destroy()
    end
end

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")

-- Загрузка с анти-кэшем
local repo = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/"
local nc = "?nocache=" .. os.time()

loadstring(game:HttpGet(repo .. "settings.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "utils.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "ui.lua" .. nc, true))()

print("✅ MiniAtlas v2.5 загружен!")
