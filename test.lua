local haxathon = require("modules.haxathon")
local github   = require("modules.github")

print(haxathon.command("!haxathon jianmin"))
print(haxathon.command("!haxathon jianminsd"))
print(haxathon.command("!haxathon"))

print(github.command("!lastcommit ravm"))
print(github.command("!lastcommit rt"))
print(github.command("!lastcommit rt2"))
print(github.command("!lastcommit"))
