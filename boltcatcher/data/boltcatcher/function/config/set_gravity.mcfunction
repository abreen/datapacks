# Usage: /function boltcatcher:config/set_gravity {percent:40}
# Gravity while charged, as a percentage of normal. Zero would let a jump
# drift up for good, so 5% is the least.
$scoreboard players set #new boltcatcher.tmp $(percent)
execute if score #new boltcatcher.tmp matches ..4 run scoreboard players set #new boltcatcher.tmp 5
execute if score #new boltcatcher.tmp matches 101.. run scoreboard players set #new boltcatcher.tmp 100
scoreboard players operation #gravity_percent boltcatcher.config = #new boltcatcher.tmp
execute as @a[tag=boltcatcher.charged] run function boltcatcher:power/scaled
function boltcatcher:config/show
