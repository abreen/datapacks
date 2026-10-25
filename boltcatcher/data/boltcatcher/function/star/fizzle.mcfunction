$item replace $(target) $(slot) with minecraft:air
particle minecraft:electric_spark ~ ~0.5 ~ 0.3 0.3 0.3 0.2 15
playsound minecraft:block.fire.extinguish neutral @a ~ ~ ~ 0.5 1.5
scoreboard players add #fizzled boltcatcher.tmp 1
