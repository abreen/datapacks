scoreboard players add #timer autobreed.tmp 1
execute if score #timer autobreed.tmp matches 20.. run function autobreed:second
# Checked every tick so the orbs are caught the tick after they spawn
execute as @e[type=#autobreed:livestock,tag=autobreed.paired] at @s run function autobreed:xp/watch
