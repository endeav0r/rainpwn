local socket = require("socket")

luabot = {}
luabot.mt = {}
luabot.mt.__index = luabot

function luabot:new (host, port, nick)
    local bot = {host = host,
                 port = port,
                 nick = nick}
    return setmetatable(bot, luabot.mt)
end

function luabot:connect ()
    self.client = socket.connect(self.host, self.port)
    print("connected")
    self:send("NICK " .. self.nick)
    self:send("USER " .. self.nick .. " * 0 :" .. self.nick)
end

function luabot:recv ()
    local raw = self.client:receive()
    local msg = {}
    local index = 0

    print(raw)

    -- msg.source
    if string.sub(raw, 1, 1) == ":" then
        index = string.find(raw, " ")
        msg.source = string.sub(raw, 2, index - 1)
        raw = string.sub(raw, index + 1)
        index = string.find(msg.source, "!")
        if index == nil then
            msg.sender = nil
        else
            msg.sender = string.sub(msg.source, 1, index - 1)
        end
    end

    -- msg.command
    index = string.find(raw, " ")
    msg.command = string.sub(raw, 1, index - 1)
    raw = string.sub(raw, index + 1)

    -- msg.args
    msg.args = {}
    while #raw > 1 and string.sub(raw, 1, 1) ~= ":" do
        index = string.find(raw, " ")
        if index == nil then
            return nil
        end
        table.insert(msg.args, string.sub(raw, 1, index - 1))
        raw = string.sub(raw, index + 1)
    end

    -- msg.final, skip leading ":"
    msg.final = string.sub(raw, 2)

    -- handle pings
    if msg.command == "PING" then
        self:pong(msg.final)
    end

    return msg
end

function luabot:send (message)
    print(message)
    self.client:send(message .. "\r\n")
end

function luabot:privmsg (destination, message)
    self:send("PRIVMSG " .. destination .. " :" .. message)
end

function luabot:join (channel)
    self:send("JOIN " .. channel)
end

function luabot:pong (message)
    local msg = "PONG :" .. message
    self:send(msg)
end

return luabot
