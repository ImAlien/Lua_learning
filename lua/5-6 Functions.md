#### 使用

当参数是字符串或者表时，可以省略括号

```lua
 print "Hello World"     <-->     print("Hello World")
    dofile 'a.lua'          <-->     dofile ('a.lua')
    print [[a multi-line    <-->     print([[a multi-line
     message]]                        message]])
    f{x=10, y=20}           <-->     f({x=10, y=20})
    type{}                  <-->     type({})
```

参数像局部变量一样运行， 可以自适应参数，没有函数重载

```lua
function f(a, b) return a or b end

f(3)             a=3, b=nil
    f(3, 4)          a=3, b=4
    f(3, 4, 5)       a=3, b=4   (5 is discarded)
```

#### 多返回值

跟python一样

```
function foo0()
end

a, b = foo0(), 1, 2  --> nil 1
print(a, b)
```

但是在很多情况下只返回一个参数，例如

```
print(foo2(), 1) --> a 1
t = {foo0(), foo2(), 4} -- t[1] = nil, t[2] = "a", t[3] = 4
```

#### 可变长参数

```
function add (...)
local s = 0
for i, v in ipairs{...} do
s = s + v
end
return s
end
print(add(3, 4, 10, 25, 12)) --> 54
```

#### 指定参数

不能直接指定参数

```
rename(old="temp.lua", new="temp1.lua")
```

可以通过定义参数为table

```
rename{old="temp.lua", new="temp1.lua"}
```

#### 函数的本质

函数其实是一个变量， 类型为函数

```
foo = function (x) return 2*x end
```

```
table.sort(network, function (a,b)
      return (a.name > b.name)
    end)
```

#### 闭包

闭包（closure）是一个函数加上其访问的非局部变量（外部环境中定义的变量）的组合。换句话说，闭包是一个函数对象，它可以访问并操作其创建时所处的环境中的变量，即使在该环境已经不再存在的情况下。

```lua
function newCounter ()
    local i = 0
    return function ()   -- anonymous function
                i = i + 1
                return i
            end
end
c1 = newCounter()
print(c1())  --> 1
print(c1())  --> 2

c2 = newCounter()
print(c2())  -->1 
print(c2())  -->2

```

#### 局部函数

```lua
local fact
    fact = function (n)
      if n == 0 then return 1
      else return n*fact(n-1)
      end
    end
```

#### 尾调用

在函数末尾调用别的函数，可以不用再回到该函数，栈空间不增大

