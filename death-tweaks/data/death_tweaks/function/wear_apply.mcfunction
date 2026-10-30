# Argument: max (fraction of max durability, 0 to 1). With add, set_damage
# changes the remaining fraction, so a negative amount is damage
$item modify entity @s contents {type:"set_damage",damage:{type:"uniform",min:-$(max),max:0},add:true}
