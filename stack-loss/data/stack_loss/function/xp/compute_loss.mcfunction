# From #level and #points (progress into that level), sets #xp_total,
# #xp_lost_points (#xp_loss percent of the total) and #xp_keep
function stack_loss:xp/points_for_level
scoreboard players operation #xp_total stack_loss.tmp += #points stack_loss.tmp

# total * percent / 100, split into quotient and remainder to avoid overflow
scoreboard players operation #xp_lost_points stack_loss.tmp = #xp_total stack_loss.tmp
scoreboard players operation #xp_lost_points stack_loss.tmp /= #100 stack_loss.tmp
scoreboard players operation #xp_lost_points stack_loss.tmp *= #xp_loss stack_loss.config
scoreboard players operation #rem stack_loss.tmp = #xp_total stack_loss.tmp
scoreboard players operation #rem stack_loss.tmp %= #100 stack_loss.tmp
scoreboard players operation #rem stack_loss.tmp *= #xp_loss stack_loss.config
scoreboard players operation #rem stack_loss.tmp /= #100 stack_loss.tmp
scoreboard players operation #xp_lost_points stack_loss.tmp += #rem stack_loss.tmp

scoreboard players operation #xp_keep stack_loss.tmp = #xp_total stack_loss.tmp
scoreboard players operation #xp_keep stack_loss.tmp -= #xp_lost_points stack_loss.tmp
