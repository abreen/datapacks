attribute @s minecraft:movement_speed modifier remove boltcatcher:speed
attribute @s minecraft:attack_damage modifier remove boltcatcher:damage
attribute @s minecraft:gravity modifier remove boltcatcher:gravity
$attribute @s minecraft:movement_speed modifier add boltcatcher:speed $(speed) add_multiplied_base
# Multiplies the total, so it scales the weapon's damage too
$attribute @s minecraft:attack_damage modifier add boltcatcher:damage $(damage) add_multiplied_total
$attribute @s minecraft:gravity modifier add boltcatcher:gravity $(gravity) add_multiplied_base
