local http  = require("socket.http")
local ltn12 = require("ltn12")
local json  = require("json")
require("util")

local github = {}

local projects = {}
projects["ravm"] = "endeav0r/ravm/master"
projects["rt"] = "endeav0r/Rainbows-And-Pwnies-Tools/master"
projects["rainpwn"] = "endeav0r/rainpwn/master"

local function github_api (url)
    local response = {}
    http.request {
        url = url,
        sink = ltn12.sink.table(response)
    }
    local raw = table.concat(response)
    return json.decode(raw)
end

local function github_lastcommit (project)
    local commits = github_api("https://github.com/api/v2/json/commits/list/" .. project)
    if commits == nil then
        return "error getting commits"
    end
    return commits["commits"][1]["committer"]["name"] .. ": " ..
           commits["commits"][1]["message"]
end

local function github_privmsg (input, msg)
    pieces = string.split(" ", input)
    if pieces[1] == "!lastcommit" then
        if projects[pieces[2]] == nil then
            return "non-existant project"
        else
            return github_lastcommit(projects[pieces[2]])
        end
    end     
    return nil
end

github.api         = github_api
github.last_commit = github_lastcommit
github.privmsg     = github_privmsg

return github
