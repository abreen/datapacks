# Usage: /function boltcatcher:config/set_speed {percent:200}
# Walking speed while charged, as a percentage of normal (sprinting adds
# its usual 30% on top)
$scoreboard players set #new boltcatcher.tmp $(percent)
execute if score #new boltcatcher.tmp matches ..99 run scoreboard players set #new boltcatcher.tmp 100
execute if score #new boltcatcher.tmp matches 501.. run scoreboard players set #new boltcatcher.tmp 500
scoreboard players operation #speed_percent boltcatcher.config = #new boltcatcher.tmp
execute as @a[tag=boltcatcher.charged] run function boltcatcher:power/scaled
function boltcatcher:config/show
