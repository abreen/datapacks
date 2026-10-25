# Sets #dist to the horizontal distance from (#px, #pz) to mine[0]
execute store result score #dx bed_tweaks.tmp run data get storage bed_tweaks:tmp mine[0].x
execute store result score #dz bed_tweaks.tmp run data get storage bed_tweaks:tmp mine[0].z
scoreboard players operation #dx bed_tweaks.tmp -= #px bed_tweaks.tmp
scoreboard players operation #dz bed_tweaks.tmp -= #pz bed_tweaks.tmp
execute if score #dx bed_tweaks.tmp matches ..-1 run scoreboard players operation #dx bed_tweaks.tmp *= #-1 bed_tweaks.tmp
execute if score #dz bed_tweaks.tmp matches ..-1 run scoreboard players operation #dz bed_tweaks.tmp *= #-1 bed_tweaks.tmp

# Squaring overflows past about 46,000 blocks, so measure long distances in
# units of 1,024 blocks
scoreboard players set #unit bed_tweaks.tmp 1
execute if score #dx bed_tweaks.tmp matches 30001.. run scoreboard players set #unit bed_tweaks.tmp 1024
execute if score #dz bed_tweaks.tmp matches 30001.. run scoreboard players set #unit bed_tweaks.tmp 1024
scoreboard players operation #dx bed_tweaks.tmp /= #unit bed_tweaks.tmp
scoreboard players operation #dz bed_tweaks.tmp /= #unit bed_tweaks.tmp

scoreboard players operation #n bed_tweaks.tmp = #dx bed_tweaks.tmp
scoreboard players operation #n bed_tweaks.tmp *= #dx bed_tweaks.tmp
scoreboard players operation #dz bed_tweaks.tmp *= #dz bed_tweaks.tmp
scoreboard players operation #n bed_tweaks.tmp += #dz bed_tweaks.tmp
scoreboard players operation #dist bed_tweaks.tmp = #n bed_tweaks.tmp
execute if score #n bed_tweaks.tmp matches 2.. run function bed_tweaks:pick/sqrt
scoreboard players operation #dist bed_tweaks.tmp *= #unit bed_tweaks.tmp
