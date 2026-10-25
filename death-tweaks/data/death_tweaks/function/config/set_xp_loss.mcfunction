# Usage: /function death_tweaks:config/set_xp_loss {percent:30}
$scoreboard players set #xp_loss death_tweaks.config $(percent)
execute if score #xp_loss death_tweaks.config matches ..-1 run scoreboard players set #xp_loss death_tweaks.config 0
execute if score #xp_loss death_tweaks.config matches 101.. run scoreboard players set #xp_loss death_tweaks.config 100
function death_tweaks:config/show
