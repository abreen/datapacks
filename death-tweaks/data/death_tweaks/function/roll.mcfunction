# Decides the fate of one inventory slot. Argument: slot (e.g. "hotbar.0")
$execute unless items entity @s $(slot) * run return 0

# Vanilla destroys Curse of Vanishing items on death only when keep_inventory
# is off, so emulate that here
$execute if score #vanishing_curse death_tweaks.config matches 1 if items entity @s $(slot) *[minecraft:enchantments~[{enchantments:"minecraft:vanishing_curse"}]] run return run function death_tweaks:destroy {slot:"$(slot)",tag:"death_tweaks.vanished"}

$execute if items entity @s $(slot) #death_tweaks:protected run return 0

execute store result score #roll death_tweaks.tmp run random value 1..100
$execute if score #roll death_tweaks.tmp <= #chance death_tweaks.tmp run function death_tweaks:lose {slot:"$(slot)"}
