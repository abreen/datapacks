# Run as and at an animal the pack put in love mode. Vanilla clears InLove on
# both parents when the baby spawns, and starts their breeding cooldown (Age
# above 0); if love just ran out with no partner, Age is still 0.
execute unless entity @s[nbt={InLove:0}] run return 0
tag @s remove autobreed.paired
execute if score #xp_orbs autobreed.config matches 1 run return 0
execute if entity @s[nbt={Age:0}] run return 0
# The orbs spawn at one parent. Only brand-new single orbs go: a merged orb
# takes the younger Age, so an old orb a fresh one merged into has Count 2+.
execute as @e[type=minecraft:experience_orb,distance=..2] store result score @s autobreed.tmp run data get entity @s Age
kill @e[type=minecraft:experience_orb,distance=..2,scores={autobreed.tmp=..5},nbt={Count:1}]
