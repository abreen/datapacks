execute as @e[type=marker,tag=bed_tweaks.bed] at @s run function bed_tweaks:bed/check
execute as @a[scores={bed_tweaks.deaths=1..,bed_tweaks.alive=1..}] at @s run function bed_tweaks:on_respawn
execute as @a[scores={bed_tweaks.straw=1..}] at @s run function bed_tweaks:straw/slept
execute as @a[scores={bed_tweaks.slept=-2147483648..}] at @s run function bed_tweaks:straw/watch
execute as @a[scores={bed_tweaks.pick=1..}] run function bed_tweaks:pick/choose
# @e skips dead players, who can't be moved; respawning cancels the wait
execute as @e[type=player,scores={bed_tweaks.wait=0..}] run function bed_tweaks:pick/wait
scoreboard players remove @a[scores={bed_tweaks.window=1..}] bed_tweaks.window 1
execute as @a[scores={bed_tweaks.window=0}] run function bed_tweaks:pick/close
