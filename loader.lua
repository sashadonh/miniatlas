-- MiniAtlas Loader v2.3 by sashadonh
print("🔄 Загрузка MiniAtlas v2.3...")

local repo = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/"

-- Анти-кэш (чтобы всегда брал свежую версию)
local nocache = "?t=" .. os.time()

loadstring(game:HttpGet(repo .. "src/main.lua" .. nocache, true))()
