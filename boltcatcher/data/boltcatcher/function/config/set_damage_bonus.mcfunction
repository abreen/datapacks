# Usage: /function boltcatcher:config/set_damage_bonus {seconds:2}
$scoreboard players set #new boltcatcher.tmp $(seconds)
execute if score #new boltcatcher.tmp matches ..-1 run scoreboard players set #new boltcatcher.tmp 0
execute if score #new boltcatcher.tmp matches 61.. run scoreboard players set #new boltcatcher.tmp 60
scoreboard players operation #damage_bonus boltcatcher.config = #new boltcatcher.tmp
function boltcatcher:config/show
