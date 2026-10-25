# The pack handles item loss itself, so vanilla must keep everything
gamerule keep_inventory true

scoreboard objectives add death_tweaks.deaths deathCount
scoreboard objectives add death_tweaks.config dummy
scoreboard objectives add death_tweaks.tmp dummy

# Defaults, only applied if not already configured
execute unless score #chance death_tweaks.config matches 0.. run scoreboard players set #chance death_tweaks.config 30
execute unless score #destroy death_tweaks.config matches 0.. run scoreboard players set #destroy death_tweaks.config 0
execute unless score #vanishing_curse death_tweaks.config matches 0.. run scoreboard players set #vanishing_curse death_tweaks.config 1
execute unless score #xp_loss death_tweaks.config matches 0.. run scoreboard players set #xp_loss death_tweaks.config 30
execute unless score #partial_stacks death_tweaks.config matches 0.. run scoreboard players set #partial_stacks death_tweaks.config 1

# Constants for scoreboard math
scoreboard players set #-1 death_tweaks.tmp -1
scoreboard players set #2 death_tweaks.tmp 2
scoreboard players set #5 death_tweaks.tmp 5
scoreboard players set #9 death_tweaks.tmp 9
scoreboard players set #100 death_tweaks.tmp 100
scoreboard players set #32767 death_tweaks.tmp 32767
