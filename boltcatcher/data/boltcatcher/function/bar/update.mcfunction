# Shows the holder's fullest star (#best of #best_max seconds) to everyone
execute unless score @s boltcatcher.id matches 1.. run function boltcatcher:bar/new_id
execute store result storage boltcatcher:tmp bar.id int 1 run scoreboard players get @s boltcatcher.id
execute store result storage boltcatcher:tmp bar.value int 1 run scoreboard players get #best boltcatcher.tmp
execute store result storage boltcatcher:tmp bar.max int 1 run scoreboard players get #best_max boltcatcher.tmp
# Red for the last quarter of a full charge
data modify storage boltcatcher:tmp bar.color set value "yellow"
scoreboard players operation #quarter boltcatcher.tmp = #best boltcatcher.tmp
scoreboard players operation #quarter boltcatcher.tmp *= #4 boltcatcher.tmp
execute if score #quarter boltcatcher.tmp <= #best_max boltcatcher.tmp run data modify storage boltcatcher:tmp bar.color set value "red"
scoreboard players operation #mins boltcatcher.tmp = #best boltcatcher.tmp
scoreboard players operation #mins boltcatcher.tmp /= #60 boltcatcher.tmp
scoreboard players operation #sec boltcatcher.tmp = #best boltcatcher.tmp
scoreboard players operation #sec boltcatcher.tmp %= #60 boltcatcher.tmp
function boltcatcher:bar/show with storage boltcatcher:tmp bar
