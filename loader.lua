-- Nectar Transparent Glass V9.0 | speed-only
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarGlassV9.lua"
local source=game:HttpGet(url.."?v="..tostring(os.clock()),true)
local run,err=loadstring(source)
assert(run,err)
run()
