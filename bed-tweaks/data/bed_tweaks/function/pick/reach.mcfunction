# Arguments: the fields of target (dim, x, y, z, owner, ...)
# After the move, keep any force-load for a second: teleporting adds no
# chunk ticket of its own, so the chunk could unload under the player
execute if data storage bed_tweaks:tmp target{arrived:1b} run return run function bed_tweaks:pick/settle

# The bed's chunk has to be loaded to check the bed. It usually isn't, so
# force-load it and try again each tick until it is
$execute in $(dim) if loaded $(x) $(y) $(z) positioned $(x) $(y) $(z) run return run function bed_tweaks:pick/at_bed
execute if score @s bed_tweaks.wait matches 100.. run return run function bed_tweaks:pick/give_up
$execute if data storage bed_tweaks:tmp target{forced:0b} in $(dim) run function bed_tweaks:pick/force {x:$(x),z:$(z),owner:$(owner)}
