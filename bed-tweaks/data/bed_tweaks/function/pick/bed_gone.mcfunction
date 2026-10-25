# The picked bed was broken while its chunk was unloaded, or just now.
# Forgetting it tells the player
kill @e[type=marker,tag=bed_tweaks.bed,distance=..0.1]
function bed_tweaks:bed/unlabel
function bed_tweaks:bed/forget with storage bed_tweaks:tmp target
function bed_tweaks:pick/stop
function bed_tweaks:pick/retry
