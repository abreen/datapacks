scoreboard objectives add autobreed.config dummy
scoreboard objectives add autobreed.tmp dummy
# On each animal: seconds until it next tries to breed
scoreboard objectives add autobreed.wait dummy

# Defaults, only applied if not already configured
execute unless score #interval autobreed.config matches 0.. run scoreboard players set #interval autobreed.config 120
execute unless score #chance autobreed.config matches 0.. run scoreboard players set #chance autobreed.config 50
execute unless score #limit autobreed.config matches 0.. run scoreboard players set #limit autobreed.config 32
# Off by default: animals that breed themselves would be a free XP farm
execute unless score #xp_orbs autobreed.config matches 0.. run scoreboard players set #xp_orbs autobreed.config 0

# Constants for scoreboard math
scoreboard players set #2 autobreed.tmp 2
