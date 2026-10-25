# From #level and #points (progress into that level), sets #xp_total,
# #xp_lost_points (#xp_loss percent of the total) and #xp_keep
function death_tweaks:xp/points_for_level
scoreboard players operation #xp_total death_tweaks.tmp += #points death_tweaks.tmp

# total * percent / 100, split into quotient and remainder to avoid overflow
scoreboard players operation #xp_lost_points death_tweaks.tmp = #xp_total death_tweaks.tmp
scoreboard players operation #xp_lost_points death_tweaks.tmp /= #100 death_tweaks.tmp
scoreboard players operation #xp_lost_points death_tweaks.tmp *= #xp_loss death_tweaks.config
scoreboard players operation #rem death_tweaks.tmp = #xp_total death_tweaks.tmp
scoreboard players operation #rem death_tweaks.tmp %= #100 death_tweaks.tmp
scoreboard players operation #rem death_tweaks.tmp *= #xp_loss death_tweaks.config
scoreboard players operation #rem death_tweaks.tmp /= #100 death_tweaks.tmp
scoreboard players operation #xp_lost_points death_tweaks.tmp += #rem death_tweaks.tmp

scoreboard players operation #xp_keep death_tweaks.tmp = #xp_total death_tweaks.tmp
scoreboard players operation #xp_keep death_tweaks.tmp -= #xp_lost_points death_tweaks.tmp
