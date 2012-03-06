local http  = require("socket.http")
local ltn12 = require("ltn12")
local json  = require("json")
require("util")

local haxathon = {}

local function haxathon_score (username)
    local response = {}
    local b, c, h = http.request {
        url = "http://haxathon.rainbowsandpwnies.com/?rpc",
        sink = ltn12.sink.table(response)
    }
    local raw = table.concat(response)
    local users = json.decode(raw)
    if users[username] == nil then
        return nil
    else
        return username .. " (score " .. users[username]["score"] ..
               ") (year " .. users[username]["academic_year"] .. ")"
    end
end

local function haxathon_privmsg (input, msg)
    pieces = string.split(" ", input)
    if pieces[1] == "!haxathon" then
        return haxathon_score(pieces[2])
    end     
    return nil
end

haxathon.scores  = haxathon_scores
haxathon.privmsg = haxathon_privmsg

return haxathon
