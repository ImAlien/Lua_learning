#### 弱表

弱引用键表

```lua
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
```

##### 弱引用值表

```lua
-- 创建一个弱引用值表
local weakTable = setmetatable({}, { __mode = "v" })
-- 创建一些键
local key1 = "Key 1"
local key2 = "Key 2"

-- 创建一些对象作为值
local value1 = {}
local value2 = {}

-- 将键值对添加到弱引用值表中
weakTable[key1] = value1
weakTable[key2] = value2

-- 输出弱引用值表中的值
for k, v in pairs(weakTable) do
    print(k, v) -- 2， 1
end

-- 释放 value1 对象的强引用
value1 = nil

-- 强制进行垃圾回收
collectgarbage()

-- 输出弱引用值表中的值
for k, v in pairs(weakTable) do
    print(k, v) -- 2
end
```

#### 弱表的应用

记忆函数：

```lua
local results = setmetatable({}, { __mode = "kv" })
    function mem_loadstring (s)
      if results[s] then      -- result available?
        return results[s]     -- reuse it
      else
        local res = loadstring(s)   -- compute new result
        results[s] = res            -- save for later reuse
        return res
      end
    end
```

关联对象和属性 （自动释放属性的空间)把键设为对象, 需要释放时则释放键

```lua
-- 创建一个弱引用键表
local objectAttributes = setmetatable({}, { __mode = "k" })

-- 定义一个函数，用于设置对象的属性
local function setAttribute(obj, attribute, value)
  -- 获取对象的属性表，如果不存在则创建一个新表
  local attributes = objectAttributes[obj]
  if not attributes then
    attributes = {}
    objectAttributes[obj] = attributes
  end

  -- 设置属性值
  attributes[attribute] = value
end

-- 定义一个函数，用于获取对象的属性
local function getAttribute(obj, attribute)
  -- 获取对象的属性表
  local attributes = objectAttributes[obj]
  if attributes then
    -- 返回属性值
    return attributes[attribute]
  end
end

-- 创建对象
local obj1 = {}
local obj2 = {}

-- 设置对象的属性
setAttribute(obj1, "color", "red")
setAttribute(obj2, "color", "blue")

-- 获取对象的属性
print(getAttribute(obj1, "color"))  -- 输出 "red"
print(getAttribute(obj2, "color"))  -- 输出 "blue"

-- 释放对 obj1 对象的强引用
obj1 = nil

-- 强制进行垃圾回收
collectgarbage()

-- 获取对象的属性
print(getAttribute(obj1, "color"))  -- 输出 nil，obj1 对应的属性表已被垃圾回收
print(getAttribute(obj2, "color"))  -- 输出 "blue"
```

#### 终结器

终结器是在回收前调用的函数，可以用于执行一些清理操作，例如关闭文件、释放资源、解除对象之间的关联等。通过使用Finalizer，可以确保在对象被销毁时，相关的清理操作得以执行，从而避免资源泄漏和其他问题

```lua
-- 创建一个带有Finalizer的对象
local object = {}
local mt = { __gc = function(obj) print("Finalizing object") end }
setmetatable(object, mt)

-- 手动触发垃圾回收
collectgarbage()

-- 输出:
-- Finalizing object
```

在Lua中，设置了元表中的 `__gc` 元方法并不会直接标记对象。相反，当为对象设置了具有非空 `__gc` 元方法的元表时，Lua会在对象没有任何强引用时，将其标记为可进行终结器处理。

```
o = {x = "hi"}
mt = {}
setmetatable(o, mt)
mt.__gc = function (o) print(o.x) end
o = nil
collectgarbage() --> (prints nothing)
```

在同一次回收中，终结器从后往前调用（栈？）

```lua
mt = {__gc = function (o) print(o[1]) end}
list = nil
for i = 1, 3 do
list = setmetatable({i, link = list}, mt)
end
list = nil
collectgarbage()
--> 3
--> 2
--> 1
```

