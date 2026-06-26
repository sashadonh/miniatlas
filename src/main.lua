-- === MINI ATLAS BSS - MAIN ===
print("🚀 Запуск Mini Atlas BSS by sashadonh...")

local player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Загружаем модули
loadstring(game:HttpGet("https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/settings.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/utils.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/sashadonh/miniatlas/main/src/ui.lua"))()

-- Основной цикл
spawn(function()
    while true do
        if Settings.AutoFarm then
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                -- Фарм в выбранном поле
                for _, zone in pairs(Workspace:FindFirstChild("FlowerZones") and Workspace.FlowerZones:GetChildren() or {}) do
                    if zone.Name == Settings.SelectedField then
                        for _, flower in pairs(zone:GetChildren()) do
                            if flower:FindFirstChild("Flower") and (flower.Position - root.Position).Magnitude < Settings.FarmRadius then
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
                        wait(0.15)
                    end
                end

                -- Автоспринклер
                if Settings.AutoSprinkler then
                    local tool = player.Backpack:FindFirstChild("Sprinkler") or player.Character:FindFirstChild("Sprinkler")
                    if tool then tool:Activate() end
                end

                -- Автодиг (E)
                if Settings.AutoDig then
                    pcall(function()
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                        wait(0.08)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
                    end)
                end
            end
        end

        -- Автоквесты
        if Settings.AutoQuest then
            pcall(function()
                ReplicatedStorage.Events.ClaimQuest:FireServer()
            end)
        end

        wait(0.5)
    end
end)

print("✅ Mini Atlas BSS полностью загружен! Удачного фарма 🐝")
