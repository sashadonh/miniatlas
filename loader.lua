-- Nectar Glass V19 | Auto Swing + all token labels
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarGlassV19.lua"
local source=game:HttpGet(url.."?v="..tostring(os.clock()),true)
local run,err=loadstring(source)
assert(run,err)
run()
