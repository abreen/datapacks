# Runs as the temporary copy of a destroyed shulker box, at the death
# location. Drops what was inside instead of destroying it with the box.
# If nothing could spawn (e.g. an unloaded chunk), kills the copy so lose
# leaves the box with the player
data modify storage death_tweaks:tmp box set from entity @s Item.components."minecraft:container"
execute unless data storage death_tweaks:tmp box[0] run return 0
scoreboard players set #box_dropped death_tweaks.tmp 0
function death_tweaks:empty_box_item
data remove storage death_tweaks:tmp box
execute if score #box_dropped death_tweaks.tmp matches 0 run kill @s
