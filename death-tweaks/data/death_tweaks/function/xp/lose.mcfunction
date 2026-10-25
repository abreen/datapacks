# Takes #xp_loss percent of the player's total experience points, dropping
# them as orbs at the current position or deleting them, like lost stacks.
# Sets #xp_lost_levels and #xp_lost_points (reset by on_death) for notify
execute if score #xp_loss death_tweaks.config matches ..0 run return 0

execute store result score #level death_tweaks.tmp run xp query @s levels
execute store result score #points death_tweaks.tmp run xp query @s points
# Above this the point math overflows; such levels only come from commands
execute if score #level death_tweaks.tmp matches 15001.. run return 0

function death_tweaks:xp/compute_loss
execute if score #xp_lost_points death_tweaks.tmp matches ..0 run return 0

# Like lost stacks, if the orbs can't spawn (unloaded chunk) the experience is kept
execute if score #destroy death_tweaks.config matches 0 unless function death_tweaks:xp/drop_orbs run return run scoreboard players set #xp_lost_points death_tweaks.tmp 0

# Reset to zero and add back what's kept, letting vanilla work out the level
execute store result storage death_tweaks:tmp xp.points int 1 run scoreboard players get #xp_keep death_tweaks.tmp
xp set @s 0 levels
xp set @s 0 points
function death_tweaks:xp/add_points with storage death_tweaks:tmp xp

execute store result score #xp_lost_levels death_tweaks.tmp run xp query @s levels
scoreboard players operation #xp_lost_levels death_tweaks.tmp -= #level death_tweaks.tmp
scoreboard players operation #xp_lost_levels death_tweaks.tmp *= #-1 death_tweaks.tmp
