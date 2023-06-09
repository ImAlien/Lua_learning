b = 2
do
	local _ENV = {print = print, a = 14}
	print(b) --> 14
end
print(b) --> 2 (back to the original _ENV)