#### 定义Table中的方法

```
function Account.withdraw (self, v)
      self.balance = self.balance - v
    end
    
function Account:withdraw (v)
      self.balance = self.balance - v
    end
function Account:deposit (v)
      self.balance = self.balance + v
    end
```

#### 定义类

一般当作metatable的table作为类，方法都写在其中

```
function Account:new (o)
      o = o or {}   -- create object if user does not provide one
      setmetatable(o, self)
      self.__index = self
      return o
    end
```

#### 继承

```lua
 SpecialAccount = Account:new()
 -- 子类创建后再设置方法
 unction SpecialAccount:withdraw (v)
      if v - self.balance >= self:getLimit() then
        error"insufficient funds"
      end
      self.balance = self.balance - v
    end
    
    function SpecialAccount:getLimit ()
      return self.limit or 0
    end
```

#### 权限控制



变量值存储在另外一个表中， 

```lua
function newAccount (initialBalance)
    -- private变量表
      local self = {balance = initialBalance}
    
      local withdraw = function (v)
                         self.balance = self.balance - v
                       end
    
      local deposit = function (v)
                        self.balance = self.balance + v
                      end
    
      local getBalance = function () return self.balance end
    	
    	-- 返回的是public方法
      return {
        withdraw = withdraw,
        deposit = deposit,
        getBalance = getBalance
      }
    end
```

