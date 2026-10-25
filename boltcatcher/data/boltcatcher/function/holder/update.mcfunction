# Updates every star the holder carries, adding #bonus ticks to each
scoreboard players set #best boltcatcher.tmp 0
scoreboard players set #fizzled boltcatcher.tmp 0
data modify storage boltcatcher:tmp stars set value []
data modify storage boltcatcher:tmp stars append from entity @s Inventory[{components:{"minecraft:custom_data":{boltcatcher:{}}}}]
execute if items entity @s weapon.offhand *[minecraft:custom_data~{boltcatcher:{}}] run function boltcatcher:holder/add_offhand
data modify storage boltcatcher:tmp args.target set value "entity @s"
execute if data storage boltcatcher:tmp stars[0] run function boltcatcher:star/each
execute if score #fizzled boltcatcher.tmp matches 1.. run tellraw @s {text:"The lightning fizzled out.",color:"gray",italic:true}
execute if score #best boltcatcher.tmp matches 1.. run function boltcatcher:bar/update
