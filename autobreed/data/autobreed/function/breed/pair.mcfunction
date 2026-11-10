# Finds the nearest free adult of the same species within 8 blocks, how far
# vanilla breeding looks for a partner. Entity data has no "id" to pass to a
# macro, so each species in #autobreed:livestock needs a line here.
execute if entity @s[type=minecraft:cow] as @e[type=minecraft:cow,tag=!autobreed.first,distance=..8,nbt={Age:0,InLove:0},sort=nearest,limit=1] at @s run return run function autobreed:breed/partner
execute if entity @s[type=minecraft:mooshroom] as @e[type=minecraft:mooshroom,tag=!autobreed.first,distance=..8,nbt={Age:0,InLove:0},sort=nearest,limit=1] at @s run return run function autobreed:breed/partner
execute if entity @s[type=minecraft:sheep] as @e[type=minecraft:sheep,tag=!autobreed.first,distance=..8,nbt={Age:0,InLove:0},sort=nearest,limit=1] at @s run return run function autobreed:breed/partner
execute if entity @s[type=minecraft:pig] as @e[type=minecraft:pig,tag=!autobreed.first,distance=..8,nbt={Age:0,InLove:0},sort=nearest,limit=1] at @s run return run function autobreed:breed/partner
execute if entity @s[type=minecraft:chicken] as @e[type=minecraft:chicken,tag=!autobreed.first,distance=..8,nbt={Age:0,InLove:0},sort=nearest,limit=1] at @s run return run function autobreed:breed/partner
execute if entity @s[type=minecraft:goat] as @e[type=minecraft:goat,tag=!autobreed.first,distance=..8,nbt={Age:0,InLove:0},sort=nearest,limit=1] at @s run return run function autobreed:breed/partner
execute if entity @s[type=minecraft:rabbit] as @e[type=minecraft:rabbit,tag=!autobreed.first,distance=..8,nbt={Age:0,InLove:0},sort=nearest,limit=1] at @s run return run function autobreed:breed/partner
