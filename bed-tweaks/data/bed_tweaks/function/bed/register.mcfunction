# Runs as the player, at the bottom center of their new bed's foot. Adds the
# bed to storage bed_tweaks:beds and marks it with a marker that removes it
# again if the bed is broken. Succeeds if it did
execute unless predicate bed_tweaks:beds_work run return 0

# Ids count up from 1. Markers left behind by an uninstall can't clash with
# them after a reinstall: they lost their scores and bed/check removes them
scoreboard players add #last bed_tweaks.bed 1
scoreboard players operation #bed bed_tweaks.tmp = #last bed_tweaks.bed
summon marker ~ ~ ~ {Tags:["bed_tweaks.bed","bed_tweaks.new"]}
scoreboard players operation @e[type=marker,tag=bed_tweaks.new] bed_tweaks.bed = #bed bed_tweaks.tmp

data remove storage bed_tweaks:tmp new
execute store result storage bed_tweaks:tmp new.bed int 1 run scoreboard players get #bed bed_tweaks.tmp
data modify storage bed_tweaks:tmp new.owner set from entity @s UUID
data modify storage bed_tweaks:tmp new.dim set from entity @s Dimension
execute store result storage bed_tweaks:tmp new.x int 1 run data get entity @e[type=marker,tag=bed_tweaks.new,limit=1] Pos[0]
execute store result storage bed_tweaks:tmp new.y int 1 run data get entity @e[type=marker,tag=bed_tweaks.new,limit=1] Pos[1]
execute store result storage bed_tweaks:tmp new.z int 1 run data get entity @e[type=marker,tag=bed_tweaks.new,limit=1] Pos[2]
tag @e[type=marker,tag=bed_tweaks.new] remove bed_tweaks.new
function bed_tweaks:bed/name
data modify storage bed_tweaks:beds list append from storage bed_tweaks:tmp new

tellraw @s {text:"You can now respawn at this bed.",color:"gray",italic:true}
return 1
