# Returns 1 if there are already #limit farm animals within 24 blocks of here.
# A wide radius caps a spread-out flock as a whole; a small one only limits
# density, so a flock keeps growing until it covers the land.
# Each pair the pack has put in love counts as one more, for the baby on its
# way, so several pairs starting at once can't overshoot the limit.
execute store result score #nearby autobreed.tmp if entity @e[type=#autobreed:livestock,distance=..24]
execute store result score #pending autobreed.tmp if entity @e[type=#autobreed:livestock,distance=..24,tag=autobreed.paired]
scoreboard players operation #pending autobreed.tmp /= #2 autobreed.tmp
scoreboard players operation #nearby autobreed.tmp += #pending autobreed.tmp
execute if score #nearby autobreed.tmp >= #limit autobreed.config run return 1
return 0
