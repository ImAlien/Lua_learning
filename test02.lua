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

w = Window.new{x = 10, y = 20, z = 200}
print(w.z)

for n in pairs(_G._G._G) do
 print(n)
end
