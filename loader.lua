-- Nectar Speed Edition V6
-- Cyber Violet UI; only the speed controller is loaded.
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarSpeedV6.lua"
local source=game:HttpGet(url,true)
local run,err=loadstring(source)
assert(run,err)
run()
