-- Nectar Glass V13: preserve Haste buffs, speed acts as minimum
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarGlassV13.lua"
local source=game:HttpGet(url.."?v="..tostring(os.clock()),true)
local run,err=loadstring(source)
assert(run,err)
run()
