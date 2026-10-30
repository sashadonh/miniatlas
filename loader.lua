-- Nectar Liquid Glass V7 | unique file avoids stale V6 cache
local address="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarGlassV7.lua"
local text=game:HttpGet(address.."?fresh="..tostring(os.clock()),true)
local fn,err=loadstring(text)
assert(fn,err)
fn()
