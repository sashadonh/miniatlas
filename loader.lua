-- Nectar Glass V16: single rounded glass window, no protruding corners
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarGlassV16.lua"
local source=game:HttpGet(url.."?v="..tostring(os.clock()),true)
local run,err=loadstring(source)
assert(run,err)
run()
