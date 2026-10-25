# Runs as a player who has died since the last tick
scoreboard players reset @s stack_loss.deaths
tag @s add stack_loss.dying

# Use the recorded death location rather than the player's position, since
# the player may already have respawned (e.g. with immediate_respawn on)
data remove storage stack_loss:tmp death
data modify storage stack_loss:tmp death.dimension set from entity @s LastDeathLocation.dimension
data modify storage stack_loss:tmp death.x set from entity @s LastDeathLocation.pos[0]
data modify storage stack_loss:tmp death.y set from entity @s LastDeathLocation.pos[1]
data modify storage stack_loss:tmp death.z set from entity @s LastDeathLocation.pos[2]
scoreboard players set #xp_lost_levels stack_loss.tmp 0
scoreboard players set #xp_lost_points stack_loss.tmp 0
function stack_loss:at_death_location with storage stack_loss:tmp death

function stack_loss:notify

# Remove the temporary copies of destroyed stacks and untag real drops
kill @e[type=item,tag=stack_loss.lost,tag=!stack_loss.dropped]
tag @e[type=item,tag=stack_loss.dropped] remove stack_loss.lost
tag @e[type=item,tag=stack_loss.dropped] remove stack_loss.dropped
tag @s remove stack_loss.dying
