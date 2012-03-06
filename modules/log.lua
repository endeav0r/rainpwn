local http   = require("socket.http")
local ltn12  = require("ltn12")
local json   = require("json")
local config = require("config")
require("util")

local log = {}

local function log_command (input, msg)
    local log_line = "[" .. os.date("%d-%b-%Y %H:%M") .. "] <" ..
                     msg.sender .. "> " .. input
    local filename
    if msg.args[1] == USERNAME then
        filename = config.LOG_PATH .. msg.sender
    else
        filename = config.LOG_PATH .. msg.args[1]
    end
    
    local fh = io.open(filename, "a")
    fh:write(log_line .. "\n")
    fh:close()
    
    return nil
end

log.command = log_command

return log
