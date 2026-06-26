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
                                if dist < Settings.FarmRadius and dist > 8 then
                                    TweenTo(flower.Position)
                                    task.wait(Settings.TweenSpeed * 0.8)
                                    break
                                end
                            end
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
                VirtualInputManager:SendKeyEvent(true, "E", false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, "E", false, game)
            end

            if Settings.AutoQuest then
                pcall(function()
                    ReplicatedStorage.Events.ClaimQuest:FireServer()
                end)
            end
        end)
        task.wait(0.3)
    end
end)
