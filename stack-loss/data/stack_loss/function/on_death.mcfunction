# Runs as a player who has died since the last tick
scoreboard players reset @s stack_loss.deaths

# Use the recorded death location rather than the player's position, since
# the player may already have respawned (e.g. with immediate_respawn on)
data remove storage stack_loss:tmp death
data modify storage stack_loss:tmp death.dimension set from entity @s LastDeathLocation.dimension
data modify storage stack_loss:tmp death.x set from entity @s LastDeathLocation.pos[0]
data modify storage stack_loss:tmp death.y set from entity @s LastDeathLocation.pos[1]
data modify storage stack_loss:tmp death.z set from entity @s LastDeathLocation.pos[2]
function stack_loss:at_death_location with storage stack_loss:tmp death
