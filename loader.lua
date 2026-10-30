-- Nectar V4 stable loader
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarV4.lua"
local code=game:HttpGet(url,true)
local runner,err=loadstring(code)
assert(runner,err)
runner()
