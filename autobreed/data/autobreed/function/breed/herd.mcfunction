# Tags every animal of this one's species within 24 blocks (babies included)
# with autobreed.herd. Entity data has no "id" to pass to a macro, so each
# species in #autobreed:livestock needs a line here.
execute if entity @s[type=minecraft:cow] run return run tag @e[type=minecraft:cow,distance=..24] add autobreed.herd
execute if entity @s[type=minecraft:mooshroom] run return run tag @e[type=minecraft:mooshroom,distance=..24] add autobreed.herd
execute if entity @s[type=minecraft:sheep] run return run tag @e[type=minecraft:sheep,distance=..24] add autobreed.herd
execute if entity @s[type=minecraft:pig] run return run tag @e[type=minecraft:pig,distance=..24] add autobreed.herd
execute if entity @s[type=minecraft:chicken] run return run tag @e[type=minecraft:chicken,distance=..24] add autobreed.herd
execute if entity @s[type=minecraft:goat] run return run tag @e[type=minecraft:goat,distance=..24] add autobreed.herd
execute if entity @s[type=minecraft:rabbit] run return run tag @e[type=minecraft:rabbit,distance=..24] add autobreed.herd
