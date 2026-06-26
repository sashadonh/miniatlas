-- Mini Atlas Full Clone Loader by sashadonh
print("🔄 Загрузка Mini Atlas Full Clone...")

local repo = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/"
local nc = "?nocache=" .. os.time()

loadstring(game:HttpGet(repo .. "src/main.lua" .. nc, true))()
