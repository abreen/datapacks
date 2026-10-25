# Adds each bed in mine to the menu
execute unless data storage bed_tweaks:tmp mine[0] run return 0
function bed_tweaks:pick/menu_entry
data remove storage bed_tweaks:tmp mine[0]
function bed_tweaks:pick/menu
