local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Mini Atlas",
    LoadingTitle = "Mini Atlas Full",
    LoadingSubtitle = "by sashadonh",
    ConfigurationSaving = { Enabled = false }
})

local FarmingTab = Window:CreateTab("Farming", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

FarmingTab:CreateToggle({Name = "Auto Farm", CurrentValue = false, Callback = function(v) _G.Settings.AutoFarm = v end})
FarmingTab:CreateToggle({Name = "Auto Collect", CurrentValue = false, Callback = function(v) _G.Settings.AutoCollect = v end})
FarmingTab:CreateToggle({Name = "Auto Sprinkler", CurrentValue = false, Callback = function(v) _G.Settings.AutoSprinkler = v end})
FarmingTab:CreateToggle({Name = "Auto Dig (E)", CurrentValue = false, Callback = function(v) _G.Settings.AutoDig = v end})

FarmingTab:CreateDropdown({
    Name = "Selected Field",
    Options = {"Sunflower Field", "Mushroom Field", "Dandelion Field", "Clover Field", "Blue Flower Field", "Bamboo Field", "Strawberry Field", "Pineapple Patch", "Rose Field", "Spider Field", "Cactus Field", "Pumpkin Patch", "Coconut Field", "Pepper Patch", "Mountain Top Field", "Stump Field"},
    CurrentOption = {"Sunflower Field"},
    Callback = function(Option) _G.Settings.SelectedField = Option[1] end
})

MiscTab:CreateToggle({Name = "Auto Quest", CurrentValue = false, Callback = function(v) _G.Settings.AutoQuest = v end})

Rayfield:Notify({Title = "Mini Atlas", Content = "Загружен! Все функции выключены.", Duration = 5})

print("🎨 GUI загружен (все тогглы OFF)")
