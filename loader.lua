-- MiniAtlas Loader v2.4 (Atlas Style) by sashadonh
print("🔄 Загрузка MiniAtlas (Atlas Style)...")

local repo = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/"
local nc = "?t=" .. os.time()

loadstring(game:HttpGet(repo .. "src/main.lua" .. nc, true))()
