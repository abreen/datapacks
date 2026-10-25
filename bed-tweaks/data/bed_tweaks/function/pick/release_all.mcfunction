# For uninstall: releases every chunk the pack force-loaded
execute unless data storage bed_tweaks:tmp waiting[0] run return 0
data modify storage bed_tweaks:tmp target set from storage bed_tweaks:tmp waiting[0]
execute if data storage bed_tweaks:tmp target{forced:1b} run function bed_tweaks:pick/release with storage bed_tweaks:tmp target
data remove storage bed_tweaks:tmp waiting[0]
function bed_tweaks:pick/release_all
