# Force-loads the chunk at x, z unless it already is. Arguments: x, z, owner
$execute store success score #was_forced bed_tweaks.tmp run forceload query $(x) $(z)
$execute if score #was_forced bed_tweaks.tmp matches 0 run forceload add $(x) $(z)
$execute if score #was_forced bed_tweaks.tmp matches 0 run data modify storage bed_tweaks:tmp waiting[{owner:$(owner)}].forced set value 1b
$execute if score #was_forced bed_tweaks.tmp matches 1 run data modify storage bed_tweaks:tmp waiting[{owner:$(owner)}].forced set value 2b
