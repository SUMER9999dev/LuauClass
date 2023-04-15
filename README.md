#  🗂 LuauClass
Simple class library for roblox Luau

## Documentation
**Class creation:**
```lua
local MyClass = LuauClass {_type = 'type of class'}
```

**Setup class initializer:**
```lua
function MyClass:__init(argument1, argument2) -- this function will get arguments
  self.argument1 = argument1
  self.argument2 = argument2
end
```

**Add some methods:**
```lua
function MyClass:add()
  return self.argument1 + self.argument2
end
```

**Create class instance and test:**
```lua
local my_class = MyClass.new(2, 2)
print(my_class:add()) --> 4
```

**Inheritance:**
```lua
local MyClassWithSub = LuauClass:extend(MyClass, {_type = 'MyClassWithSub'}

function MyClassWithSub:__init(argument1, argument2)
  self.argument1 = argument1
  self.argument2 = argument2
end

function MyClassWithSub:sub()
  return self.argument1 - self.argument2
end


local with_sub = MyClassWithSub.new(2, 2)
print(with_sub:sub()) --> 0
print(with_sub:add()) --> 4
```
