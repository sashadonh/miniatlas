spawn(function()
    while true do
        pcall(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then task.wait(1) return end

            -- Auto Farm
            if _G.Settings.AutoFarm then
                local zone = Workspace:FindFirstChild("FlowerZones") and Workspace.FlowerZones:FindFirstChild(_G.Settings.SelectedField)
                if zone then
                    local bestFlower = nil
                    local bestDist = math.huge

                    for _, flower in pairs(zone:GetChildren()) do
                        if flower:FindFirstChild("Flower") then
                            local dist = (flower.Position - root.Position).Magnitude
                            if dist < _G.Settings.FarmRadius and dist < bestDist then
                                bestDist = dist
                                bestFlower = flower
                            end
                        end
                    end

                    if bestFlower then
                        TweenTo(bestFlower.Position)
                        task.wait(0.1)
                    end
                end
            end

            -- Auto Collect
            if _G.Settings.AutoCollect then
                local token = GetNearestToken()
                if token then
                    TweenTo(token.Position)
                    task.wait(0.08)
                end
            end

            -- Auto Sprinkler
            if _G.Settings.AutoSprinkler then
                local tool = player.Backpack:FindFirstChild("Sprinkler") or player.Character:FindFirstChild("Sprinkler")
                if tool then tool:Activate() end
            end

            -- Auto Dig
            if _G.Settings.AutoDig then
                VirtualInputManager:SendKeyEvent(true, "E", false, game)
                task.wait(0.07)
                VirtualInputManager:SendKeyEvent(false, "E", false, game)
            end

            -- Auto Quest
            if _G.Settings.AutoQuest then
                pcall(function()
                    ReplicatedStorage.Events.ClaimQuest:FireServer()
                end)
            end
        end)
        task.wait(0.2)
    end
end)
