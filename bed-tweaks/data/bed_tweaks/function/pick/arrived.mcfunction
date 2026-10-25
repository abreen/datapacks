# The player has been moved. Arguments: owner, name
$data modify storage bed_tweaks:tmp waiting[{owner:$(owner)}].arrived set value 1b
scoreboard players set @s bed_tweaks.wait 0
$tellraw @s [{text:"You wake up at your ",color:"gray",italic:true},{translate:"$(name)"},"."]
