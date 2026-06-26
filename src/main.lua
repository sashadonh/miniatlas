-- === MINI ATLAS BSS v2 by sashadonh ===
print("🚀 Запуск MiniAtlas v2...")

local player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Загрузка модулей
loadstring(game:HttpGet("https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/settings.lua", true))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/utils.lua", true))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/ui.lua", true))()

-- Улучшенный фарм
spawn(function()
    while true do
        pcall(function()
            if not Settings.AutoFarm then 
                wait(1) 
                return 
            end

            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end

            -- Фарм поля
            local zone = Workspace:FindFirstChild("FlowerZones") and Workspace.FlowerZones:FindFirstChild(Settings.SelectedField)
            if zone then
                for _, flower in pairs(zone:GetChildren()) do
                    if flower:FindFirstChild("Flower") then
                        local dist = (flower.Position - root.Position).Magnitude
                        if dist < Settings.FarmRadius then
                            TweenTo(flower.Position)
                            wait(Settings.CollectDelay)
                            break
                        end
                    end
                end
            end

            -- Автосбор токенов
            if Settings.AutoCollect then
                local token = GetNearestToken()
                if token then
                    TweenTo(token.Position)
                    wait(0.1)
                end
            end

            -- Автоспринклер
            if Settings.AutoSprinkler then
                local sprinkler = player.Backpack:FindFirstChild("Sprinkler") or player.Character:FindFirstChild("Sprinkler")
                if sprinkler then sprinkler:Activate() end
            end

            -- Автодиг (E)
            if Settings.AutoDig then
                VirtualInputManager:SendKeyEvent(true, "E", false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, "E", false, game)
            end

            -- Автоквест
            if Settings.AutoQuest then
                pcall(function()
                    ReplicatedStorage.Events.ClaimQuest:FireServer()
                end)
            end
        end)
        task.wait(0.4)
    end
end)

print("✅ MiniAtlas v2 успешно загружен!")
