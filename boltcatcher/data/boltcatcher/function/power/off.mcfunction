tag @s remove boltcatcher.charged
attribute @s minecraft:movement_speed modifier remove boltcatcher:speed
attribute @s minecraft:gravity modifier remove boltcatcher:gravity
attribute @s minecraft:attack_damage modifier remove boltcatcher:damage
attribute @s minecraft:fall_damage_multiplier modifier remove boltcatcher:fall
attribute @s minecraft:step_height modifier remove boltcatcher:step
execute unless score @s boltcatcher.id matches 1.. run return 0
execute store result storage boltcatcher:tmp bar.id int 1 run scoreboard players get @s boltcatcher.id
function boltcatcher:bar/remove with storage boltcatcher:tmp bar
