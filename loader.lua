-- MiniAtlas Loader v2.5 (Anti-Cache) by sashadonh
print("🔄 Загрузка MiniAtlas v2.5 (Anti-Cache)...")

local repo = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/"
local timestamp = "?nocache=" .. os.time()

loadstring(game:HttpGet(repo .. "src/main.lua" .. timestamp, true))()
