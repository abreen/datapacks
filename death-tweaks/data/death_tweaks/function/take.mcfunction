# Removes from the player's slot as many items as the lost copy (tagged
# death_tweaks.new) holds; split set #count to the original stack size.
# Argument: slot
execute store result score #taken death_tweaks.tmp run data get entity @e[type=item,tag=death_tweaks.new,limit=1] Item.count
$execute if score #taken death_tweaks.tmp >= #count death_tweaks.tmp run return run item replace entity @s $(slot) with air

$data modify storage death_tweaks:tmp take.slot set value "$(slot)"
execute store result storage death_tweaks:tmp take.count int -1 run scoreboard players get #taken death_tweaks.tmp
function death_tweaks:take_partial with storage death_tweaks:tmp take
