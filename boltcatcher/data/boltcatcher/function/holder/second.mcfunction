# Damage dealt is in tenths of a health point, 20 per heart, so with
# #damage_bonus seconds per heart each point is worth that many ticks
scoreboard players operation #bonus boltcatcher.tmp = @s boltcatcher.dealt
scoreboard players operation #bonus boltcatcher.tmp *= #damage_bonus boltcatcher.config
scoreboard players operation #kill boltcatcher.tmp = @s boltcatcher.kills
scoreboard players operation #kill boltcatcher.tmp *= #kill_bonus boltcatcher.config
scoreboard players operation #kill boltcatcher.tmp *= #20 boltcatcher.tmp
scoreboard players operation #bonus boltcatcher.tmp += #kill boltcatcher.tmp
scoreboard players set @s boltcatcher.dealt 0
scoreboard players set @s boltcatcher.kills 0
function boltcatcher:holder/update
effect give @s minecraft:glowing 2 0 true
