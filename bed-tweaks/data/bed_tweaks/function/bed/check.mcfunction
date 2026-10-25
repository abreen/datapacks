# Runs as each bed marker in a loaded chunk, every tick
# Markers left from before an uninstall lost their id with the scoreboard
execute unless score @s bed_tweaks.bed matches -2147483648.. run return run function bed_tweaks:bed/remove
execute unless block ~ ~ ~ #minecraft:beds[part=foot] run return run function bed_tweaks:bed/broken
function bed_tweaks:bed/label
