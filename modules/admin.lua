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

--[[
!kick <channel> <user>
!kick <user>
!join <channel>
!part <channel>
!part
!op <channel> <user>
!op <user>
!op
]]--


local function admin_check (nick)
    for i, admin in pairs(config.ADMIN_USERS) do
        if string.lower(nick) == string.lower(admin) then
            return true
        end 
    end
    return false
end


local function admin_process (command)

    if command[1] == "kick" then
        -- kick can be abbreviated
        if command[3] == nil then
            b:kick(command["target"], command[2])
        else
            b:kick(command[2], command[3])
        end
        
    elseif command[1] == "join" then
        b:join(command[2])
        
    elseif command[1] == "part" then
        if command[2] == nil then
            b:part(command["target"])
        else
            b:part(command[2])
        end
        
    elseif command[1] == "op" then
        if command[2] == nil then
            b:op(command["target"], command["sender"])
        elseif command[3] == nil then
            b:op(command["target"], command[2])
        else
            b:op(command[2], command[3])
        end
        
    end
end


local function admin_privmsg (input, msg)
    -- clear this user's old commands (this keeps old commands from lurking)
    command_queue[msg.sender] = nil
    
    pieces = string.split(" ", input)

    -- add admin commands to queue
    if pieces[1] == "!admin" then
        if not admin_check(msg.sender) then
            return "silly rabbit, trix are for admins"
        end
        
        -- create command in queue for user
        command_queue[msg.sender] = {}
        for i=2,#pieces do
            table.insert(command_queue[msg.sender], pieces[i])
        end

        -- if msg.args[1] != config.USERNAME then this command was sent to a
        -- channel. we'll save that information if we need it later on to
        -- abbreviate some commands
        if msg.args[1] ~= config.USERNAME then
            command_queue[msg.sender]['target'] = msg.args[1]
        end

        command_queue[msg.sender]['sender'] = msg.sender

        -- ask nickserv if this user is authed
        b:privmsg("nickserv", "ACC " .. msg.sender)
    end
    
    return nil
end


local function admin_notice (input, msg)
    -- clear this user's old commands (this keeps old commands from lurking)
    
    pieces = string.split(" ", input)

    -- ACC responses from nickserv
    if msg.sender == "nickserv" then
        if pieces[2] == "ACC" and pieces[3] == "3" then
            admin_process(command_queue[pieces[1]])
            command_queue[msg.sender] = nil
        end
    end     
            
    return nil
end

admin.command = admin_command
admin.privmsg = admin_privmsg
admin.notice  = admin_notice

return admin
