# Removes the pack's scoreboard and storage.
# Afterwards, disable the data pack with /datapack disable and run /reload.
scoreboard objectives remove claude_api.config
data remove storage claude_api:in args
data remove storage claude_api:out result
data remove storage claude_api:tmp entity
tellraw @s [{text:"[Claude API] ",color:"gold"},"Uninstalled. Now disable the data pack and run /reload."]
