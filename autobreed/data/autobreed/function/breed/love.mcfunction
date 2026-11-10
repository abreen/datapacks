# Love mode, as if fed. Vanilla does the rest: the baby, the XP and the
# parents' 5-minute cooldown.
data modify entity @s InLove set value 600
scoreboard players operation @s autobreed.wait = #interval autobreed.config
tag @s add autobreed.paired
scoreboard players set #paired autobreed.tmp 1
