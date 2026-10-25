# Privately tells the dying player what they dropped and what was destroyed.
# Runs as the player tagged death_tweaks.dying, after the lost stacks have been
# tagged death_tweaks.lost and xp/lose has set #xp_lost_levels and #xp_lost_points
execute store result score #dropped death_tweaks.tmp if entity @e[type=item,tag=death_tweaks.dropped]
execute store result score #destroyed death_tweaks.tmp if entity @e[type=item,tag=death_tweaks.lost,tag=!death_tweaks.dropped]

execute if score #dropped death_tweaks.tmp matches 1 run tellraw @s {text:"You dropped this item:",color:"gray",italic:true}
execute if score #dropped death_tweaks.tmp matches 2.. run tellraw @s {text:"You dropped these items:",color:"gray",italic:true}
execute as @e[type=item,tag=death_tweaks.dropped] run function death_tweaks:notify_line {color:"gray",suffix:""}

execute if score #destroyed death_tweaks.tmp matches 1 run tellraw @s {text:"This item was destroyed:",color:"red",italic:true}
execute if score #destroyed death_tweaks.tmp matches 2.. run tellraw @s {text:"These items were destroyed:",color:"red",italic:true}
execute as @e[type=item,tag=death_tweaks.destroyed] run function death_tweaks:notify_line {color:"red",suffix:""}
execute as @e[type=item,tag=death_tweaks.vanished] run function death_tweaks:notify_line {color:"red",suffix:" (vanished)"}

execute if score #destroy death_tweaks.config matches 0 run function death_tweaks:notify_xp_dropped
execute if score #destroy death_tweaks.config matches 1 run function death_tweaks:notify_xp_destroyed
