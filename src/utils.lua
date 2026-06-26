local TweenService = game:GetService("TweenService")

function TweenTo(pos)
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local tweenInfo = TweenInfo.new(_G.Settings.TweenSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(pos + Vector3.new(0, 6, 0))})
    tween:Play()
    tween.Completed:Wait()
end

function GetNearestToken()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, dist = nil, math.huge
    local folder = Workspace:FindFirstChild("Collectibles")
    if not folder then return nil end
    for _, v in pairs(folder:GetChildren()) do
        if v and v.Parent and (v:FindFirstChild("Sparkles") or v.Name:find("Token")) then
            local d = (v.Position - root.Position).Magnitude
            if d < dist and d < 120 then
                dist = d
                closest = v
            end
        end
    end
    return closest
end
