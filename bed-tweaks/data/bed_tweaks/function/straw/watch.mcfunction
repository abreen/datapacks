# Runs each tick as a player who lay down in a straw bed
execute store result score #now bed_tweaks.tmp run time query time
execute if data entity @s sleeping_pos run return run scoreboard players operation @s bed_tweaks.slept = #now bed_tweaks.tmp

# Awake again. Skipping the night jumps the clock to morning, so a jump
# means the sleep worked rather than the player getting up early
scoreboard players operation #now bed_tweaks.tmp -= @s bed_tweaks.slept
scoreboard players reset @s bed_tweaks.slept
execute if score #now bed_tweaks.tmp matches 2.. run function bed_tweaks:pick/open {question:"Travel to one of your beds?"}
