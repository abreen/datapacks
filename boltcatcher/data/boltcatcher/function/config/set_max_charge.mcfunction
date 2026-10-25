# Usage: /function boltcatcher:config/set_max_charge {seconds:300}
# Applies to lightning caught from now on; each star keeps its own maximum
$scoreboard players set #new boltcatcher.tmp $(seconds)
execute if score #new boltcatcher.tmp matches ..9 run scoreboard players set #new boltcatcher.tmp 10
execute if score #new boltcatcher.tmp matches 3601.. run scoreboard players set #new boltcatcher.tmp 3600
scoreboard players operation #max_charge boltcatcher.config = #new boltcatcher.tmp
function boltcatcher:config/show
