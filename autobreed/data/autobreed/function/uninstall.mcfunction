# Removes the pack's scoreboards. Afterwards, disable the pack with
# /datapack disable and run /reload.
tag @e[tag=autobreed.first] remove autobreed.first
tag @e[tag=autobreed.herd] remove autobreed.herd
tag @e[tag=autobreed.paired] remove autobreed.paired
scoreboard objectives remove autobreed.wait
scoreboard objectives remove autobreed.config
scoreboard objectives remove autobreed.tmp
tellraw @s [{text:"[Autobreed] ",color:"gold"},"Uninstalled. Now disable the data pack and run /reload."]
