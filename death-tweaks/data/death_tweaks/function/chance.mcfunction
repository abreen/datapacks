# Sets #chance (death_tweaks.tmp) to the configured chance for the current
# difficulty. `difficulty` with no argument returns 0 (peaceful) to 3 (hard)
execute store result score #difficulty death_tweaks.tmp run difficulty
execute if score #difficulty death_tweaks.tmp matches 0 run scoreboard players operation #chance death_tweaks.tmp = #chance_peaceful death_tweaks.config
execute if score #difficulty death_tweaks.tmp matches 1 run scoreboard players operation #chance death_tweaks.tmp = #chance_easy death_tweaks.config
execute if score #difficulty death_tweaks.tmp matches 2 run scoreboard players operation #chance death_tweaks.tmp = #chance_normal death_tweaks.config
execute if score #difficulty death_tweaks.tmp matches 3 run scoreboard players operation #chance death_tweaks.tmp = #chance_hard death_tweaks.config
