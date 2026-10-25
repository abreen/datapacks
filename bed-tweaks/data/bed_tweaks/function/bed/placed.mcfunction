# Advancement reward: runs as a player who just placed a bed. The trigger
# doesn't say where, so follow their line of sight to the new bed. The foot
# is placed in the clicked spot and the head beyond it, so the foot comes first
advancement revoke @s only bed_tweaks:placed_bed
execute store result score #steps bed_tweaks.tmp run attribute @s minecraft:block_interaction_range get 20
scoreboard players add #steps bed_tweaks.tmp 20
execute anchored eyes positioned ^ ^ ^ run function bed_tweaks:bed/ray
