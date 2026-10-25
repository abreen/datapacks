# Advancement reward: runs as a player who just placed a bed. The trigger
# doesn't say where, so follow their line of sight to the new bed. The foot
# is placed in the clicked spot and the head beyond it, so the foot comes first
advancement revoke @s only bed_tweaks:placed_bed
execute store result score #steps bed_tweaks.tmp run attribute @s minecraft:block_interaction_range get 20
scoreboard players add #steps bed_tweaks.tmp 20
scoreboard players operation #max_steps bed_tweaks.tmp = #steps bed_tweaks.tmp
# (execute if function can't pass macro arguments, hence the score)
execute store result score #found bed_tweaks.tmp anchored eyes positioned ^ ^ ^ run function bed_tweaks:bed/ray {check:"try"}
execute if score #found bed_tweaks.tmp matches 1 run return 1

# The ray samples points, so it misses a bed it only grazes (a click near
# the edge of a block). Go again, checking around each point
scoreboard players operation #steps bed_tweaks.tmp = #max_steps bed_tweaks.tmp
execute anchored eyes positioned ^ ^ ^ run function bed_tweaks:bed/ray {check:"try_near"}
