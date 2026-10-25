# Runs as a lost item entity; sends the dying player one line naming it.
# Argument: suffix
execute store result score #count stack_loss.tmp run data get entity @s Item.count

# An item entity's own name ignores custom_name (renamed items), so show it directly
$execute if data entity @s Item.components."minecraft:custom_name" run return run tellraw @a[tag=stack_loss.dying,limit=1] [{text:"  ",color:"gray",italic:true},{score:{name:"#count",objective:"stack_loss.tmp"}},"× ",{nbt:'Item.components."minecraft:custom_name"',entity:"@s",interpret:true},"$(suffix)"]
$tellraw @a[tag=stack_loss.dying,limit=1] [{text:"  ",color:"gray",italic:true},{score:{name:"#count",objective:"stack_loss.tmp"}},"× ",{selector:"@s"},"$(suffix)"]
