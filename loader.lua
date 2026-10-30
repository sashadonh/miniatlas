-- Nectar V5 loader
-- Independent, original script maintained in this repository.
local url="https://raw.githubusercontent.com/sashadonh/miniatlas/main/NectarV5.lua"
local source=game:HttpGet(url,true)
local run,compileError=loadstring(source)
assert(run,compileError)
run()
