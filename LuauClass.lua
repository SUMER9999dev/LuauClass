local function partial(base, ...)
    local args = {...}
    return function(...)
        return base(unpack(args), ...)
    end
end


local function copy(base)
    local copy_of_base = {}

    for key, value in next, base do
        copy_of_base[key] = value
    end

    return copy_of_base
end


local function merge(base, mod)
    local base = copy(base)

    for key, value in next, mod do
        if type(key) == 'number' then
            table.insert(base, key, value)
            continue
        end

        base[key] = value
    end

    return base
end


local BaseClass = {}
BaseClass._should_init = false
BaseClass.super = nil
BaseClass._type = nil


function BaseClass.new(class, ...)
    class.__index = class
    local self = setmetatable({}, class)

    if class.super then
        class.super._should_init = false
        self.super = class.super.new()
    end

    if class._should_init then
        self:__init(...)
    end

    return self
end


local LuauClass = {}
LuauClass.__index = LuauClass


function LuauClass.__call(self, class)
    if type(class) ~= 'table' then
        return error('Class must be table.')
    end

    local class = class or {}
    local type_name = class._type or ''

    local base_class = copy(BaseClass)

    base_class._type = type_name
    base_class._should_init = true
    base_class = merge(base_class, class)
    base_class.new = partial(BaseClass.new, base_class)

    return base_class
end


function LuauClass:extend(from, to)
    if type(from) ~= 'table' then
        return error('Superior class must be table.')
    end

    if type(from) ~= 'table' then
        return error('Successor class must be table.')
    end

    local to = to or {}
    local from = copy(from)

    to.super = from
    to = merge(from, to)

    return self(to)
end


return setmetatable({}, LuauClass)
