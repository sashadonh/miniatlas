-- Permanent loader for mybss.lua
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/mybss.lua"
local source=game:HttpGet(url.."?refresh="..tostring(os.clock()),true)
local run,err=loadstring(source)
assert(run,err)
run()
