# Usage: /function death_tweaks:config/set_chance {percent:30}
$scoreboard players set #chance death_tweaks.config $(percent)
execute if score #chance death_tweaks.config matches ..-1 run scoreboard players set #chance death_tweaks.config 0
execute if score #chance death_tweaks.config matches 101.. run scoreboard players set #chance death_tweaks.config 100
function death_tweaks:config/show
