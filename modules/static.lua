require("util")

local static = {}

local function static_command (input, msg)
    pieces = string.split(" ", input)
    if pieces[1] == "!help" then
        return "rainpwn bot | " ..
               "source available https://github.com/endeav0r/rainpwn"
    end     
    return nil
end

static.command = static_command

return static
