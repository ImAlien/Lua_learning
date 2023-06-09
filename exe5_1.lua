function concatString(...)
    return table.concat(table.pack(...))
end

print(concatString("hello","world"))


