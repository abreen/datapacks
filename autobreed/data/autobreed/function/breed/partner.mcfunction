# Run as and at the partner. A pair only breeds on its own: no other adult
# may be within 3 blocks of either of them.
tag @s add autobreed.mate
execute store result score #crowding autobreed.tmp run function autobreed:breed/crowding_in
execute at @e[tag=autobreed.first,limit=1] store result score #others autobreed.tmp run function autobreed:breed/crowding_in
scoreboard players operation #crowding autobreed.tmp += #others autobreed.tmp
tag @s remove autobreed.mate
execute if score #crowding autobreed.tmp matches 1.. run return 0
# The baby can spawn beside either parent, so its herd needs room as well
execute if function autobreed:breed/crowded run return 0
function autobreed:breed/love
