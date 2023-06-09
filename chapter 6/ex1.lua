function integral(f, x, y, stepsCount)
	assert(x < y, "x must be smaller then y")
	stepsCount = stepsCount or 1000
	local step = (y - x) / stepsCount
	local sum = 0
    local count = 0
    local exp = 1e-7
	for i = x, y - step + exp, step do
		sum = sum + step * (f(i + step) + f(i)) * 0.5
        count = count + 1
	end
    -- print(count)
	return sum
end

print(integral(function (x) return x end, 0, 6))
print(integral(function (x) return x * x - 2 *x + 1 end, 0, 2))
print(integral(math.sin, 0, math.pi))
print(integral(math.cos, 0, math.pi))