# Runs as a bed's marker. The label floats over the middle of the bed, where
# the foot meets the head
execute if block ~ ~ ~ #minecraft:beds[facing=north] positioned ~ ~1 ~-0.5 run return run function bed_tweaks:bed/label_here
execute if block ~ ~ ~ #minecraft:beds[facing=south] positioned ~ ~1 ~0.5 run return run function bed_tweaks:bed/label_here
execute if block ~ ~ ~ #minecraft:beds[facing=west] positioned ~-0.5 ~1 ~ run return run function bed_tweaks:bed/label_here
execute if block ~ ~ ~ #minecraft:beds[facing=east] positioned ~0.5 ~1 ~ run function bed_tweaks:bed/label_here
