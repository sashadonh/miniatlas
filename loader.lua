-- Nectar Glass V8: new file path avoids cached V7
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarGlassV8.lua"
local code=game:HttpGet(url.."?v8="..tostring(os.clock()),true)
local fn,err=loadstring(code)
assert(fn,err)
fn()
