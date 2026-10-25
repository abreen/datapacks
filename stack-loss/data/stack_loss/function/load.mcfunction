# The pack handles item loss itself, so vanilla must keep everything
gamerule keep_inventory true

scoreboard objectives add stack_loss.deaths deathCount
scoreboard objectives add stack_loss.config dummy
scoreboard objectives add stack_loss.tmp dummy

# Defaults, only applied if not already configured
execute unless score #chance stack_loss.config matches 0.. run scoreboard players set #chance stack_loss.config 30
execute unless score #destroy stack_loss.config matches 0.. run scoreboard players set #destroy stack_loss.config 0
execute unless score #vanishing_curse stack_loss.config matches 0.. run scoreboard players set #vanishing_curse stack_loss.config 1
execute unless score #xp_loss stack_loss.config matches 0.. run scoreboard players set #xp_loss stack_loss.config 30

# Constants for scoreboard math
scoreboard players set #-1 stack_loss.tmp -1
scoreboard players set #2 stack_loss.tmp 2
scoreboard players set #5 stack_loss.tmp 5
scoreboard players set #9 stack_loss.tmp 9
scoreboard players set #100 stack_loss.tmp 100
scoreboard players set #32767 stack_loss.tmp 32767
