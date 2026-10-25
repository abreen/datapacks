# One step of Newton's method, narrowing #dist down to floor(sqrt(#n))
scoreboard players operation #next bed_tweaks.tmp = #n bed_tweaks.tmp
scoreboard players operation #next bed_tweaks.tmp /= #dist bed_tweaks.tmp
scoreboard players operation #next bed_tweaks.tmp += #dist bed_tweaks.tmp
scoreboard players operation #next bed_tweaks.tmp /= #2 bed_tweaks.tmp
execute unless score #next bed_tweaks.tmp < #dist bed_tweaks.tmp run return 0
scoreboard players operation #dist bed_tweaks.tmp = #next bed_tweaks.tmp
function bed_tweaks:pick/sqrt
