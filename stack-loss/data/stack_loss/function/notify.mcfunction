# Privately tells the dying player which stacks they lost. Runs as the player
# tagged stack_loss.dying, after the lost stacks have been tagged stack_loss.lost
execute store result score #lost stack_loss.tmp if entity @e[type=item,tag=stack_loss.lost]
execute if score #lost stack_loss.tmp matches 0 run return 0

execute if score #lost stack_loss.tmp matches 1 run tellraw @s {text:"You lost 1 stack when you died:",color:"gray",italic:true}
execute if score #lost stack_loss.tmp matches 2.. run tellraw @s [{text:"You lost ",color:"gray",italic:true},{score:{name:"#lost",objective:"stack_loss.tmp"}}," stacks when you died:"]

execute as @e[type=item,tag=stack_loss.dropped] run function stack_loss:notify_line {suffix:""}
execute as @e[type=item,tag=stack_loss.destroyed] run function stack_loss:notify_line {suffix:" (destroyed)"}
execute as @e[type=item,tag=stack_loss.vanished] run function stack_loss:notify_line {suffix:" (vanished)"}
