# Runs as a player who has just respawned
scoreboard players reset @s bed_tweaks.deaths
function bed_tweaks:pick/open {question:"Respawn at another bed?"}
