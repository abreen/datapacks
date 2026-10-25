# Shows the player a menu of their beds, one of which they can pick within
# #choose_seconds to be moved there. Argument: question
execute if score @s bed_tweaks.wait matches 0.. run function bed_tweaks:pick/cancel
function bed_tweaks:pick/close
execute if score #choose_seconds bed_tweaks.config matches ..0 run return 0

data modify storage bed_tweaks:tmp args.owner set from entity @s UUID
function bed_tweaks:pick/collect with storage bed_tweaks:tmp args
data modify storage bed_tweaks:tmp here set from entity @s Dimension
execute store result score #px bed_tweaks.tmp run data get entity @s Pos[0]
execute store result score #pz bed_tweaks.tmp run data get entity @s Pos[2]
data modify storage bed_tweaks:tmp menu set value []
function bed_tweaks:pick/menu
execute unless data storage bed_tweaks:tmp menu[0] run return 0

$tellraw @s [{text:"$(question) You have ",color:"gray",italic:true},{score:{name:"#choose_seconds",objective:"bed_tweaks.config"}}," seconds: ",{storage:"bed_tweaks:tmp",nbt:"menu[]",interpret:true,separator:" "}]
scoreboard players enable @s bed_tweaks.pick
scoreboard players operation @s bed_tweaks.window = #choose_seconds bed_tweaks.config
scoreboard players operation @s bed_tweaks.window *= #20 bed_tweaks.tmp
