# Takes durability from one slot's damageable item instead of losing it.
# Argument: slot. Item modifiers can't read values and max_damage isn't in
# NBT, so a temporary copy at the player is damaged and then put back. If it
# broke, the original is lost like any other stack instead. notify lists the
# copy (tagged death_tweaks.damaged); on_death kills it afterwards
execute at @s run summon item ~ ~ ~ {Item:{id:"minecraft:stone",count:1},PickupDelay:32767s,NoGravity:1b,Tags:["death_tweaks.new"]}
$item replace entity @e[type=item,tag=death_tweaks.new,limit=1] contents from entity @s $(slot)
execute unless entity @e[type=item,tag=death_tweaks.new] run return 0
execute as @e[type=item,tag=death_tweaks.new] run function death_tweaks:wear_copy
$execute if items entity @e[type=item,tag=death_tweaks.new,limit=1] contents *[minecraft:damage~{durability:{max:0}}] run return run function death_tweaks:wear_break {slot:"$(slot)"}
$item replace entity @s $(slot) from entity @e[type=item,tag=death_tweaks.new,limit=1] contents
tag @e[type=item,tag=death_tweaks.new] add death_tweaks.damaged
tag @e[type=item,tag=death_tweaks.new] remove death_tweaks.new
