-- Nectar V3 loader
local url = "https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarV3.lua"
local source = game:HttpGet(url, true)
local chunk, err = loadstring(source)
assert(chunk, err)
chunk()
