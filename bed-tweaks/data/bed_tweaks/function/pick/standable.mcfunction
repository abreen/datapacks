# Returns 1 if a player can safely stand here: two free blocks over solid
# ground, with nothing harmful. A spot over a chunk edge may not be loaded,
# and block checks there fail rather than answer
execute unless loaded ~ ~ ~ run return fail
execute if block ~ ~ ~ #minecraft:blocks_motion run return fail
execute if block ~ ~1 ~ #minecraft:blocks_motion run return fail
execute unless block ~ ~-1 ~ #minecraft:blocks_motion run return fail
execute if block ~ ~ ~ #minecraft:dangerous_for_teleportation run return fail
execute if block ~ ~-1 ~ #minecraft:dangerous_for_teleportation run return fail
execute if block ~ ~ ~ minecraft:lava run return fail
execute if block ~ ~1 ~ minecraft:lava run return fail
return 1
