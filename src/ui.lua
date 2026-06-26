local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Mini Atlas",
    LoadingTitle = "Mini Atlas Full",
    LoadingSubtitle = "by sashadonh",
    ConfigurationSaving = { Enabled = false }
})

local FarmingTab = Window:CreateTab("Farming", 4483362458)
local PlantersTab = Window:CreateTab("Planters", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Farming
FarmingTab:CreateToggle({Name = "Auto Farm", CurrentValue = true, Callback = function(v) Settings.AutoFarm = v end})
FarmingTab:CreateToggle({Name = "Auto Collect", CurrentValue = true, Callback = function(v) Settings.AutoCollect = v end})
FarmingTab:CreateToggle({Name = "Auto Sprinkler", CurrentValue = true, Callback = function(v) Settings.AutoSprinkler = v end})
FarmingTab:CreateToggle({Name = "Auto Dig (E)", CurrentValue = true, Callback = function(v) Settings.AutoDig = v end})

FarmingTab:CreateDropdown({
    Name = "Selected Field",
    Options = {"Sunflower Field", "Mushroom Field", "Dandelion Field", "Clover Field", "Blue Flower Field", "Bamboo Field", "Strawberry Field", "Pineapple Patch", "Rose Field", "Spider Field", "Cactus Field", "Pumpkin Patch", "Coconut Field", "Pepper Patch", "Mountain Top Field", "Stump Field"},
    CurrentOption = {"Sunflower Field"},
    Callback = function(Option) Settings.SelectedField = Option[1] end
})

-- Planters
PlantersTab:CreateToggle({Name = "Auto Planters (В разработке)", CurrentValue = false, Callback = function(v) Settings.AutoPlanters = v end})

-- Misc
MiscTab:CreateToggle({Name = "Auto Quest", CurrentValue = true, Callback = function(v) Settings.AutoQuest = v end})

Rayfield:Notify({Title = "Mini Atlas", Content = "Загружен успешно! Выбирай вкладки.", Duration = 6})

print("🎨 Rayfield GUI (Atlas Style) загружен")
