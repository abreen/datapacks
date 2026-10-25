# The pack handles item loss itself, so vanilla must keep everything
gamerule keep_inventory true

scoreboard objectives add stack_loss.deaths deathCount
scoreboard objectives add stack_loss.config dummy
scoreboard objectives add stack_loss.tmp dummy

# Defaults, only applied if not already configured
execute unless score #chance stack_loss.config matches 0.. run scoreboard players set #chance stack_loss.config 30
execute unless score #destroy stack_loss.config matches 0.. run scoreboard players set #destroy stack_loss.config 0
execute unless score #vanishing_curse stack_loss.config matches 0.. run scoreboard players set #vanishing_curse stack_loss.config 1
