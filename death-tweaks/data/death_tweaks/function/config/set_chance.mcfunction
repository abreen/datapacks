# Usage: /function death_tweaks:config/set_chance {difficulty:"hard",percent:50}
# difficulty is peaceful, easy, normal or hard. load sets all four, so an
# unset score means a misspelled difficulty
$execute unless score #chance_$(difficulty) death_tweaks.config matches 0.. run return run tellraw @s [{text:"[Death Tweaks] ",color:"gold"},{text:"Unknown difficulty \"$(difficulty)\"; use peaceful, easy, normal or hard",color:"red"}]
$scoreboard players set #new death_tweaks.tmp $(percent)
execute if score #new death_tweaks.tmp matches ..-1 run scoreboard players set #new death_tweaks.tmp 0
execute if score #new death_tweaks.tmp matches 101.. run scoreboard players set #new death_tweaks.tmp 100
$scoreboard players operation #chance_$(difficulty) death_tweaks.config = #new death_tweaks.tmp
function death_tweaks:config/show
