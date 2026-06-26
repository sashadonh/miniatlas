local player = game.Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiniAtlas_Atlas"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 360, 0, 580)
Main.Position = UDim2.new(0.68, 0, 0.08, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

-- Top Bar как в Atlas
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
TopBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = " MINI ATLAS"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(80, 180, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.Parent = TopBar

local y = 55

local function CreateToggle(name, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 48)
    btn.Position = UDim2.new(0.04, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.Parent = Main

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0.3, 0, 1, 0)
    status.Position = UDim2.new(0.65, 0, 0, 0)
    status.BackgroundTransparency = 1
    status.Text = Settings[key] and "ON" or "OFF"
    status.TextColor3 = Settings[key] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 80, 80)
    status.Font = Enum.Font.GothamBold
    status.Parent = btn

    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        status.Text = Settings[key] and "ON" or "OFF"
        status.TextColor3 = Settings[key] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 80, 80)
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(30, 50, 40) or Color3.fromRGB(25, 25, 45)
    end)
    y = y + 55
end

CreateToggle("Auto Farm", "AutoFarm")
CreateToggle("Auto Collect", "AutoCollect")
CreateToggle("Auto Sprinkler", "AutoSprinkler")
CreateToggle("Auto Dig (E)", "AutoDig")
CreateToggle("Auto Quest", "AutoQuest")

print("🎨 Atlas-style GUI v2.5 загружен")
