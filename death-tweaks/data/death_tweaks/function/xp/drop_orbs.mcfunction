# Spawns orbs worth #xp_lost_points at the current position. An orb's Value is
# a short, so large amounts become a 32767-point orb with a Count plus one
# orb for the remainder. Returns 1 if the orbs spawned
scoreboard players operation #orb_count death_tweaks.tmp = #xp_lost_points death_tweaks.tmp
scoreboard players operation #orb_count death_tweaks.tmp /= #32767 death_tweaks.tmp
scoreboard players operation #orb_rem death_tweaks.tmp = #xp_lost_points death_tweaks.tmp
scoreboard players operation #orb_rem death_tweaks.tmp %= #32767 death_tweaks.tmp
execute store result storage death_tweaks:tmp orb.count int 1 run scoreboard players get #orb_count death_tweaks.tmp
execute store result storage death_tweaks:tmp orb.rem int 1 run scoreboard players get #orb_rem death_tweaks.tmp
function death_tweaks:xp/summon_orbs with storage death_tweaks:tmp orb

execute store result score #orb_ok death_tweaks.tmp if entity @e[type=experience_orb,tag=death_tweaks.new]
tag @e[type=experience_orb,tag=death_tweaks.new] remove death_tweaks.new
return run scoreboard players get #orb_ok death_tweaks.tmp
