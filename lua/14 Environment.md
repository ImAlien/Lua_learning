#### 1 通过动态名字获取全局变量

变量的名字在别的变量中时，获取变量的值

```lua
a = "string"

for k in pairs(_G[a])
	do print(k)
end

--[[
sub
upper
len
gfind
rep
find
match
char
dump
gmatch
reverse
byte
format
gsub
lower
]]
```

#### 2 声明全局变量

全局变量不需要声明，为了避免bug，可以采用以下方法：

```lua
setmetatable(_G, {
      __newindex = function (_, n)
        error("attempt to write to undeclared variable "..n, 2)
      end,
      __index = function (_, n)
        error("attempt to read undeclared variable "..n, 2)
      end,
    })
-- 新变量需要使用rawset
function declare (name, initval)
      rawset(_G, name, initval or false)
    end
-- 获取变量不能直接跟nil比较
if rawget(_G, var) == nil then
      -- `var' is undeclared
      ...
    end
```

```lua
local declaredNames = {}
    function declare (name, initval)
      rawset(_G, name, initval)
      declaredNames[name] = true
    end
    setmetatable(_G, {
      __newindex = function (t, n, v)
        if not declaredNames[n] then
          error("attempt to write to undeclared var. "..n, 2)
        else
          rawset(t, n, v)   -- do the actual set
        end
      end,
      __index = function (_, n)
        if not declaredNames[n] then
          error("attempt to read undeclared var. "..n, 2)
        else
          return nil
        end
      end,
    })
```

#### 3 非全局环境

* Lua 编译一个名为 _ENV 的上值范围内的任何块。
*  编译器将任何自由名称 var 转换为 _ENV.var。
* 加载（或加载文件）函数初始化块的第一个上值全局环境。

#### 4  使用_ENV

* _ENV = nil 可以让获取全局变量的行为都失效

```lua
local print, sin = print, math.sin
_ENV = nil
print(13) --> 13
print(sin(13)) --> 0.42016703682664
print(math.cos(13)) -- error!
```

* 要携带原来的变量，则需要提前保存

  * 可以通过继承

  ```lua
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
  ```

  ​	也可以直接通过一个变量

  ```lua
  a = 15 -- create a global variable
  _ENV = {g = _G} -- change current environment
  a = 1 -- create a field in _ENV
  g.print(a) --> 1
  g.print(g.a) --> 15
  ```

#### 5 _ENV and load

