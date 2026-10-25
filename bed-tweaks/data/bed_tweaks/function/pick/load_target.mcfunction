# Copies the player's entry in waiting into target. Argument: owner
data remove storage bed_tweaks:tmp target
$data modify storage bed_tweaks:tmp target set from storage bed_tweaks:tmp waiting[{owner:$(owner)}]
