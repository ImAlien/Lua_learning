a = 1
local newgt = {} -- create new environment
setmetatable(newgt, {__index = _G})
_ENV = newgt -- set it
print(a) --> 1

a = 10  --> no __newindex
print(a) --> 10
print(_G.a) --> 1
_G.a = 20
print(_G.a) --> 20
