# Usage: /function bed_tweaks:config/set_choose_time {seconds:60}
$scoreboard players set #choose_seconds bed_tweaks.config $(seconds)
execute if score #choose_seconds bed_tweaks.config matches ..-1 run scoreboard players set #choose_seconds bed_tweaks.config 0
execute if score #choose_seconds bed_tweaks.config matches 3601.. run scoreboard players set #choose_seconds bed_tweaks.config 3600
function bed_tweaks:config/show
