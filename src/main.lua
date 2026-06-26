-- === MINI ATLAS BSS v2.3 by sashadonh ===
print("🚀 Запуск MiniAtlas v2.3...")

local player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")

-- Загружаем модули с анти-кэшем
local repo = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/"
local nc = "?t=" .. os.time()

loadstring(game:HttpGet(repo .. "settings.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "utils.lua" .. nc, true))()
loadstring(game:HttpGet(repo .. "ui.lua" .. nc, true))()

print("✅ Все модули загружены")

-- Основной цикл
spawn(function()
    while true do
        pcall(function()
            if Settings.AutoFarm then
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local zone = Workspace:FindFirstChild("FlowerZones") and Workspace.FlowerZones:FindFirstChild(Settings.SelectedField)
                    if zone then
                        for _, flower in pairs(zone:GetChildren()) do
                            if flower:FindFirstChild("Flower") then
                                local dist = (flower.Position - root.Position).Magnitude
                                if dist < Settings.FarmRadius and dist > 6 then
                                    TweenTo(flower.Position)
                                    task.wait(Settings.CollectDelay)
                                    break
                                end
                            end
                        end
                    end

                    if Settings.AutoCollect then
                        local token = GetNearestToken()
                        if token then TweenTo(token.Position) end
                    end

                    if Settings.AutoSprinkler then
                        local tool = player.Backpack:FindFirstChild("Sprinkler") or player.Character:FindFirstChild("Sprinkler")
                        if tool then tool:Activate() end
                    end

                    if Settings.AutoDig then
                        VirtualInput:SendKeyEvent(true, "E", false, game)
                        task.wait(0.08)
                        VirtualInput:SendKeyEvent(false, "E", false, game)
                    end
                end
            end

            if Settings.AutoQuest then
                pcall(function()
                    ReplicatedStorage.Events.ClaimQuest:FireServer()
                end)
            end
        end)
        task.wait(0.35)
    end
end)

print("✅ MiniAtlas v2.3 полностью загружен!")
