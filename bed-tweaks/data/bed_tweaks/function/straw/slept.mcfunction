# Runs as a player who just lay down in a straw bed
scoreboard players reset @s bed_tweaks.straw
execute if score #straw_beds bed_tweaks.config matches 1 store result score @s bed_tweaks.slept run time query time
