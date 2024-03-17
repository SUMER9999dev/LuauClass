#  🗂 LuauClass
Simple class library for roblox Luau <br/>
Made by SUMER for MelonBytes Studio and some projects

## Discord
My: sumer_real <br/>
Server: [join](https://discord.gg/r3mpMDZBAa)

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

**Types definition:**
```lua
  LuauClass.Class<Methods, Implementation, InitArguments...>
  LuauClass.ExtendedClass<class: LuauClass.Class, Methods, Implementation, InitArguments...>
```

**Types example:**
```lua
export type Impl = {x: number}
export type AddType = LuauClass.Class<
	{
		add: (self: AddType & Impl, y: number) -> number
	},
	Impl,
	number
>

export type SubType = LuauClass.ExtendedClass<AddType, {
	sub: (self: SubType & Impl, y: number) -> number
}, Impl, number>


local Add = LuauClass {_type = 'Add'} :: AddType

function Add:__init(x: number)
	self.x = x
end

function Add:add(y: number): number
	return self.x + y
end


local Sub = LuauClass:extend(Add, {_type = 'Sub'} :: SubType)

function Sub:__init(x: number)
	self.super.__init(self, x)
end

function Sub:sub(y: number)
	return self.x - y
end
```
