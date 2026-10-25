scoreboard objectives add boltcatcher.config dummy
scoreboard objectives add boltcatcher.tmp dummy
# Damage is in tenths of a health point (20 per heart)
scoreboard objectives add boltcatcher.dealt minecraft.custom:minecraft.damage_dealt
scoreboard objectives add boltcatcher.kills minecraft.custom:minecraft.mob_kills
# A second kill counter, checked every tick so the kill sound is immediate
scoreboard objectives add boltcatcher.kill_sound minecraft.custom:minecraft.mob_kills
# Each holder's boss bar id; #next is the last one handed out
scoreboard objectives add boltcatcher.id dummy

# Defaults, only applied if not already configured
execute unless score #start_charge boltcatcher.config matches 0.. run scoreboard players set #start_charge boltcatcher.config 120
execute unless score #max_charge boltcatcher.config matches 0.. run scoreboard players set #max_charge boltcatcher.config 600
execute unless score #damage_bonus boltcatcher.config matches 0.. run scoreboard players set #damage_bonus boltcatcher.config 2
execute unless score #kill_bonus boltcatcher.config matches 0.. run scoreboard players set #kill_bonus boltcatcher.config 5
execute unless score #damage_percent boltcatcher.config matches 0.. run scoreboard players set #damage_percent boltcatcher.config 300
execute unless score #speed_percent boltcatcher.config matches 0.. run scoreboard players set #speed_percent boltcatcher.config 200
execute unless score #gravity_percent boltcatcher.config matches 0.. run scoreboard players set #gravity_percent boltcatcher.config 40

# Constants for scoreboard math
scoreboard players set #4 boltcatcher.tmp 4
scoreboard players set #20 boltcatcher.tmp 20
scoreboard players set #60 boltcatcher.tmp 60
