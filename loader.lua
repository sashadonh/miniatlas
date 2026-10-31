-- Nectar Glass V17 | Speed Lock: Smart / Fixed
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarGlassV17.lua"
local source=game:HttpGet(url.."?v="..tostring(os.clock()),true)
local run,err=loadstring(source)
assert(run,err)
run()
