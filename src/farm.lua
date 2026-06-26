spawn(function()
    while true do
        pcall(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then task.wait(1) return end

            if _G.Settings.AutoFarm then
                local zone = Workspace:FindFirstChild("FlowerZones") and Workspace.FlowerZones:FindFirstChild(_G.Settings.SelectedField)
                if zone then
                    for _, flower in pairs(zone:GetChildren()) do
                        if flower:FindFirstChild("Flower") then
                            local dist = (flower.Position - root.Position).Magnitude
                            if dist < _G.Settings.FarmRadius and dist > 8 then
                                TweenTo(flower.Position)
                                task.wait(0.15)
                                break
                            end
                        end
                    end
                end
            end

            if _G.Settings.AutoCollect then
                local token = GetNearestToken()
                if token then
                    TweenTo(token.Position)
                    task.wait(0.1)
                end
            end

            if _G.Settings.AutoSprinkler then
                local tool = player.Backpack:FindFirstChild("Sprinkler") or player.Character:FindFirstChild("Sprinkler")
                if tool then tool:Activate() end
            end

            if _G.Settings.AutoDig then
                VirtualInputManager:SendKeyEvent(true, "E", false, game)
                task.wait(0.08)
                VirtualInputManager:SendKeyEvent(false, "E", false, game)
            end

            if _G.Settings.AutoQuest then
                pcall(function()
                    ReplicatedStorage.Events.ClaimQuest:FireServer()
                end)
            end
        end)
        task.wait(0.25)
    end
end)
