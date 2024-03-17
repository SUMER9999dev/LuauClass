export type Class<Methods, Implementation, InitArguments...> = {
	__init: (self: Implementation & Methods, InitArguments...) -> (),

	_type: string,
	_should_init: boolean,

	new: (InitArguments...) -> Implementation & Methods,
} & Methods
export type ExtendedClass<Superior, Methods, Implementation, InitArguments...> = Class<Methods & Superior, Implementation & {super: Superior}, InitArguments...>

type LuauClassType = {extend: <T, I>(self: any, from: I, to: T) -> T} & <T>(class: T) -> T


local function partial<T>(base: T, ...: any): T
	local pre_defined_arguments = {...}

	return function(...)
		local arguments = {unpack(pre_defined_arguments)}

		for _, argument in {...} do
			table.insert(arguments, argument)
		end

		return base(unpack(arguments))
	end
end


local function copy<T>(base: T): T
	if typeof(base) ~= 'table' then
		return base
	end

	local copy_of_base = {}

	for key, value in next, base do
		if type(value) == 'table' then
			copy_of_base[key] = copy(value)
			continue
		end

		copy_of_base[key] = value
	end

	return copy_of_base
end


local function merge<T, I>(base: T, mod: I): I & T
	base = copy(base)

	for key, value in next, mod do
		if type(key) == 'number' then
			table.insert(base, key, value)
			continue
		end

		base[key] = value
	end

	return base
end


local function class_index_wrapper<T>(base: {[any]: any}, custom_index: (self: T, index: any) -> any?, self: T, index: any): any?
	local index_in_base_table = rawget(base, index)

	if index_in_base_table ~= nil then
		return index_in_base_table
	end

	if custom_index then
		return custom_index(self, index)
	end

	return nil
end


local BaseClass = {}
BaseClass._should_init = false
BaseClass.super = nil
BaseClass._type = nil


function BaseClass:__init()
end


function BaseClass.new(class, ...)
	if not class.__index_loaded then
		local custom_index = class.__index or function(...)
			return nil
		end

		class.__index = partial(
			class_index_wrapper,
			class,
			custom_index
		)

		class.__index_loaded = true
	end

	local self = setmetatable({}, class)

	if class.super then
		class.super._should_init = false
		rawset(self, 'super', BaseClass.new(class.super))
	end

	if class._should_init then
		self:__init(...)
	end

	return self
end


local LuauClass = {}
LuauClass.__index = LuauClass


function LuauClass.__call<T>(self, class: T): T  
	if type(class) ~= 'table' then
		return error('Class must be table.')
	end

	local type_name = class._type or ''
	local custom_index = class.__index or function(...)
		return nil
	end

	local base_class = copy(BaseClass)
	base_class = merge(base_class, class)
	base_class._type = type_name
	base_class._should_init = true
	base_class.new = partial(BaseClass.new, base_class)

	return base_class
end


function LuauClass:extend<T, I>(from: I, to: T): T
	if type(from) ~= 'table' then
		return error('Superior class must be table.')
	end

	if type(from) ~= 'table' then
		return error('Successor class must be table.')
	end

	to = to or {}
	from = copy(from)

	to.super = from
	to = merge(from, to)

	return self(to)
end


return setmetatable({}, LuauClass) :: LuauClassType
