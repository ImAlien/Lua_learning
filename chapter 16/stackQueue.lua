require "stack"

StackQueue = Stack:new()

function StackQueue:insertbottom(x)
    table.insert(self.val, 1,x)
end

function StackQueue:traverse()
    for k, v in ipairs(self.val) do
        print(v)
    end
end

q = StackQueue:new()

q:push(3)
q:push(5)
q:traverse()

q:insertbottom(4)
q:traverse()

q:push(6)
q:traverse()