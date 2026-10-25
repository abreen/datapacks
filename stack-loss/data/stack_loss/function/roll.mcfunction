# Decides the fate of one inventory slot. Argument: slot (e.g. "hotbar.0")
$execute unless items entity @s $(slot) * run return 0

# Vanilla destroys Curse of Vanishing items on death only when keep_inventory
# is off, so emulate that here
$execute if score #vanishing_curse stack_loss.config matches 1 if items entity @s $(slot) *[minecraft:enchantments~[{enchantments:"minecraft:vanishing_curse"}]] run return run item replace entity @s $(slot) with air

$execute if items entity @s $(slot) #stack_loss:protected run return 0

execute store result score #roll stack_loss.tmp run random value 1..100
$execute if score #roll stack_loss.tmp <= #chance stack_loss.config run function stack_loss:lose {slot:"$(slot)"}
