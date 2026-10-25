# Copies the player's beds into mine. Argument: owner (a UUID int array)
data modify storage bed_tweaks:tmp mine set value []
$data modify storage bed_tweaks:tmp mine append from storage bed_tweaks:beds list[{owner:$(owner)}]
