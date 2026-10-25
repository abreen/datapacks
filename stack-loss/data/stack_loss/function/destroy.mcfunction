# Deletes one slot's stack. Arguments: slot, and tag (the reason, used by
# notify). A temporary copy is spawned at the player so notify can name the
# item; on_death kills it afterwards.
$execute at @s run summon item ~ ~ ~ {Item:{id:"minecraft:stone",count:1},PickupDelay:32767s,NoGravity:1b,Tags:["stack_loss.new","stack_loss.lost","$(tag)"]}
$item replace entity @e[type=item,tag=stack_loss.new,limit=1] contents from entity @s $(slot)
tag @e[type=item,tag=stack_loss.new] remove stack_loss.new
$item replace entity @s $(slot) with air
