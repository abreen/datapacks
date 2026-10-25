# Tells the dying player how much experience was destroyed
execute if score #xp_lost_levels death_tweaks.tmp matches 1 run return run tellraw @s {text:"1 level of experience was destroyed.",color:"red",italic:true}
execute if score #xp_lost_levels death_tweaks.tmp matches 2.. run return run tellraw @s [{score:{name:"#xp_lost_levels",objective:"death_tweaks.tmp"},color:"red",italic:true},{text:" levels of experience were destroyed.",color:"red",italic:true}]
execute if score #xp_lost_points death_tweaks.tmp matches 1 run return run tellraw @s {text:"1 experience point was destroyed.",color:"red",italic:true}
execute if score #xp_lost_points death_tweaks.tmp matches 2.. run tellraw @s [{score:{name:"#xp_lost_points",objective:"death_tweaks.tmp"},color:"red",italic:true},{text:" experience points were destroyed.",color:"red",italic:true}]
