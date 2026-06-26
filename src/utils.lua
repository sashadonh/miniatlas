local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

function TweenTo(pos)
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local tweenInfo = TweenInfo.new(Settings.TweenSpeed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))})
    tween:Play()
    tween.Completed:Wait()
end

function GetNearestToken()
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local closest, dist = nil, math.huge
    local collectibles = Workspace:FindFirstChild("Collectibles")
    if not collectibles then return nil end
    
    for _, token in pairs(collectibles:GetChildren()) do
        if token:FindFirstChild("Sparkles") or token.Name:find("Token") then
            local d = (token.Position - root.Position).Magnitude
            if d < dist and d < 80 then
                dist = d
                closest = token
            end
        end
    end
    return closest
end

print("🔧 Утилиты MiniAtlas загружены")
