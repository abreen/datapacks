# Removes one slot's stack, dropping it at the current position unless
# configured to destroy it. Argument: slot
$execute if score #destroy death_tweaks.config matches 1 run return run function death_tweaks:destroy {slot:"$(slot)",tag:"death_tweaks.destroyed"}

summon item ~ ~ ~ {Item:{id:"minecraft:stone",count:1},PickupDelay:40s,Tags:["death_tweaks.new","death_tweaks.lost","death_tweaks.dropped"]}
$item replace entity @e[type=item,tag=death_tweaks.new,limit=1] contents from entity @s $(slot)

# If the drop couldn't spawn (e.g. death location is in an unloaded chunk),
# leave the stack in the player's inventory rather than deleting it
$execute if entity @e[type=item,tag=death_tweaks.new] run item replace entity @s $(slot) with air
tag @e[type=item,tag=death_tweaks.new] remove death_tweaks.new
