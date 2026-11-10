# Usage: /function autobreed:config/set_interval {seconds:120}
# Seconds between breeding attempts by each adult (1-3600)
$scoreboard players set #new autobreed.tmp $(seconds)
execute if score #new autobreed.tmp matches ..0 run scoreboard players set #new autobreed.tmp 1
execute if score #new autobreed.tmp matches 3601.. run scoreboard players set #new autobreed.tmp 3600
scoreboard players operation #interval autobreed.config = #new autobreed.tmp
# Waits counting down from a longer interval would hide the change
scoreboard players operation @e[type=#autobreed:livestock] autobreed.wait < #interval autobreed.config
function autobreed:config/show
