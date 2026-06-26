-- === MINI ATLAS + RAYFIELD ===
print("🚀 Загрузка Rayfield...")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Mini Atlas BSS",
    LoadingTitle = "Mini Atlas by sashadonh",
    LoadingSubtitle = "Bee Swarm Simulator",
    ConfigurationSaving = {
        Enabled = false,
    },
})

-- Главная вкладка
local MainTab = Window:CreateTab("Main", 4483362458)

-- Настройки (будут использоваться в скрипте)
Settings = Settings or {
    AutoFarm = true,
    AutoCollect = true,
    AutoSprinkler = true,
    AutoDig = true,
    AutoQuest = true,
    SelectedField = "Sunflower Field",
}

local Fields = {"Sunflower Field", "Mushroom Field", "Dandelion Field", "Clover Field", "Blue Flower Field", "Bamboo Field", "Strawberry Field", "Pineapple Patch", "Rose Field", "Spider Field", "Cactus Field", "Pumpkin Patch", "Coconut Field", "Pepper Patch", "Mountain Top Field", "Stump Field"}

-- Тогглы
MainTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = Settings.AutoFarm,
    Callback = function(Value)
        Settings.AutoFarm = Value
    end,
})

MainTab:CreateToggle({
    Name = "Auto Collect Tokens",
    CurrentValue = Settings.AutoCollect,
    Callback = function(Value)
        Settings.AutoCollect = Value
    end,
})

MainTab:CreateToggle({
    Name = "Auto Sprinkler",
    CurrentValue = Settings.AutoSprinkler,
    Callback = function(Value)
        Settings.AutoSprinkler = Value
    end,
})

MainTab:CreateToggle({
    Name = "Auto Dig (E)",
    CurrentValue = Settings.AutoDig,
    Callback = function(Value)
        Settings.AutoDig = Value
    end,
})

MainTab:CreateToggle({
    Name = "Auto Quest",
    CurrentValue = Settings.AutoQuest,
    Callback = function(Value)
        Settings.AutoQuest = Value
    end,
})

-- Выбор поля
MainTab:CreateDropdown({
    Name = "Selected Field",
    Options = Fields,
    CurrentOption = {Settings.SelectedField},
    Callback = function(CurrentOption)
        Settings.SelectedField = CurrentOption[1]
    end,
})

print("✅ Rayfield GUI загружен!")
