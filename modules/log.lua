local http   = require("socket.http")
local ltn12  = require("ltn12")
local json   = require("json")
local config = require("config")
require("util")

local log = {}

local function log_privmsg (input, msg)
    local log_line = "[" .. os.date("%d-%b-%Y %H:%M") .. "] <" ..
                     msg.sender .. "> " .. input
    local filename
    if msg.args[1] == config.USERNAME then
        return nil
        --filename = config.LOG_PATH .. msg.sender
    else
        filename = config.LOG_PATH .. msg.args[1]
    end
    
    local fh = io.open(filename, "a")
    fh:write(log_line .. "\n")
    fh:close()
    
    return nil
end

log.privmsg = log_privmsg

return log
