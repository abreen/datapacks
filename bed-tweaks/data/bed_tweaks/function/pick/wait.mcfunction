# Runs each tick as a player waiting to be moved to the bed they picked
scoreboard players add @s bed_tweaks.wait 1
data modify storage bed_tweaks:tmp args.owner set from entity @s UUID
function bed_tweaks:pick/load_target with storage bed_tweaks:tmp args
execute unless data storage bed_tweaks:tmp target run return run scoreboard players reset @s bed_tweaks.wait
function bed_tweaks:pick/reach with storage bed_tweaks:tmp target
