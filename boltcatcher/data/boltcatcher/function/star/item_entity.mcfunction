# Runs as and at a dropped star
execute store result score #expires boltcatcher.tmp run data get entity @s Item.components."minecraft:custom_data".boltcatcher.expires
execute store result score #max boltcatcher.tmp run data get entity @s Item.components."minecraft:max_damage"
scoreboard players set #bonus boltcatcher.tmp 0
function boltcatcher:star/compute
execute if score #rem boltcatcher.tmp matches ..0 run return run function boltcatcher:star/fizzle_entity
execute store result entity @s Item.components."minecraft:damage" int 1 run scoreboard players get #damage boltcatcher.tmp
