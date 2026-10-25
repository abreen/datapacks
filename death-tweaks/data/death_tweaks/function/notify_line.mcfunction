# Runs as a lost item entity; sends the dying player one line naming it.
# Argument: suffix
execute store result score #count death_tweaks.tmp run data get entity @s Item.count

# An item entity's own name ignores custom_name (renamed items), so show it directly
$execute if data entity @s Item.components."minecraft:custom_name" run return run tellraw @a[tag=death_tweaks.dying,limit=1] [{text:"  ",color:"gray",italic:true},{score:{name:"#count",objective:"death_tweaks.tmp"}},"× ",{nbt:'Item.components."minecraft:custom_name"',entity:"@s",interpret:true},"$(suffix)"]
$tellraw @a[tag=death_tweaks.dying,limit=1] [{text:"  ",color:"gray",italic:true},{score:{name:"#count",objective:"death_tweaks.tmp"}},"× ",{selector:"@s"},"$(suffix)"]
