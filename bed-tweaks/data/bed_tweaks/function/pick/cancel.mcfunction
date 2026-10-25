# Abandons the player's wait for a bed, e.g. because they died
data modify storage bed_tweaks:tmp args.owner set from entity @s UUID
function bed_tweaks:pick/load_target with storage bed_tweaks:tmp args
execute if data storage bed_tweaks:tmp target run function bed_tweaks:pick/stop
scoreboard players reset @s bed_tweaks.wait
