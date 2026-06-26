-- MiniAtlas Loader by sashadonh
print("🔄 Загрузка MiniAtlas v2...")

local repo = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/"

loadstring(game:HttpGet(repo .. "src/main.lua", true))()
