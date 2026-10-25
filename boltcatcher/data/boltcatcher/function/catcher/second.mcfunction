# Runs as and at a catcher's marker, inside the hopper
execute unless block ~ ~ ~ minecraft:hopper run return run kill @s
data modify storage boltcatcher:tmp stars set value []
data modify storage boltcatcher:tmp stars append from block ~ ~ ~ Items[{components:{"minecraft:custom_data":{boltcatcher:{}}}}]
execute unless data storage boltcatcher:tmp stars[0] run return run kill @s
scoreboard players set #bonus boltcatcher.tmp 0
data modify storage boltcatcher:tmp args.target set value "block ~ ~ ~"
function boltcatcher:star/each
