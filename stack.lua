

Stack={val = {}}

function Stack:push(x)
    self.val[#(self.val)+1] = x
end

function Stack:isempty()
    return #(self.val) == 0
end

function Stack:pop()
    if self:isempty() == false then
        local ans = self.val[#(self.val)]
        table.remove(self.val, #(self.val))
        return ans
    else
        return nil
    end
end

function Stack:top()
    if self:isempty() then
        return nil
    else
        return self.val[#(self.val)]
    end
end

function Stack:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o;
end
 

local s = Stack:new()

s:push(3)
s:push(5)

print(s:top())

s:pop()

print(s:top())

s:pop()
print(s:top())

