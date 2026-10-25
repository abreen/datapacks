# Tells the dying player how much experience they lost. Argument: suffix
$execute if score #xp_lost_levels stack_loss.tmp matches 1 run return run tellraw @s {text:"You lost 1 level of experience$(suffix).",color:"gray",italic:true}
$execute if score #xp_lost_levels stack_loss.tmp matches 2.. run return run tellraw @s [{text:"You lost ",color:"gray",italic:true},{score:{name:"#xp_lost_levels",objective:"stack_loss.tmp"}}," levels of experience$(suffix)."]
$execute if score #xp_lost_points stack_loss.tmp matches 1.. run tellraw @s [{text:"You lost ",color:"gray",italic:true},{score:{name:"#xp_lost_points",objective:"stack_loss.tmp"}}," experience points$(suffix)."]
