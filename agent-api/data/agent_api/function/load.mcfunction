scoreboard objectives add agent_api.config dummy

# Defaults, only applied if not already configured
execute unless score #enabled agent_api.config matches 0.. run scoreboard players set #enabled agent_api.config 1
