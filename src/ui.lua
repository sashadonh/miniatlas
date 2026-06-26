local player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiniAtlasV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 520)
Main.Position = UDim2.new(0.7, 0, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "Mini Atlas BSS v2"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Main

local y = 60

local function CreateToggle(text, setting)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    btn.Text = text .. ": " .. (Settings[setting] and "ON" or "OFF")
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.Parent = Main

    btn.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        btn.Text = text .. ": " .. (Settings[setting] and "ON" or "OFF")
        btn.BackgroundColor3 = Settings[setting] and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(40, 40, 65)
    end)
    y = y + 60
end

CreateToggle("Auto Farm", "AutoFarm")
CreateToggle("Auto Collect", "AutoCollect")
CreateToggle("Auto Sprinkler", "AutoSprinkler")
CreateToggle("Auto Dig (E)", "AutoDig")
CreateToggle("Auto Quest", "AutoQuest")

-- Поле
local FieldLabel = Instance.new("TextLabel")
FieldLabel.Text = "Поле: " .. Settings.SelectedField
FieldLabel.Size = UDim2.new(0.9, 0, 0, 40)
FieldLabel.Position = UDim2.new(0.05, 0, 0, y + 10)
FieldLabel.BackgroundTransparency = 1
FieldLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
FieldLabel.Font = Enum.Font.Gotham
FieldLabel.TextSize = 15
FieldLabel.Parent = Main

local ChangeField = Instance.new("TextButton")
ChangeField.Text = "Сменить поле"
ChangeField.Size = UDim2.new(0.9, 0, 0, 50)
ChangeField.Position = UDim2.new(0.05, 0, 0, y + 60)
ChangeField.BackgroundColor3 = Color3.fromRGB(70, 70, 110)
ChangeField.TextColor3 = Color3.new(1,1,1)
ChangeField.Font = Enum.Font.GothamBold
ChangeField.Parent = Main

ChangeField.MouseButton1Click:Connect(function()
    local idx = 1
    for i, f in ipairs(Fields) do
        if f == Settings.SelectedField then idx = i end
    end
    idx = (idx % #Fields) + 1
    Settings.SelectedField = Fields[idx]
    FieldLabel.Text = "Поле: " .. Settings.SelectedField
end)

print("🎨 Красивое GUI v2 загружено")
