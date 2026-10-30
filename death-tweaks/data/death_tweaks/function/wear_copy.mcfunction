# Runs as the temporary copy of a damageable item. Adds a random 0 to
# #durability_loss percent of its max durability as damage, but at least 1
execute store result score #damage death_tweaks.tmp run data get entity @s Item.components."minecraft:damage"
execute store result storage death_tweaks:tmp wear.max float 0.01 run scoreboard players get #durability_loss death_tweaks.tmp
function death_tweaks:wear_apply with storage death_tweaks:tmp wear
execute store result score #damage_after death_tweaks.tmp run data get entity @s Item.components."minecraft:damage"
execute if score #damage_after death_tweaks.tmp > #damage death_tweaks.tmp run return 0
# Rounding can leave a small loss at zero damage
execute store result storage death_tweaks:tmp wear.damage int 1 run scoreboard players add #damage death_tweaks.tmp 1
function death_tweaks:wear_set with storage death_tweaks:tmp wear
