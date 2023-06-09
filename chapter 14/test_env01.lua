
local x = 10

local f1 = function()
    x = 9
end

local f2 = function()
    x = 1
end

print(x)
f1()
print(x)
f2()
print(x)