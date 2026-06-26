-- === MINI ATLAS + RAYFIELD v2.6 ===
print("🚀 Запуск Mini Atlas + Rayfield...")

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Не удалось загрузить Rayfield! Используй другой executor или попробуй позже.")
    return
end

local Window = Rayfield:CreateWindow({
    Name = "Mini Atlas BSS",
    LoadingTitle = "Mini Atlas by sashadonh",
    LoadingSubtitle = "Bee Swarm Simulator",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Farming", 4483362458)

Settings = Settings or {
    AutoFarm = true,
    AutoCollect = true,
    AutoSprinkler = true,
    AutoDig = true,
    AutoQuest = true,
    SelectedField = "Sunflower Field",
    FarmRadius = 40,
}

local Fields = {"Sunflower Field", "Mushroom Field", "Dandelion Field", "Clover Field", "Blue Flower Field", "Bamboo Field", "Strawberry Field", "Pineapple Patch", "Rose Field", "Spider Field", "Cactus Field", "Pumpkin Patch", "Coconut Field", "Pepper Patch", "Mountain Top Field", "Stump Field"}

MainTab:CreateToggle({Name = "Auto Farm", CurrentValue = true, Callback = function(v) Settings.AutoFarm = v end})
MainTab:CreateToggle({Name = "Auto Collect", CurrentValue = true, Callback = function(v) Settings.AutoCollect = v end})
MainTab:CreateToggle({Name = "Auto Sprinkler", CurrentValue = true, Callback = function(v) Settings.AutoSprinkler = v end})
MainTab:CreateToggle({Name = "Auto Dig (E)", CurrentValue = true, Callback = function(v) Settings.AutoDig = v end})
MainTab:CreateToggle({Name = "Auto Quest", CurrentValue = true, Callback = function(v) Settings.AutoQuest = v end})

MainTab:CreateDropdown({
    Name = "Выбор поля",
    Options = Fields,
    CurrentOption = {"Sunflower Field"},
    Callback = function(Option) 
        Settings.SelectedField = Option[1] 
    end
})

print("✅ Rayfield GUI создан!")
