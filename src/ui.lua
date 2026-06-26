local player = game.Players.LocalPlayer

-- Удаляем старое GUI
for _, v in pairs(player.PlayerGui:GetChildren()) do
    if v.Name:find("MiniAtlas") or v.Name:find("Atlas") then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiniAtlas_AtlasStyle"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 520)
Main.Position = UDim2.new(0.65, 0, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

-- Top Bar (как в Atlas)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
TopBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "Mini Atlas"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(100, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Parent = TopBar

-- Tabs
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 40)
TabFrame.Position = UDim2.new(0, 0, 0, 50)
TabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
TabFrame.Parent = Main

local tabs = {"Home", "Farming", "Quests", "Misc"}
local currentTab = "Home"

local function SwitchTab(tab)
    currentTab = tab
    -- Здесь можно делать разные страницы, но для простоты показываем всё
end

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1/#tabs, 0, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 255)
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.Parent = TabFrame
    tabBtn.MouseButton1Click:Connect(function() SwitchTab(tabName) end)
end

-- Content
local y = 110
local function CreateToggle(text, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 55)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    btn.Text = "   " .. text .. ": " .. (Settings[key] and "✅ ON" or "❌ OFF")
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 17
    btn.Parent = Main

    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = "   " .. text .. ": " .. (Settings[key] and "✅ ON" or "❌ OFF")
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 120, 80) or Color3.fromRGB(30, 30, 50)
    end)
    y = y + 65
end

CreateToggle("Auto Farm", "AutoFarm")
CreateToggle("Auto Collect Tokens", "AutoCollect")
CreateToggle("Auto Sprinkler", "AutoSprinkler")
CreateToggle("Auto Dig (E)", "AutoDig")
CreateToggle("Auto Quest", "AutoQuest")

-- Field Selector
local FieldLabel = Instance.new("TextLabel")
FieldLabel.Text = "   Поле: " .. Settings.SelectedField
FieldLabel.Size = UDim2.new(0.9, 0, 0, 50)
FieldLabel.Position = UDim2.new(0.05, 0, 0, y + 10)
FieldLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
FieldLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
FieldLabel.TextXAlignment = Enum.TextXAlignment.Left
FieldLabel.Font = Enum.Font.Gotham
FieldLabel.Parent = Main

local ChangeField = Instance.new("TextButton")
ChangeField.Text = "Сменить поле"
ChangeField.Size = UDim2.new(0.9, 0, 0, 50)
ChangeField.Position = UDim2.new(0.05, 0, 0, y + 70)
ChangeField.BackgroundColor3 = Color3.fromRGB(50, 50, 90)
ChangeField.TextColor3 = Color3.new(1,1,1)
ChangeField.Parent = Main

ChangeField.MouseButton1Click:Connect(function()
    local idx = 1
    for i, f in ipairs(Fields) do
        if f == Settings.SelectedField then idx = i end
    end
    idx = (idx % #Fields) + 1
    Settings.SelectedField = Fields[idx]
    FieldLabel.Text = "   Поле: " .. Settings.SelectedField
end)

print("🎨 Atlas-style GUI загружен")
