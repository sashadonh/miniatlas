local player = game.Players.LocalPlayer

-- Очистка старого GUI
for _, v in pairs(player.PlayerGui:GetChildren()) do
    if v.Name:find("MiniAtlas") or v.Name:find("Atlas") then
        v:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiniAtlas_Atlas"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 520)
Main.Position = UDim2.new(0.67, 0, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(13, 13, 23)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Main

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 38)
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Text = "MINI ATLAS"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(100, 180, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Parent = TopBar

-- Кнопка закрытия / сворачивания
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 8)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.Parent = TopBar

-- Содержимое
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -55)
Content.Position = UDim2.new(0, 0, 0, 55)
Content.BackgroundTransparency = 1
Content.Parent = Main

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = Content

local function CreateToggle(name, key)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -20, 0, 52)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 40)
    ToggleFrame.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = ToggleFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(45, 45, 75)
    Stroke.Thickness = 1
    Stroke.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Text = name
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1,1,1)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 17
    Label.Parent = ToggleFrame

    local Status = Instance.new("TextLabel")
    Status.Text = Settings[key] and "ON" or "OFF"
    Status.Size = UDim2.new(0.25, 0, 1, 0)
    Status.Position = UDim2.new(0.7, 0, 0, 0)
    Status.BackgroundTransparency = 1
    Status.TextColor3 = Settings[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 70, 70)
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 17
    Status.Parent = ToggleFrame

    ToggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Settings[key] = not Settings[key]
            Status.Text = Settings[key] and "ON" or "OFF"
            Status.TextColor3 = Settings[key] and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 70, 70)
        end
    end)
end

CreateToggle("Auto Farm", "AutoFarm")
CreateToggle("Auto Collect", "AutoCollect")
CreateToggle("Auto Sprinkler", "AutoSprinkler")
CreateToggle("Auto Dig (E)", "AutoDig")
CreateToggle("Auto Quest", "AutoQuest")

-- Логика открытия/закрытия
local isOpen = true

CloseBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    Main.Visible = isOpen
end)

-- Горячая клавиша (Right Shift) для открытия/закрытия
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        isOpen = not isOpen
        Main.Visible = isOpen
    end
end)

print("🎨 Atlas-style GUI с открытием/закрытием загружен | RightShift - открыть/закрыть")
