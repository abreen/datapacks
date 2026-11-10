# Usage: /function autobreed:config/set_chance {percent:50}
# Chance (0-100%) that an attempt with room and a partner breeds a pair
$scoreboard players set #new autobreed.tmp $(percent)
execute if score #new autobreed.tmp matches ..-1 run scoreboard players set #new autobreed.tmp 0
execute if score #new autobreed.tmp matches 101.. run scoreboard players set #new autobreed.tmp 100
scoreboard players operation #chance autobreed.config = #new autobreed.tmp
function autobreed:config/show
