# Takes #xp_loss percent of the player's total experience points, dropping
# them as orbs at the current position or deleting them, like lost stacks.
# Sets #xp_lost_levels and #xp_lost_points (reset by on_death) for notify
execute if score #xp_loss stack_loss.config matches ..0 run return 0

execute store result score #level stack_loss.tmp run xp query @s levels
execute store result score #points stack_loss.tmp run xp query @s points
# Above this the point math overflows; such levels only come from commands
execute if score #level stack_loss.tmp matches 15001.. run return 0

function stack_loss:xp/compute_loss
execute if score #xp_lost_points stack_loss.tmp matches ..0 run return 0

# Like lost stacks, if the orbs can't spawn (unloaded chunk) the experience is kept
execute if score #destroy stack_loss.config matches 0 unless function stack_loss:xp/drop_orbs run return run scoreboard players set #xp_lost_points stack_loss.tmp 0

# Reset to zero and add back what's kept, letting vanilla work out the level
execute store result storage stack_loss:tmp xp.points int 1 run scoreboard players get #xp_keep stack_loss.tmp
xp set @s 0 levels
xp set @s 0 points
function stack_loss:xp/add_points with storage stack_loss:tmp xp

execute store result score #xp_lost_levels stack_loss.tmp run xp query @s levels
scoreboard players operation #xp_lost_levels stack_loss.tmp -= #level stack_loss.tmp
scoreboard players operation #xp_lost_levels stack_loss.tmp *= #-1 stack_loss.tmp
