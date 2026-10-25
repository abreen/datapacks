# Runs as a player who clicked a bed in the menu
execute store result storage bed_tweaks:tmp args.bed int 1 run scoreboard players get @s bed_tweaks.pick
scoreboard players reset @s bed_tweaks.pick
execute unless score @s bed_tweaks.window matches 1.. run return 0
data modify storage bed_tweaks:tmp args.owner set from entity @s UUID
function bed_tweaks:pick/find with storage bed_tweaks:tmp args
