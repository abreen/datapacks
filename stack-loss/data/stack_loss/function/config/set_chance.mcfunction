# Usage: /function stack_loss:config/set_chance {percent:30}
$scoreboard players set #chance stack_loss.config $(percent)
execute if score #chance stack_loss.config matches ..-1 run scoreboard players set #chance stack_loss.config 0
execute if score #chance stack_loss.config matches 101.. run scoreboard players set #chance stack_loss.config 100
function stack_loss:config/show
