-- MiniAtlas Loader with Rayfield by sashadonh
print("🔄 Загрузка MiniAtlas + Rayfield...")

local repo = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/"
local nc = "?nocache=" .. os.time()

loadstring(game:HttpGet(repo .. "src/main.lua" .. nc, true))()
