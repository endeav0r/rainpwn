require("util")

local static = {}

local function static_privmsg (input, msg)
    pieces = string.split(" ", input)
    if pieces[1] == "!help" then
        return "rainpwn bot | " ..
               "source available https://github.com/endeav0r/rainpwn"
    end     
    return nil
end

static.privmsg = static_privmsg

return static
