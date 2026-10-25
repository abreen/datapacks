# Usage: /function stack_loss:config/set_xp_loss {percent:30}
$scoreboard players set #xp_loss stack_loss.config $(percent)
execute if score #xp_loss stack_loss.config matches ..-1 run scoreboard players set #xp_loss stack_loss.config 0
execute if score #xp_loss stack_loss.config matches 101.. run scoreboard players set #xp_loss stack_loss.config 100
function stack_loss:config/show
