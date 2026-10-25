# Moves the player to a safe spot by the bed whose foot is here, returning 1,
# or fails if there is none. Like vanilla, a spot beside the bed is better
# than standing on it
execute if function bed_tweaks:pick/beside run return 1
execute if block ~ ~ ~ #minecraft:beds[facing=north] positioned ~ ~ ~-1 if function bed_tweaks:pick/beside run return 1
execute if block ~ ~ ~ #minecraft:beds[facing=south] positioned ~ ~ ~1 if function bed_tweaks:pick/beside run return 1
execute if block ~ ~ ~ #minecraft:beds[facing=west] positioned ~-1 ~ ~ if function bed_tweaks:pick/beside run return 1
execute if block ~ ~ ~ #minecraft:beds[facing=east] positioned ~1 ~ ~ if function bed_tweaks:pick/beside run return 1
# On top of the bed, which is 9/16 of a block tall
execute unless block ~ ~1 ~ #minecraft:blocks_motion unless block ~ ~2 ~ #minecraft:blocks_motion positioned ~ ~0.5625 ~ run return run function bed_tweaks:pick/teleport
return fail
