# Usage: /function boltcatcher:config/set_kill_bonus {seconds:5}
$scoreboard players set #new boltcatcher.tmp $(seconds)
execute if score #new boltcatcher.tmp matches ..-1 run scoreboard players set #new boltcatcher.tmp 0
execute if score #new boltcatcher.tmp matches 601.. run scoreboard players set #new boltcatcher.tmp 600
scoreboard players operation #kill_bonus boltcatcher.config = #new boltcatcher.tmp
function boltcatcher:config/show
