# Returns 1 if there are already #limit animals of this one's species within
# 24 blocks of here. Other species don't count, so a mixed pen doesn't stop
# every species once one of them fills it. A wide radius caps a spread-out
# flock as a whole; a small one only limits density, so a flock keeps
# growing until it covers the land.
function autobreed:breed/herd
# Each pair the pack has put in love counts as one more, for the baby on its
# way, so several pairs starting at once can't overshoot the limit.
execute store result score #nearby autobreed.tmp if entity @e[tag=autobreed.herd]
execute store result score #pending autobreed.tmp if entity @e[tag=autobreed.herd,tag=autobreed.paired]
tag @e[tag=autobreed.herd] remove autobreed.herd
scoreboard players operation #pending autobreed.tmp /= #2 autobreed.tmp
scoreboard players operation #nearby autobreed.tmp += #pending autobreed.tmp
execute if score #nearby autobreed.tmp >= #limit autobreed.config run return 1
return 0
