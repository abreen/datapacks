# Spawns orbs worth #xp_lost_points at the current position. An orb's Value is
# a short, so large amounts become a 32767-point orb with a Count plus one
# orb for the remainder. Returns 1 if the orbs spawned
scoreboard players operation #orb_count stack_loss.tmp = #xp_lost_points stack_loss.tmp
scoreboard players operation #orb_count stack_loss.tmp /= #32767 stack_loss.tmp
scoreboard players operation #orb_rem stack_loss.tmp = #xp_lost_points stack_loss.tmp
scoreboard players operation #orb_rem stack_loss.tmp %= #32767 stack_loss.tmp
execute store result storage stack_loss:tmp orb.count int 1 run scoreboard players get #orb_count stack_loss.tmp
execute store result storage stack_loss:tmp orb.rem int 1 run scoreboard players get #orb_rem stack_loss.tmp
function stack_loss:xp/summon_orbs with storage stack_loss:tmp orb

execute store result score #orb_ok stack_loss.tmp if entity @e[type=experience_orb,tag=stack_loss.new]
tag @e[type=experience_orb,tag=stack_loss.new] remove stack_loss.new
return run scoreboard players get #orb_ok stack_loss.tmp
