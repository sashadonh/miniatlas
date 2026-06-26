local player = game.Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiniAtlasGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 290, 0, 460)
Frame.Position = UDim2.new(0.72, 0, 0.15, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "Mini Atlas BSS"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
Title.Parent = Frame

local y = 55
local function AddToggle(name, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 42)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 75)
    btn.Text = name .. ": " .. (Settings[key] and "ON" or "OFF")
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = Frame
    
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = name .. ": " .. (Settings[key] and "ON" or "OFF")
    end)
    y = y + 50
end

AddToggle("Auto Farm", "AutoFarm")
AddToggle("Auto Quest", "AutoQuest")
AddToggle("Auto Collect", "AutoCollect")
AddToggle("Auto Sprinkler", "AutoSprinkler")
AddToggle("Auto Dig", "AutoDig")

-- Выбор поля
local FieldLabel = Instance.new("TextLabel")
FieldLabel.Text = "Поле: " .. Settings.SelectedField
FieldLabel.Size = UDim2.new(0.9, 0, 0, 35)
FieldLabel.Position = UDim2.new(0.05, 0, 0, y + 10)
FieldLabel.BackgroundTransparency = 1
FieldLabel.TextColor3 = Color3.new(1, 0.9, 0.6)
FieldLabel.Parent = Frame

local FieldBtn = Instance.new("TextButton")
FieldBtn.Text = "Сменить поле"
FieldBtn.Size = UDim2.new(0.9, 0, 0, 45)
FieldBtn.Position = UDim2.new(0.05, 0, 0, y + 55)
FieldBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
FieldBtn.Parent = Frame

FieldBtn.MouseButton1Click:Connect(function()
    local idx = 1
    for i, f in ipairs(Fields) do
        if f == Settings.SelectedField then idx = i break end
    end
    idx = idx % #Fields + 1
    Settings.SelectedField = Fields[idx]
    FieldLabel.Text = "Поле: " .. Settings.SelectedField
end)

print("🎨 GUI MiniAtlas загружен")
