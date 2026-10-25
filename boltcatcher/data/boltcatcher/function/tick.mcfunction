execute store result score #now boltcatcher.tmp run time query gametime
execute as @e[type=minecraft:lightning_bolt,tag=!boltcatcher.seen] at @s run function boltcatcher:catch/bolt
execute as @a[tag=!boltcatcher.charged] if function boltcatcher:holder/has_star at @s run function boltcatcher:power/on
execute as @a[tag=boltcatcher.charged] unless function boltcatcher:holder/has_star run function boltcatcher:power/off
execute as @a[tag=boltcatcher.charged,scores={boltcatcher.kill_sound=1..}] at @s run function boltcatcher:holder/kill_sound
execute as @a[tag=boltcatcher.charged] run function boltcatcher:holder/feed
execute as @a[tag=boltcatcher.charged] at @s run particle minecraft:electric_spark ~ ~1 ~ 0.3 0.5 0.3 0.05 1
scoreboard players add #tick boltcatcher.tmp 1
execute if score #tick boltcatcher.tmp matches 20.. run function boltcatcher:second
