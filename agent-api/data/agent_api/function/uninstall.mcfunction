# Removes the pack's scoreboard and storage.
# Afterwards, disable the data pack with /datapack disable and run /reload.
scoreboard objectives remove agent_api.config
data remove storage agent_api:in args
data remove storage agent_api:out result
tellraw @s [{text:"[Agent API] ",color:"gold"},"Uninstalled. Now disable the data pack and run /reload."]
