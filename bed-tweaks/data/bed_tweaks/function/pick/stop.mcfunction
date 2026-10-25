# Stops waiting for the bed in target, releasing its chunk
execute if data storage bed_tweaks:tmp target{forced:1b} run function bed_tweaks:pick/release with storage bed_tweaks:tmp target
function bed_tweaks:pick/unwait with storage bed_tweaks:tmp target
scoreboard players reset @s bed_tweaks.wait
