# Sets #xp_total to the experience points needed to reach #level, using the
# vanilla formula:
#   0-16:  L^2 + 6L
#   17-31: 2.5L^2 - 40.5L + 360  =  (L(5L - 81) + 720) / 2
#   32+:   4.5L^2 - 162.5L + 2220  =  (L(9L - 325) + 4440) / 2
scoreboard players operation #xp_total stack_loss.tmp = #level stack_loss.tmp
execute if score #level stack_loss.tmp matches 32.. run return run function stack_loss:xp/points_for_level_32_up
execute if score #level stack_loss.tmp matches 17.. run return run function stack_loss:xp/points_for_level_17_31
scoreboard players add #xp_total stack_loss.tmp 6
scoreboard players operation #xp_total stack_loss.tmp *= #level stack_loss.tmp
