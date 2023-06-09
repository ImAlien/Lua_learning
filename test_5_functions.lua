function a()
    return 3
end

function a(b)
    return b
    
end

print(a()) --> nil

print(a(3)) --> 3


function foo0()
end

a, b = foo0(), 1, 2  --> nil 1
print(a, b)


