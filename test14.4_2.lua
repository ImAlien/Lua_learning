a = 1
local newgt = {} -- create new environment
setmetatable(newgt, {__index = _G})
_ENV = newgt -- set it
print(a) --> 1
