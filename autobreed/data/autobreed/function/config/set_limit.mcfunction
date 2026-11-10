# Usage: /function autobreed:config/set_limit {animals:12}
# Animals stop breeding once this many farm animals (1-256), babies and the
# animal itself included, are within 8 blocks
$scoreboard players set #new autobreed.tmp $(animals)
execute if score #new autobreed.tmp matches ..0 run scoreboard players set #new autobreed.tmp 1
execute if score #new autobreed.tmp matches 257.. run scoreboard players set #new autobreed.tmp 256
scoreboard players operation #limit autobreed.config = #new autobreed.tmp
function autobreed:config/show
