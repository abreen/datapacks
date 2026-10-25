# Runs as the marker of a bed that is gone
execute store result storage bed_tweaks:tmp args.bed int 1 run scoreboard players get @s bed_tweaks.bed
function bed_tweaks:bed/forget with storage bed_tweaks:tmp args
function bed_tweaks:bed/remove
