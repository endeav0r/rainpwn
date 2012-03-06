local bot      = require("bot")
local config   = require("config")
local github   = require("modules.github")
local haxathon = require("modules.haxathon")
local log      = require("modules.log")
local static   = require("modules.static")
local admin    = require("modules.admin")

b = bot:new("irc.freenode.net", 6667, config.USERNAME)
b:connect()
if config.PASSWORD ~= nil then
    b:privmsg("nickserv", "identify " .. config.PASSWORD)
end
for k, channel in pairs(config.CHANNELS) do b:join(channel) end


local modules = {}
modules["haxathon"] = haxathon
modules["github"]   = github
modules["log"]      = log
modules["static"]   = static
modules["admin"]    = admin


function command (text, msg)
    local responses = {}
    for k, module in pairs(modules) do

        -- send input to this module
        local response
        if msg.command == "PRIVMSG" and module.privmsg ~= nil then
            response = module.privmsg(text, msg)
        elseif msg.command == "NOTICE" and module.notice ~= nil then
            response = module.notice(text, msg)
        else
            response = nil
        end

        -- save responses to spit back out to the user
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
        if msg.command == "PRIVMSG" or msg.command == "NOTICE" then
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

