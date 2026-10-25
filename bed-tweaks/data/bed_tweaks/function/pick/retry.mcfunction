# Lets the player pick another bed if there's still time
execute if score @s bed_tweaks.window matches 1.. run scoreboard players enable @s bed_tweaks.pick
