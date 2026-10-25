# Arguments: bed, owner
data remove storage bed_tweaks:tmp target
$data modify storage bed_tweaks:tmp target set from storage bed_tweaks:beds list[{bed:$(bed),owner:$(owner)}]
execute unless data storage bed_tweaks:tmp target run return run function bed_tweaks:pick/failed {message:"That bed is gone."}

# Remembered until the player has been moved. forced says whether the pack
# force-loaded the bed's chunk (1b) or it already was (2b)
data modify storage bed_tweaks:tmp target.forced set value 0b
$data remove storage bed_tweaks:tmp waiting[{owner:$(owner)}]
data modify storage bed_tweaks:tmp waiting append from storage bed_tweaks:tmp target
# The tick function's wait step makes the first attempt later this tick
scoreboard players set @s bed_tweaks.wait 0
