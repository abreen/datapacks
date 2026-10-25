# Privately tells the dying player what they lost. Runs as the player tagged
# death_tweaks.dying, after the lost stacks have been tagged death_tweaks.lost and
# xp/lose has set #xp_lost_levels and #xp_lost_points
execute store result score #lost death_tweaks.tmp if entity @e[type=item,tag=death_tweaks.lost]

execute if score #lost death_tweaks.tmp matches 1 run tellraw @s {text:"You lost 1 stack when you died:",color:"gray",italic:true}
execute if score #lost death_tweaks.tmp matches 2.. run tellraw @s [{text:"You lost ",color:"gray",italic:true},{score:{name:"#lost",objective:"death_tweaks.tmp"}}," stacks when you died:"]

execute as @e[type=item,tag=death_tweaks.dropped] run function death_tweaks:notify_line {suffix:""}
execute as @e[type=item,tag=death_tweaks.destroyed] run function death_tweaks:notify_line {suffix:" (destroyed)"}
execute as @e[type=item,tag=death_tweaks.vanished] run function death_tweaks:notify_line {suffix:" (vanished)"}

execute if score #destroy death_tweaks.config matches 0 run function death_tweaks:notify_xp {suffix:""}
execute if score #destroy death_tweaks.config matches 1 run function death_tweaks:notify_xp {suffix:" (destroyed)"}
