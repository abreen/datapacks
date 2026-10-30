scoreboard objectives add claude_api.config dummy

# Defaults, only applied if not already configured
execute unless score #enabled claude_api.config matches 0.. run scoreboard players set #enabled claude_api.config 1
