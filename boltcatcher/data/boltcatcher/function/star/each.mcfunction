# Updates stars[0] and recurses through the rest of the list. args.target
# says where they are ("entity @s" or "block ~ ~ ~"); #bonus is extra charge
# in ticks for each one.
execute unless data storage boltcatcher:tmp stars[0].slot run function boltcatcher:star/slot with storage boltcatcher:tmp stars[0]
data modify storage boltcatcher:tmp args.slot set from storage boltcatcher:tmp stars[0].slot
execute store result score #expires boltcatcher.tmp run data get storage boltcatcher:tmp stars[0].components."minecraft:custom_data".boltcatcher.expires
execute store result score #max boltcatcher.tmp run data get storage boltcatcher:tmp stars[0].components."minecraft:max_damage"
function boltcatcher:star/compute
execute if score #rem boltcatcher.tmp matches ..0 run function boltcatcher:star/fizzle with storage boltcatcher:tmp args
execute if score #rem boltcatcher.tmp matches 1.. run function boltcatcher:star/write
# The fullest star drives the holder's boss bar
execute if score #secs boltcatcher.tmp > #best boltcatcher.tmp run scoreboard players operation #best_max boltcatcher.tmp = #max boltcatcher.tmp
scoreboard players operation #best boltcatcher.tmp > #secs boltcatcher.tmp
data remove storage boltcatcher:tmp stars[0]
execute if data storage boltcatcher:tmp stars[0] run function boltcatcher:star/each
