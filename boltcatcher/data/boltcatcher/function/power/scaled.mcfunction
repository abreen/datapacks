# (Re)applies the configurable modifiers, so a settings change reaches
# current holders. As percentages of normal, so 300% damage adds 2x.
scoreboard players operation #extra boltcatcher.tmp = #speed_percent boltcatcher.config
scoreboard players remove #extra boltcatcher.tmp 100
execute store result storage boltcatcher:tmp power.speed double 0.01 run scoreboard players get #extra boltcatcher.tmp
scoreboard players operation #extra boltcatcher.tmp = #damage_percent boltcatcher.config
scoreboard players remove #extra boltcatcher.tmp 100
execute store result storage boltcatcher:tmp power.damage double 0.01 run scoreboard players get #extra boltcatcher.tmp
scoreboard players operation #extra boltcatcher.tmp = #gravity_percent boltcatcher.config
scoreboard players remove #extra boltcatcher.tmp 100
execute store result storage boltcatcher:tmp power.gravity double 0.01 run scoreboard players get #extra boltcatcher.tmp
function boltcatcher:power/scaled_apply with storage boltcatcher:tmp power
