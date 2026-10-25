# Adds mine[0] to the menu, saying how far away it is
data modify storage bed_tweaks:tmp cmp set from storage bed_tweaks:tmp here
execute store success score #elsewhere bed_tweaks.tmp run data modify storage bed_tweaks:tmp cmp set from storage bed_tweaks:tmp mine[0].dim
execute if score #elsewhere bed_tweaks.tmp matches 1 run data modify storage bed_tweaks:tmp mine[0].where set value "in another dimension"
execute if score #elsewhere bed_tweaks.tmp matches 1 run return run function bed_tweaks:pick/menu_add with storage bed_tweaks:tmp mine[0]

function bed_tweaks:pick/distance
# Leave out the bed the player is already at
execute if score #dist bed_tweaks.tmp matches ..3 run return 0
execute store result storage bed_tweaks:tmp mine[0].dist int 1 run scoreboard players get #dist bed_tweaks.tmp
function bed_tweaks:pick/menu_where with storage bed_tweaks:tmp mine[0]
function bed_tweaks:pick/menu_add with storage bed_tweaks:tmp mine[0]
