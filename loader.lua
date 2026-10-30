-- Nectar Cyber Violet Liquid Glass V6.2
-- Cache-busted: loads latest version every execution.
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarSpeedV6.lua"
local nonce=tostring(math.floor(os.clock()*1000000))
local source=game:HttpGet(url.."?v="..nonce,true)
local run,err=loadstring(source)
assert(run,err)
run()
