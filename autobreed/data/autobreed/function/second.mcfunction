scoreboard players set #timer autobreed.tmp 0
# New animals start at a random point in the interval, so checks are spread
# out instead of all landing on the same second
execute as @e[type=#autobreed:livestock] unless score @s autobreed.wait matches -2147483648.. run function autobreed:start_wait
scoreboard players remove @e[type=#autobreed:livestock,scores={autobreed.wait=1..}] autobreed.wait 1
execute as @e[type=#autobreed:livestock,scores={autobreed.wait=..0}] at @s run function autobreed:breed/try
