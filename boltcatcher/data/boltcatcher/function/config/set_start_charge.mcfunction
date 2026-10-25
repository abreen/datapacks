# Usage: /function boltcatcher:config/set_start_charge {seconds:120}
# A catch never starts above the maximum charge
$scoreboard players set #new boltcatcher.tmp $(seconds)
execute if score #new boltcatcher.tmp matches ..0 run scoreboard players set #new boltcatcher.tmp 1
execute if score #new boltcatcher.tmp matches 3601.. run scoreboard players set #new boltcatcher.tmp 3600
scoreboard players operation #start_charge boltcatcher.config = #new boltcatcher.tmp
function boltcatcher:config/show
