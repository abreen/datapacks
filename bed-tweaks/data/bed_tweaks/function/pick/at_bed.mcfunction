# Runs as the player, at the foot of the bed they picked, once its chunk is loaded
execute unless block ~ ~ ~ #minecraft:beds[part=foot] run return run function bed_tweaks:pick/bed_gone
execute unless function bed_tweaks:pick/stand_up run return run function bed_tweaks:pick/give_up_obstructed
function bed_tweaks:pick/close
function bed_tweaks:pick/arrived with storage bed_tweaks:tmp target
