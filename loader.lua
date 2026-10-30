-- Nectar Glass V12 | token speed reset fix
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarGlassV12.lua"
local code=game:HttpGet(url.."?v="..tostring(os.clock()),true)
local run,err=loadstring(code)
assert(run,err)
run()
