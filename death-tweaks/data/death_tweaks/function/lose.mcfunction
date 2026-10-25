# Removes some or all of one slot's stack, dropping it at the current position
# unless configured to destroy it. Argument: slot
# Destroyed items get a temporary copy at the player so notify can name them;
# on_death kills it afterwards
execute if score #destroy death_tweaks.config matches 1 at @s run summon item ~ ~ ~ {Item:{id:"minecraft:stone",count:1},PickupDelay:32767s,NoGravity:1b,Tags:["death_tweaks.new","death_tweaks.lost","death_tweaks.destroyed"]}
execute if score #destroy death_tweaks.config matches 0 run summon item ~ ~ ~ {Item:{id:"minecraft:stone",count:1},PickupDelay:40s,Tags:["death_tweaks.new","death_tweaks.lost","death_tweaks.dropped"]}
$item replace entity @e[type=item,tag=death_tweaks.new,limit=1] contents from entity @s $(slot)
execute as @e[type=item,tag=death_tweaks.new] run function death_tweaks:split
# A destroyed shulker box drops its contents rather than taking them with it
execute if score #destroy death_tweaks.config matches 1 as @e[type=item,tag=death_tweaks.new] if items entity @s contents #minecraft:shulker_boxes run function death_tweaks:empty_box

# If the drop couldn't spawn (e.g. death location is in an unloaded chunk),
# leave the stack in the player's inventory rather than deleting it
$execute if entity @e[type=item,tag=death_tweaks.new] run function death_tweaks:take {slot:"$(slot)"}
tag @e[type=item,tag=death_tweaks.new] remove death_tweaks.new
