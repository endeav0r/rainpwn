-- http://lua-users.org/wiki/SplitJoin
function string.split(delimiter, text)
    local list = {}
    local pos = 1
    if string.find("", delimiter, 1) then -- this would result in endless loops
        error("delimiter matches empty string!")
    end
    while 1 do
        local first, last = string.find(text, delimiter, pos)
        if first then -- found?
            table.insert(list, string.sub(text, pos, first-1))
            pos = last+1
        else
            table.insert(list, string.sub(text, pos))
            break
        end
    end
    return list
end


function json_dump (t, depth)
    local whitespace = ""

    if depth > 10 then
        return
    end
    
    for d=0,depth do
        whitespace = whitespace .. " "
    end
        
    for k,v in pairs(t) do
        if type(v) == "table" then
            print(whitespace .. k)
            json_dump(v, depth + 1)
        else
            print(whitespace .. k .. " " .. v)
        end 
    end
end
