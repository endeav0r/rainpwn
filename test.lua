local haxathon = require("modules.haxathon")
local github   = require("modules.github")

print(haxathon.command("!haxathon jianmin"), "stats for jianmin")
print(haxathon.command("!haxathon jianminsd"), "should be nil")
print(haxathon.command("!haxathon"), "should be nil")

print(github.command("!lastcommit ravm"), "ravm commits")
print(github.command("!lastcommit rt"), "rt commits")
print(github.command("!lastcommit rt2"), "invalid project")
print(github.command("!lastcommit rainpwn"), "rainpwn commits")
print(github.command("!lastcommit"), "invalid commits")
