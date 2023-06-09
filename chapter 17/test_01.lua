-- 创建一个弱引用键表
local weakTable = setmetatable({}, { __mode = "k" })
-- 创建一些对象作为键
local key1 = {}
local key2 = {}

-- 创建一些值
local value1 = "Value 1"
local value2 = "Value 2"

-- 将键值对添加到弱引用键表中
weakTable[key1] = value1
weakTable[key2] = value2

key1 = {}
weakTable[key1] = "Value 4"
-- 输出弱引用键表中的值 -- 1, 2, 4
for k, v in pairs(weakTable) do
    print(k, v)
end

-- 强制进行垃圾回收
collectgarbage() 

-- 输出弱引用键表中的值  -- 2, 4
for k, v in pairs(weakTable) do
    print(k, v)
end