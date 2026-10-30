-- Nectar Glass V14 / compact neon dock
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarGlassV14.lua"
local source=game:HttpGet(url.."?v="..tostring(os.clock()),true)
local run,err=loadstring(source)
assert(run,err)
run()
