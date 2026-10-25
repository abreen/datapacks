# Tells the dying player how much experience they dropped as orbs
execute if score #xp_lost_levels death_tweaks.tmp matches 1 run return run tellraw @s {text:"You dropped 1 level of experience.",color:"gray",italic:true}
execute if score #xp_lost_levels death_tweaks.tmp matches 2.. run return run tellraw @s [{text:"You dropped ",color:"gray",italic:true},{score:{name:"#xp_lost_levels",objective:"death_tweaks.tmp"}}," levels of experience."]
execute if score #xp_lost_points death_tweaks.tmp matches 1 run return run tellraw @s {text:"You dropped 1 experience point.",color:"gray",italic:true}
execute if score #xp_lost_points death_tweaks.tmp matches 2.. run tellraw @s [{text:"You dropped ",color:"gray",italic:true},{score:{name:"#xp_lost_points",objective:"death_tweaks.tmp"}}," experience points."]
