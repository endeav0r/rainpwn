local config = require("config")
require("util")

--[[
    Admin commands are kind of tricky because we need to insure the user is
    logged in by performing a subsequent request against nickserv. We accomplish
    this be saving admin commands to a queue. We then send the necessary
    query to nickserv. If nickserv tells us the user is logged in, we perform
    the command.
    Each time the bot sees a message from a user, it clears their command
    queue.
]]--

local admin = {}
local command_queue = {}

local function admin_process (command)
    if command[1] == "kick" then
        b:kick(command[2], command[3])
    elseif command[1] == "join" then
        b:join(command[2])
    elseif command[1] == "part" then
        b:part(command[2])
    elseif command[1] == "op" then
        b:op(command[2], command[3])
    end
end

local function admin_command (input, msg)
    -- clear this user's old commands (this keeps old commands from lurking)
    command_queue[msg.sender] = nil
    
    pieces = string.split(" ", input)

    -- add admin commands to queue
    if pieces[1] == "!admin" then
        -- create command in queue for user
        command_queue[msg.sender] = {}
        for i=2,#pieces do
            table.insert(command_queue[msg.sender], pieces[i])
        end

        -- ask nickserv if this user is authed
        b:privmsg("nickserv", "ACC " .. msg.sender)
    end

    -- ACC responses from nickserv
    if msg.sender == "nickserv" then
        if pieces[2] == "ACC" and pieces[3] == "3" then
            admin_process(command_queue[msg.sender])
            command_queue[msg.sender] = nil
        end
    end     
            
    return nil
end

haxathon.scores = haxathon_scores
haxathon.command = haxathon_command

return haxathon
