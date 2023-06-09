-- 创建一个弱引用值表
local weakTable = setmetatable({}, { __mode = "v" })
--weakTable = {}
-- 创建一些键
local key1 = {}
local key2 = {}

-- 创建一些对象作为值
local value1 = {}
local value2 = {}

-- 将键值对添加到弱引用值表中
weakTable[key1] = value1
weakTable[key2] = value2

-- 输出弱引用值表中的值
for k, v in pairs(weakTable) do
    print(k, v)
end

-- 释放 value1 对象的强引用
value1 = {}
key1 = {}
weakTable[key1] = value1
-- 强制进行垃圾回收
collectgarbage()

-- 输出弱引用值表中的值
for k, v in pairs(weakTable) do
    print(k, v)
end