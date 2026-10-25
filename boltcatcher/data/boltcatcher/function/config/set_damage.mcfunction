# Usage: /function boltcatcher:config/set_damage {percent:300}
# Melee damage while charged, as a percentage of normal
$scoreboard players set #new boltcatcher.tmp $(percent)
execute if score #new boltcatcher.tmp matches ..99 run scoreboard players set #new boltcatcher.tmp 100
execute if score #new boltcatcher.tmp matches 1001.. run scoreboard players set #new boltcatcher.tmp 1000
scoreboard players operation #damage_percent boltcatcher.config = #new boltcatcher.tmp
execute as @a[tag=boltcatcher.charged] run function boltcatcher:power/scaled
function boltcatcher:config/show
