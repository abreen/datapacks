# Adds or removes the label here to match the setting. Runs every tick, so
# beds placed before labels were turned on get one too
execute if score #labels bed_tweaks.config matches 0 run return run kill @e[type=text_display,tag=bed_tweaks.label,distance=..0.05]
execute if entity @e[type=text_display,tag=bed_tweaks.label,distance=..0.05] run return 0
execute store result storage bed_tweaks:tmp args.bed int 1 run scoreboard players get @s bed_tweaks.bed
function bed_tweaks:bed/summon_label with storage bed_tweaks:tmp args
