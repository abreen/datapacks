# Registers the bed whose foot is in this block, unless it has a marker
# already (an older bed the ray passed over). Succeeds if it registered one
execute if block ~ ~ ~ #minecraft:beds[part=foot] align xyz positioned ~0.5 ~ ~0.5 unless entity @e[type=marker,tag=bed_tweaks.bed,distance=..0.1] run return run function bed_tweaks:bed/register
return fail
