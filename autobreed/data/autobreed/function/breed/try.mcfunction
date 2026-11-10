# Run as and at an animal whose wait is over
scoreboard players operation @s autobreed.wait = #interval autobreed.config
execute unless entity @s[nbt={Age:0,InLove:0}] run return 0
execute if function autobreed:breed/crowded run return 0
execute store result score #roll autobreed.tmp run random value 1..100
execute if score #roll autobreed.tmp > #chance autobreed.config run return 0
scoreboard players set #paired autobreed.tmp 0
tag @s add autobreed.first
function autobreed:breed/pair
execute if score #paired autobreed.tmp matches 1 run function autobreed:breed/love
tag @s remove autobreed.first
