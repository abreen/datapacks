# Moves the player to a safe spot next to this half of the bed, returning 1, or fails
execute positioned ~1 ~ ~ if function bed_tweaks:pick/standable run return run function bed_tweaks:pick/teleport
execute positioned ~-1 ~ ~ if function bed_tweaks:pick/standable run return run function bed_tweaks:pick/teleport
execute positioned ~ ~ ~1 if function bed_tweaks:pick/standable run return run function bed_tweaks:pick/teleport
execute positioned ~ ~ ~-1 if function bed_tweaks:pick/standable run return run function bed_tweaks:pick/teleport
execute positioned ~1 ~ ~1 if function bed_tweaks:pick/standable run return run function bed_tweaks:pick/teleport
execute positioned ~1 ~ ~-1 if function bed_tweaks:pick/standable run return run function bed_tweaks:pick/teleport
execute positioned ~-1 ~ ~1 if function bed_tweaks:pick/standable run return run function bed_tweaks:pick/teleport
execute positioned ~-1 ~ ~-1 if function bed_tweaks:pick/standable run return run function bed_tweaks:pick/teleport
return fail
