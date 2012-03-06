local bot      = require("bot")
local config   = require("config")
local github   = require("modules.github")
local haxathon = require("modules.haxathon")
local log      = require("modules.log")

b = bot:new("irc.freenode.net", 6667, config.USERNAME)
b:connect()
if config.PASSWORD ~= nil then
    b:privmsg("nickserv", "identify " .. config.PASSWORD)
end
for k, channel in pairs(config.CHANNELS) do b:join(channel) end

local modules = {}
modules["haxathon"] = haxathon.command
modules["github"] = github.command
modules["log"] = log.command

function command (text, msg)
    local responses = {}
    for k, exec in pairs(modules) do
        local response = exec(text, msg)
        if response ~= nil then
            print(response)
            table.insert(responses, response)
        end
    end
    return responses
end

while true do
    local msg = b:recv()
    if msg ~= nil then
        if msg.command == "PRIVMSG" then
            local responses = command(msg.final, msg)
            for k, response in pairs(responses) do
                if msg.args[1] == USERNAME then
                    b:privmsg(msg.sender, response)
                else
                    b:privmsg(msg.args[1], response)
                end
            end
        end
    end
end

