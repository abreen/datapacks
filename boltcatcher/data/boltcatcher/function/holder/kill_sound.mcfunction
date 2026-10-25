# A kill recharges the lightning (the charge itself is added each second).
# The sound event picks one of its two variants at random.
scoreboard players set @s boltcatcher.kill_sound 0
execute if score #kill_bonus boltcatcher.config matches 1.. run playsound minecraft:item.bottle.fill_dragonbreath player @s ~ ~ ~ 1 1
