# One 0.05-block step. Beds that already have a marker are older ones the
# ray passed over
execute if block ~ ~ ~ #minecraft:beds[part=foot] align xyz positioned ~0.5 ~ ~0.5 unless entity @e[type=marker,tag=bed_tweaks.bed,distance=..0.1] run return run function bed_tweaks:bed/register
scoreboard players remove #steps bed_tweaks.tmp 1
execute if score #steps bed_tweaks.tmp matches 1.. positioned ^ ^ ^0.05 run function bed_tweaks:bed/ray
