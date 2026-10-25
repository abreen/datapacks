tag @s add boltcatcher.charged
attribute @s minecraft:fall_damage_multiplier modifier add boltcatcher:fall -1 add_multiplied_base
# Sprint up one-block ledges without jumping
attribute @s minecraft:step_height modifier add boltcatcher:step 0.5 add_value
function boltcatcher:power/scaled
# Damage dealt before picking it up doesn't count
scoreboard players set @s boltcatcher.dealt 0
scoreboard players set @s boltcatcher.kills 0
scoreboard players set @s boltcatcher.kill_sound 0
playsound minecraft:block.beacon.activate player @s ~ ~ ~ 0.6 2
tellraw @s {text:"The lightning crackles in your hands. Keep fighting to keep it charged.",color:"gray",italic:true}
scoreboard players set #bonus boltcatcher.tmp 0
function boltcatcher:holder/update
effect give @s minecraft:glowing 2 0 true
