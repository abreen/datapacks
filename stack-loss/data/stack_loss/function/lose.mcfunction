# Removes one slot's stack, dropping it at the current position unless
# configured to destroy it. Argument: slot
$execute if score #destroy stack_loss.config matches 1 run return run item replace entity @s $(slot) with air

summon item ~ ~ ~ {Item:{id:"minecraft:stone",count:1},PickupDelay:40s,Tags:["stack_loss.new"]}
$item replace entity @e[type=item,tag=stack_loss.new,limit=1] contents from entity @s $(slot)

# If the drop couldn't spawn (e.g. death location is in an unloaded chunk),
# leave the stack in the player's inventory rather than deleting it
$execute if entity @e[type=item,tag=stack_loss.new] run item replace entity @s $(slot) with air
tag @e[type=item,tag=stack_loss.new] remove stack_loss.new
