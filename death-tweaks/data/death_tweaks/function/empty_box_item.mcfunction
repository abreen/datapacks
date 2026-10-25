# Drops the first item left in death_tweaks:tmp box, then the rest
summon item ~ ~ ~ {Item:{id:"minecraft:stone",count:1},PickupDelay:40s,Tags:["death_tweaks.content","death_tweaks.lost","death_tweaks.dropped"]}
data modify entity @e[type=item,tag=death_tweaks.content,limit=1] Item set from storage death_tweaks:tmp box[0].item
execute if entity @e[type=item,tag=death_tweaks.content] run scoreboard players add #box_dropped death_tweaks.tmp 1
tag @e[type=item,tag=death_tweaks.content] remove death_tweaks.content
data remove storage death_tweaks:tmp box[0]
execute if data storage death_tweaks:tmp box[0] run function death_tweaks:empty_box_item
