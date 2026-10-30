-- Nectar Liquid Glass V10 | clearer text and new typography
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarGlassV10.lua"
local data=game:HttpGet(url.."?v="..tostring(os.clock()),true)
local run,err=loadstring(data)
assert(run,err)
run()
