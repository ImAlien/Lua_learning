#### 算数运算

```lua
Set = {}

function Set.union(a, b)
	local res = Set.new{}
	for k in pairs(a) do res[k] = true end
	for k in pairs(b) do res[k] = true end
	return res
end


function Set.intersection(a, b)
	local res = Set.new{}
	for k in pairs(a) do
		res[k]= b[k]
	end
	return res
end

function Set.tostring(set)
	local s = "{"
	local sep = ""
	for e in pairs(set) do
		s = s .. sep .. e
		sep = ", "
	end
	return s .. "}"
end

function Set.print (s)
	print(Set.tostring(s))
end


Set.mt = {}

function Set.new(t)
	local set = {}
	setmetatable(set, Set.mt)
	for k, v in ipairs(t) do set[v] = true end
	return set
end

s1 = Set.new{10, 20, 30}
s2 = Set.new{1, 2}

print(getmetatable(s1))
print(getmetatable(s2))
-- table: 00C096B8
-- table: 00C096B8

Set.mt.__add = Set.union

s3 = s1 + s2
Set.print(s3)
-- {1, 2, 30, 10, 20}

Set.mt.__mul = Set.intersection

Set.print((s1 + s2)*s1)
-- {30, 10, 20}

```

#### 逻辑运算



只需要实现<, <= , == 即可

```lua
Set.mt.__le = function (a, b)
	for k in pairs(a) do
		if not b[k] then return false end
	end
	return true
end

Set.mt.__lt = function (a, b)
	return a <= b and not(b <= a)
end

Set.mt.__eq = function (a, b)
	return a <= b and b <= a
end

s1 = Set.new{1, 2}
s2 = Set.new{1, 2,3}

print(s1 <= s2)       --> true
print(s1 < s2)        --> true
print(s1 >= s1)       --> true
print(s1 > s1)        --> false
print(s1 == s2 * s1)  --> true
```

#### metamethods

设置__netatable可以保护

```lua
Set.mt.__metatable = "not your business"
    
s1 = Set.new{}
print(getmetatable(s1))     --> not your business
setmetatable(s1, {})
stdin:1: cannot change protected metatable
```

#### __index 

添加了这个函数后，可以找到一些基类的变量（用于继承）

rawget(t,i)不会找__index

```lua
Window = {}

Window.prototype = {x = 0, y = 0, width = 100, heitht = 100, }

Window.mt = {}

function Window.new(o)
	setmetatable(o, Window.mt)
	return o
end

Window.mt.__index = function (table, key)
	return Window.prototype[key]
end
-- Window.mt.__index = window.prototype
w = Window.new{x = 10, y = 20, z = 200}
print(w.width) --> 100

```

Lua 查找一个表元素时的规则，其实就是如下 3 个步骤:

- 1.在表中查找，如果找到，返回该元素，找不到则继续
- 2.判断该表是否有元表，如果没有元表，返回 nil，有元表则继续。
- 3.判断元表有没有 __index 方法，如果 __index 方法为 nil，则返回 nil；如果 __index 方法是一个表，则重复 1、2、3；如果 __index 方法是一个函数，则返回该函数的返回值。

#### __newindex

The `__newindex` metamethod does for table updates what `__index` does for table accesses.

```lua
mymetatable = {}
mytable = setmetatable({key1 = "value1"}, { __newindex = mymetatable })

print(mytable.key1) --> value1

mytable.newkey = "新值2"
print(mytable.newkey,mymetatable.newkey) 
-- nil 新值2

mytable.key1 = "新值1"
print(mytable.key1,mymetatable.key1)
-- 新值1 nil

```



The call `rawset(t, k, v)` sets the value `v` in key `k` of table `t` without invoking any metamethod.

#### 默认值

```lua
local mt = {__index = function (t) return t.___ end}
function setDefault (t, d)
    t.___ = d
    setmetatable(t, mt)
end

local key = {}    -- unique key
local mt = {__index = function (t) return t[key] end}
function setDefault (t, d)
    t[key] = d
    setmetatable(t, mt)
end
```

#### 监测

可以设置一个空的table作为代理，访问和更新都在实际的表中

```lua
t = {}   -- original table (created somewhere)
    
    -- keep a private access to original table
    local _t = t
    
    -- create proxy
    t = {}
    
    -- create metatable
    local mt = {
      __index = function (t,k)
        print("*access to element " .. tostring(k))
        return _t[k]   -- access the original table
      end,
    
      __newindex = function (t,k,v)
        print("*update of element " .. tostring(k) ..
                             " to " .. tostring(v))
        _t[k] = v   -- update original table
      end
    }
    setmetatable(t, mt)
```

#### 只读

```lua
function readOnly (t)
      local proxy = {}
      local mt = {       -- create metatable
        __index = t,
        __newindex = function (t,k,v)
          error("attempt to update a read-only table", 2)
        end
      }
      setmetatable(proxy, mt)
      return proxy
    end
```

