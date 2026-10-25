# Runs as a player who has died since the last tick
scoreboard players reset @s death_tweaks.deaths
tag @s add death_tweaks.dying

# Use the recorded death location rather than the player's position, since
# the player may already have respawned (e.g. with immediate_respawn on)
data remove storage death_tweaks:tmp death
data modify storage death_tweaks:tmp death.dimension set from entity @s LastDeathLocation.dimension
data modify storage death_tweaks:tmp death.x set from entity @s LastDeathLocation.pos[0]
data modify storage death_tweaks:tmp death.y set from entity @s LastDeathLocation.pos[1]
data modify storage death_tweaks:tmp death.z set from entity @s LastDeathLocation.pos[2]
function death_tweaks:chance
scoreboard players set #xp_lost_levels death_tweaks.tmp 0
scoreboard players set #xp_lost_points death_tweaks.tmp 0
function death_tweaks:at_death_location with storage death_tweaks:tmp death

function death_tweaks:notify

# Remove the temporary copies of destroyed stacks and untag real drops
kill @e[type=item,tag=death_tweaks.lost,tag=!death_tweaks.dropped]
tag @e[type=item,tag=death_tweaks.dropped] remove death_tweaks.lost
tag @e[type=item,tag=death_tweaks.dropped] remove death_tweaks.dropped
tag @s remove death_tweaks.dying
