scoreboard players set #tick boltcatcher.tmp 0
execute as @a[tag=boltcatcher.charged] at @s run function boltcatcher:holder/second
# Only damage dealt while charged counts
scoreboard players set @a[tag=!boltcatcher.charged] boltcatcher.dealt 0
scoreboard players set @a[tag=!boltcatcher.charged] boltcatcher.kills 0
scoreboard players set @a[tag=!boltcatcher.charged] boltcatcher.kill_sound 0
execute as @e[type=minecraft:marker,tag=boltcatcher.catcher] at @s run function boltcatcher:catcher/second
execute as @e[type=minecraft:item] if items entity @s contents *[minecraft:custom_data~{boltcatcher:{}}] at @s run function boltcatcher:star/item_entity
function boltcatcher:bar/sweep
