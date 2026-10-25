# Runs at a catcher's hopper
execute store result score #slot boltcatcher.tmp run function boltcatcher:catch/free_slot
execute if score #slot boltcatcher.tmp matches 0 run return run function boltcatcher:catch/fail
scoreboard players remove #slot boltcatcher.tmp 1
execute store result storage boltcatcher:tmp catch.slot int 1 run scoreboard players get #slot boltcatcher.tmp

scoreboard players operation #start boltcatcher.tmp = #start_charge boltcatcher.config
scoreboard players operation #start boltcatcher.tmp < #max_charge boltcatcher.config
execute store result storage boltcatcher:tmp catch.max int 1 run scoreboard players get #max_charge boltcatcher.config
scoreboard players operation #damage boltcatcher.tmp = #max_charge boltcatcher.config
scoreboard players operation #damage boltcatcher.tmp -= #start boltcatcher.tmp
execute store result storage boltcatcher:tmp catch.damage int 1 run scoreboard players get #damage boltcatcher.tmp
# The charge is kept as the game time it runs out, so it keeps draining in
# chests and unloaded chunks and is caught up the next time it's seen
scoreboard players operation #expires boltcatcher.tmp = #start boltcatcher.tmp
scoreboard players operation #expires boltcatcher.tmp *= #20 boltcatcher.tmp
scoreboard players operation #expires boltcatcher.tmp += #now boltcatcher.tmp
execute store result storage boltcatcher:tmp catch.expires int 1 run scoreboard players get #expires boltcatcher.tmp
function boltcatcher:catch/insert with storage boltcatcher:tmp catch

# A marker keeps the star's bar up to date while it waits in the hopper
execute unless entity @e[type=minecraft:marker,tag=boltcatcher.catcher,distance=..0.5] run summon minecraft:marker ~ ~ ~ {Tags:["boltcatcher.catcher"]}
particle minecraft:electric_spark ~ ~1.5 ~ 0.3 1 0.3 0.5 40
playsound minecraft:block.beacon.power_select block @a ~ ~ ~ 1 2
tellraw @a[distance=..32] {text:"Lightning crackles in a hopper nearby.",color:"gray",italic:true}
